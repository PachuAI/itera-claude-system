# DB ops en producción via SSH tunnel

Método canónico para operar directamente la DB de producción desde local, usando un SSH tunnel al container de Postgres dentro de la red Docker del VPS. **No requiere exponer puertos** en Coolify ni en el host del VPS.

Cubre tres sub-casos que comparten la misma técnica de tunnel:

- Queries ad-hoc / inspección (`psql` interactivo)
- Backup (`pg_dump`)
- Restore (`pg_restore`)
- Conectar tools locales (DBeaver, Prisma Studio, scripts Node) a `localhost:5433`

**Reemplaza** el patrón legacy `ssh root@vps "docker exec <pg> psql|pg_dump ..."`. Los ejemplos legacy que siguen en `~/projects/itera-context/infra/vps-overview.md` quedan como **fallback** para debugging dentro del container (config, volúmenes), no como método preferido para ops de data.

---

## Cuándo usar este carril

- Verificar data en prod tras un seed o deploy
- Snapshot de DB antes de una operación riesgosa
- Refresh de DB local desde prod (restore)
- Conectar GUI tools (DBeaver, Postico, DataGrip, Prisma Studio)
- Scripts locales que hablan Postgres apuntando a prod

**No usar** para:

- Seed / creación de datos de aplicación → **carril API**, ver `guides/seed-via-api.md`
- Schema rollout (DDL, CREATE INDEX, ALTER TYPE, enums) → carril 3 unificado, ver `guides/db-schema-rollout.md`

---

## Prerequisitos

- SSH sin password al VPS (clave ed25519 ya autorizada — ver `itera-context/infra/local-setup.md`)
- Versiones locales de `psql`, `pg_dump`, `pg_restore` ≥ versión del server (en `pachu-desktop-linux`: Postgres 17.9 local, matchea los containers)
- `nc` (netcat) y `jq` disponibles
- Puerto local libre (usamos `5433` por default para no chocar con Postgres local en `5432`)

---

## Datos específicos por repo

El método es idéntico para todos los repos. Cambia solo:

- IP del VPS
- Contexto Coolify
- Container UUID del PG (estable entre deploys; es el UUID de Coolify)
- App UUID (para obtener `DATABASE_URL` del env del container de la app)
- DB name
- DB user

Esa tabla va en el `CLAUDE.md` de cada repo bajo la sección **"DB operations"**. No duplicar acá; solo el método.

---

## Procedimiento A — Query interactiva

```bash
# Constantes del repo (cambiar por repo, ver CLAUDE.md del repo)
VPS=65.108.148.79
PG_UUID=uxoszayiqygjp8rib3kdddvg
APP_UUID=t1ect6gnjp8068ccu7lah6n8
DB_NAME=shopear
DB_USER=postgres

# 1. Obtener IP actual del container PG (no es estable entre restarts)
CONTAINER_IP=$(ssh root@$VPS \
  "docker inspect $PG_UUID --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'")

# 2. Obtener password fresca del env del app container
APP_NAME=$(ssh root@$VPS "docker ps --format '{{.Names}}' | grep $APP_UUID | head -1")
DB_PASS=$(ssh root@$VPS "docker inspect $APP_NAME --format '{{range .Config.Env}}{{println .}}{{end}}' | grep ^DATABASE_URL=" | sed -E 's|.*://[^:]+:([^@]+)@.*|\1|')

# 3. Abrir tunnel en background
ssh -fNL 5433:$CONTAINER_IP:5432 root@$VPS

# 4. Esperar a que el puerto responda (max ~1.5s)
for i in 1 2 3 4 5; do nc -z localhost 5433 2>/dev/null && break; sleep 0.3; done

# 5. Conectar
PGPASSWORD="$DB_PASS" psql -h localhost -p 5433 -U $DB_USER -d $DB_NAME

# 6. Al salir de psql, cerrar el tunnel
pkill -f "ssh -fNL 5433:$CONTAINER_IP:5432"
```

Para query one-shot sin entrar al shell interactivo:

```bash
PGPASSWORD="$DB_PASS" psql -h localhost -p 5433 -U $DB_USER -d $DB_NAME \
  -c "SELECT COUNT(*) FROM \"users\";"
```

---

## Procedimiento B — Backup (pg_dump)

Pasos 1–4 idénticos al Procedimiento A. Después:

```bash
mkdir -p ~/dumps/$REPO_NAME

DUMP=~/dumps/$REPO_NAME/$REPO_NAME-prod-$(date +%Y%m%d-%H%M).dump

PGPASSWORD="$DB_PASS" pg_dump -Fc --no-owner --no-privileges \
  -h localhost -p 5433 -U $DB_USER -d $DB_NAME \
  -f $DUMP

# Verificar integridad sin restaurar
pg_restore --list $DUMP | head -20
ls -lh $DUMP

# Cerrar tunnel
pkill -f "ssh -fNL 5433:$CONTAINER_IP:5432"
```

Flags clave:

- `-Fc`: formato custom binario comprimido con gzip. Permite `pg_restore` selectivo (`-t table`, `-L list-file`).
- `--no-owner --no-privileges`: dump portable. El restore no fuerza ownership específico ni GRANTs, útil para restaurar a una DB local con otro user.
- `-j N` (parallel jobs): **requiere `-Fd` (directory format)**, no `-Fc`. Usar solo si la DB supera varios GB y el backup se siente lento.

Referencia de tiempos: shope-ar en prod (2026-04-21) dumpeaba ~351 KB en 38 s con 221 objetos. Escala lineal esperable.

---

## Procedimiento C — Restore a local

Asume que existe una DB local con el mismo schema (o la vas a recrear desde cero con este dump).

```bash
# 0. Backup del local antes de pisar (siempre, por si hay data útil)
LOCAL_DB=<tu_db_local>
LOCAL_USER=<tu_user_local>
mkdir -p ~/dumps/$REPO_NAME

pg_dump -Fc --no-owner -h localhost -p 5432 -U $LOCAL_USER -d $LOCAL_DB \
  -f ~/dumps/$REPO_NAME/$REPO_NAME-local-backup-$(date +%Y%m%d-%H%M).dump

# 1. Restore desde el dump de prod
PGPASSWORD=<local_pass> pg_restore --clean --if-exists --no-owner --no-privileges \
  -h localhost -p 5432 -U $LOCAL_USER -d $LOCAL_DB \
  ~/dumps/$REPO_NAME/$REPO_NAME-prod-<timestamp>.dump

# 2. Verificar contando algo conocido
psql -U $LOCAL_USER -d $LOCAL_DB -c 'SELECT COUNT(*) FROM "users";'
```

Flags clave:

- `--clean --if-exists`: genera `DROP IF EXISTS` antes de los `CREATE`. Sin esto, tablas con data preexistente dan conflicto.
- `--no-owner --no-privileges`: necesario si el user de prod difiere del local.

Si el schema difiere (ej: DB local desactualizada), primero sincronizar con `pnpm exec prisma db push` o recrear la DB limpia antes del restore.

---

## Troubleshooting

| Síntoma | Causa | Fix |
|---|---|---|
| `ssh: Could not resolve hostname` | VPS no responde | `ping`, ver si está en `itera-context/infra/vps-overview.md` |
| Container IP vacía | Container no corriendo, UUID mal escrito | `ssh root@$VPS "docker ps"` + verificar UUID |
| `connection refused on localhost:5433` | Tunnel no se estableció | Esperar 1–2s extra, verificar que el puerto 5433 esté libre localmente (`ss -tlnp \| grep 5433`) |
| `FATAL: password authentication failed` | Password mal obtenida del env | `ssh root@$VPS "docker inspect $APP_NAME --format '{{range .Config.Env}}{{println .}}{{end}}' \| grep DATABASE_URL"` manual y parsear a ojo |
| `pg_dump: server version mismatch` | Cliente local < server | Actualizar `pg_dump` local a versión ≥ server |
| `pg_restore: could not execute query` | Schema local ≠ dump | `prisma db push` antes del restore, o recrear DB limpia |
| Tunnel zombi (no se cerró) | Olvidaste el `pkill` | `pgrep -fa "ssh -fNL"` y mato manualmente |
| La IP del container cambió entre operaciones | Restart del container (deploy, reboot del VPS) | Re-obtener IP antes de cada tunnel. La IP NO es estable. |

---

## Comparativa con el método legacy (`docker exec`)

| Aspecto | Legacy (`ssh + docker exec`) | Tunnel |
|---|---|---|
| Cliente que corre | `psql`/`pg_dump` del container (versión fija) | Tus binarios locales (autocompletado, `.psqlrc`, `pgcli`, `pg_dump` con flags custom) |
| GUI (DBeaver, Prisma Studio) | ❌ imposible | ✅ apuntan a `localhost:5433` |
| `pg_dump -Fc` binario | Frágil por STDOUT de SSH | Directo |
| Password en transit | `docker exec -e PGPASSWORD=...` → visible en `ps aux` del VPS durante ejecución | Nunca viaja al VPS como comando |
| Escape hell | Triple comillas entre bash + ssh + docker | Cero |
| Multi-cliente paralelo al mismo tunnel | No | Sí |
| Scripts locales que hablan Postgres | Wrap en SSH con escape | Directo |

El patrón legacy queda bien para:

- Debugging dentro del container (inspect volumes, postgres config)
- Query one-shot cuando el tunnel es overkill (ej: `SELECT NOW()`)

---

## Por qué este método reemplaza al legacy

1. **Herramientas locales**: psql con tu `.psqlrc`, `\timing`, `\x`, autocompletado, pgcli si lo usás. Imposible con `docker exec`.
2. **GUI tools funcionan**: DBeaver / Prisma Studio apuntan a `localhost:5433` y andan. Con `docker exec`, GUI es imposible.
3. **Password hygiene**: el password de prod nunca llega al VPS como argumento de proceso. Con `docker exec -e PGPASSWORD=`, queda en `ps aux` del host durante la ejecución.
4. **Separation of concerns**: SSH hace una cosa (transporte), psql hace otra (cliente DB). El legacy mezcla SSH + docker + psql en un comando.
5. **Reusable**: el tunnel abierto sirve para psql + pg_dump + GUI + scripts Node simultáneamente. El legacy requiere una invocación SSH por cada uso.
6. **Sin quirks de TTY**: `docker exec -it` arrastra problemas de TTY cuando se ejecuta desde SSH no interactivo; el tunnel es pura red.

---

## Repos que implementan este método

| Repo | Ver datos específicos en |
|---|---|
| `shope-ar` | `shope-ar/CLAUDE.md` § "DB operations" |
| `itera-lex` | `itera-lex/CLAUDE.md` § "DB operations" |

Al agregar un repo nuevo: sumar fila acá + crear sección "DB operations" en el `CLAUDE.md` del repo con VPS, PG UUID, App UUID, DB name, user, comando de obtención de password. **No duplicar el método** en cada repo.
