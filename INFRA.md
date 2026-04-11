# Infraestructura ITERA — Indice de Deploy

> Referencia centralizada de URLs, Coolify UUIDs, puertos, DBs y env vars por proyecto.
> Datos obtenidos via Coolify CLI (`coolify app list` + `coolify app env list`).
> Ultima actualizacion: 2026-03-25

---

## Servidores

### itera-modern (proyectos ITERA)
| Campo | Valor |
|-------|-------|
| **IP** | 65.108.148.79 |
| **Plan** | Hetzner CX32 (8 GB RAM, 76 GB disco) |
| **OS** | Ubuntu 24.04 LTS |
| **Panel** | Coolify — https://coolify-modern.itera.world |
| **SSL** | Let's Encrypt via Traefik |

### itera-alquimica (proyectos Alquimica/Bambu)
| Campo | Valor |
|-------|-------|
| **IP** | 89.167.29.201 |
| **Panel** | Coolify — https://coolify-alquimica.itera.world |

---

## Proyectos Deployados — Contexto Modern

### itera-lex
| Campo | Valor |
|-------|-------|
| **URL app** | https://app.iteralex.com |
| **URL marketing** | https://iteralex.com |
| **Puerto dev** | 3000 |
| **Coolify UUID app** | `r40kockgo40wowg4w84soc4s` |
| **Coolify UUID PG** | `jcsokwcw0ks08k8wwwk4wwc0` |
| **Notas** | Multi-dominio via `src/proxy.ts`. También: www.iteralex.com |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| DATABASE_URL | Conexion PostgreSQL |
| BETTER_AUTH_URL | URL base para auth (app.iteralex.com) |
| BETTER_AUTH_SECRET | Firma de sesiones |
| BETTER_AUTH_TRUSTED_ORIGINS | Origenes permitidos (marketing + app) |
| NEXT_PUBLIC_APP_URL | URL de la app (client-side) |
| NEXT_PUBLIC_MARKETING_URL | URL del sitio marketing |
| NEXT_PUBLIC_GA_MEASUREMENT_ID | Google Analytics |
| SUPERADMIN_EMAIL | Email del superadmin para seed |
| SUPERADMIN_PASSWORD | Password del superadmin para seed |
| SUPERADMIN_NAME | Nombre del superadmin |
| ADMIN_SEED_SECRET | Secret para ejecutar seed via API |
| GOOGLE_CLIENT_ID | OAuth Google (Calendar sync) |
| GOOGLE_CLIENT_SECRET | OAuth Google (Calendar sync) |
| GOOGLE_GENERATIVE_AI_API_KEY | Gemini API para Copilot |
| ELEVENLABS_API_KEY | TTS/STT para transcripciones |
| R2_ACCOUNT_ID | Cloudflare R2 storage |
| R2_ACCESS_KEY_ID | R2 auth |
| R2_SECRET_ACCESS_KEY | R2 auth |
| R2_BUCKET_NAME | R2 bucket |
| AUDIO_STORAGE_PATH | Path local para audio temporal |
| CRON_SECRET | Auth para cron jobs |
| DEMO_USER_EMAIL | Credenciales demo para testing |
| DEMO_USER_PASSWORD | Credenciales demo para testing |
| ADMIN_RECLASSIFY_SECRET | Secret para reclasificacion admin |
| NODE_ENV | production |

---

### itera-lex-docs
| Campo | Valor |
|-------|-------|
| **URL** | https://docs.iteralex.com |
| **Puerto dev** | 3011 |
| **DB** | Sin DB (Nextra estatico) |
| **Coolify UUID app** | `c4gg5eujjvpbgelqlgurdnoe` |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| NODE_ENV | production |

---

### itera-estudio
| Campo | Valor |
|-------|-------|
| **URL** | https://app.iteraestudio.com |
| **Puerto dev** | 3002 |
| **Coolify UUID app** | `z80g004g4o40cw4wog0kcccg` |
| **Coolify UUID PG** | `m84wg4kggsgksssg8k0wc000` |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| DATABASE_URL | Conexion PostgreSQL |
| BETTER_AUTH_SECRET | Firma de sesiones |
| BETTER_AUTH_URL | URL base para auth |
| R2_ACCOUNT_ID | Cloudflare R2 storage |
| R2_ACCESS_KEY_ID | R2 auth |
| R2_SECRET_ACCESS_KEY | R2 auth |
| R2_BUCKET_NAME | R2 bucket |
| R2_PUBLIC_URL | URL publica de assets |
| GOOGLE_CLIENT_ID | OAuth Google |
| GOOGLE_CLIENT_SECRET | OAuth Google |
| GEMINI_API_KEY | Gemini API para generacion de imagenes |
| ADMIN_EMAIL | Email admin seed |
| ADMIN_PASSWORD | Password admin seed |
| ITERA_API_KEY | API key interna ITERA |
| NODE_ENV | production |

---

### itera-lat
| Campo | Valor |
|-------|-------|
| **URL** | https://itera.lat (+ www.itera.lat) |
| **Puerto dev** | 3005 |
| **DB** | Sin DB |
| **Coolify UUID app** | `rtwcc35tbzzgfx3dp2hduod2` |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| NEXT_PUBLIC_SITE_URL | URL del sitio |
| NEXT_PUBLIC_GA_ID | Google Analytics |

---

### abundancia-hogar
| Campo | Valor |
|-------|-------|
| **URL** | https://abundanciahogar.com.ar |
| **Puerto dev** | 3000 |
| **Coolify UUID app** | `bx5hhe24qkxm8a5bklltok5b` |
| **Coolify UUID PG** | `qvyp1mdigluu25eu1aekpsho` |
| **Notas** | Cloudflare proxy naranja en dominio |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| DATABASE_URL | Conexion PostgreSQL |
| BETTER_AUTH_SECRET | Firma de sesiones |
| BETTER_AUTH_URL | URL base para auth |
| CF_R2_ACCOUNT_ID | Cloudflare R2 storage |
| CF_R2_ACCESS_KEY_ID | R2 auth |
| CF_R2_SECRET_ACCESS_KEY | R2 auth |
| CF_R2_BUCKET_NAME | R2 bucket |
| CF_R2_PUBLIC_URL | URL publica de assets |
| ADMIN_EMAIL | Email admin seed |
| ADMIN_PASSWORD | Password admin seed |
| NODE_ENV | production |

---

### valores-juridicos-api
| Campo | Valor |
|-------|-------|
| **URL** | https://api.iteralex.com |
| **Coolify UUID app** | `d0osocwkwc8gkcw88gww4ck4` |
| **Status** | running:healthy |
| **Notas** | API Python/FastAPI para valores juridicos |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| ADMIN_TOKEN | Auth para admin endpoints |
| CORS_ORIGINS | Origenes permitidos |
| REFRESH_INTERVAL_HOURS | Intervalo de refresh de datos |
| STALE_AFTER_HOURS | Tiempo hasta considerar datos stale |

---

### pachu.dev
| Campo | Valor |
|-------|-------|
| **URL** | https://pachu.dev |
| **Coolify UUID app** | `agwnkzpg1rnh6z38su743nzw` |
| **Notas** | Landing page personal, HTML estatico |

---

### shope-ar (Shopear)
| Campo | Valor |
|-------|-------|
| **URLs** | https://admin.shope.ar, https://apple.shope.ar, https://ropaurbana.shope.ar |
| **Puerto dev** | 3016 |
| **Coolify UUID project** | `zlj25fl55tuj1wcxtj8v39hm` |
| **Coolify UUID app** | `t1ect6gnjp8068ccu7lah6n8` |
| **Coolify UUID PG** | `uxoszayiqygjp8rib3kdddvg` (postgres:17-alpine, db=`shopear`) |
| **Repo** | `iteralat/shope-ar` branch `main` |
| **GitHub App** | `a4skko8o44osocskcossgogs` (coolify-itera-lat) |
| **Notas** | SaaS multi-tenant. Tiendas por subdominio (apple, ropaurbana). Cookie compartida `.shope.ar`. Extiende seed route con `target:"provision"` para provisionar tenants nuevos via API. `start.sh` corre `prisma db push` en boot |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| DATABASE_URL | Conexion PostgreSQL interna |
| BETTER_AUTH_SECRET | Firma de sesiones |
| BETTER_AUTH_URL | `https://admin.shope.ar` (platform host — determina cookie domain `.shope.ar` y trusted origins `https://*.shope.ar`) |
| NEXT_PUBLIC_SITE_URL | `https://admin.shope.ar` |
| ADMIN_EMAIL | Email del admin global (OWNER de todas las tiendas provisionadas) |
| ADMIN_PASSWORD | Password admin (usar `--is-literal`) |
| ADMIN_SEED_SECRET | Bearer token para `/api/admin/seed` |
| NODE_ENV | production |

**Provisionar tienda nueva:**
```bash
curl -k --resolve "admin.shope.ar:443:65.108.148.79" \
  -X POST https://admin.shope.ar/api/admin/seed \
  -H "Authorization: Bearer $ADMIN_SEED_SECRET" \
  -H "Content-Type: application/json" \
  -d '{"target":"provision","templateKey":"apple","storeId":"store_tienda","slug":"tienda","subdomain":"tienda","isDefault":false}'
```

---

## Proyectos Deployados — Contexto Alquimica

### bambu-web-corporativa-catalogo
| Campo | Valor |
|-------|-------|
| **URL** | https://bambuoficial.com.ar |
| **Puerto dev** | 3009 |
| **Coolify UUID app** | `kwokswcoc0848oo4k0408gk0` |
| **Coolify UUID PG** | `sssoc4oksk0048gwc8wgs808` |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| DATABASE_URL | Conexion PostgreSQL |
| BETTER_AUTH_SECRET | Firma de sesiones |
| BETTER_AUTH_URL | URL base para auth |
| SEED_ADMIN_EMAIL | Email admin seed |
| SEED_ADMIN_PASSWORD | Password admin seed |
| SITE_URL | URL del sitio |
| NEXT_PUBLIC_GA_ID | Google Analytics |
| R2_ACCOUNT_ID | Cloudflare R2 storage |
| R2_ACCESS_KEY_ID | R2 auth |
| R2_SECRET_ACCESS_KEY | R2 auth |
| R2_BUCKET_NAME | R2 bucket |
| R2_PREFIX | Prefijo de archivos en R2 |
| R2_PUBLIC_URL | URL publica de assets |
| R2_PUBLIC_HOSTNAME | Hostname publico R2 |
| STORAGE_PROVIDER | Proveedor de storage (r2) |
| NODE_ENV | production |

---

### alquimica-hub
| Campo | Valor |
|-------|-------|
| **URL** | https://canal.alquimicaoficial.com.ar |
| **Puerto dev** | 3003 |
| **Coolify UUID app** | `nk8044wkokgs84o040sk4wg4` |
| **Coolify UUID PG** | `boccgcockk48k4sgg00soc44` |

**Env vars:**
| Variable | Proposito |
|----------|-----------|
| DATABASE_URL | Conexion PostgreSQL |
| AUTH_SECRET | NextAuth secret |
| AUTH_URL | NextAuth URL |
| ADMIN_EMAIL | Email admin seed |
| ADMIN_PASSWORD | Password admin seed |
| R2_ACCOUNT_ID | Cloudflare R2 storage |
| R2_ACCESS_KEY_ID | R2 auth |
| R2_SECRET_ACCESS_KEY | R2 auth |
| R2_BUCKET_NAME | R2 bucket |
| R2_PUBLIC_URL | URL publica de assets |
| NEXT_PUBLIC_BASE_URL | URL base client-side |
| NEXT_PUBLIC_GA_ID | Google Analytics |
| NIXPACKS_NODE_VERSION | Version de Node para build |
| NODE_ENV | production |

---

## Proyectos No Deployados

| Proyecto | Puerto dev | DB | Estado |
|----------|-----------|-----|--------|
| alquimica-web-corporativa | 3010 | `alquimica` | Sin deploy configurado |
| itera-chatbots-platform | 3006 | `chatbot` | Deploy planeado Fase 7 |
| itera-pages | — | Sin DB | En desarrollo |
| itera-tube | 3004 | `iteratube` | Sin deploy (local only) |
| itera-yt-downloader | 3000 | — | Sin planning de deploy |
| presskit-ar | 3000 | `presskit` | Estuvo deployado, se perdio en migracion de VPS (remocion cPanel). Re-deploy pendiente, proyecto en alfa. |
| wsp-facil | 3007 | — | Deploy planeado Sprint 3 |

---

## Hallazgos: Env Vars por Grupo de Afinidad

### Grupo 1 — SaaS con IA (itera-lex vs itera-estudio)

| Variable | itera-lex | itera-estudio | Nota |
|----------|-----------|---------------|------|
| BETTER_AUTH_* | 3 vars | 2 vars | lex tiene TRUSTED_ORIGINS (multi-dominio) |
| R2_* | 4 vars (sin prefix) | 5 vars (con PUBLIC_URL) | lex no tiene R2_PUBLIC_URL |
| GOOGLE_* | CLIENT_ID + SECRET | CLIENT_ID + SECRET | Iguales |
| AI | GOOGLE_GENERATIVE_AI_API_KEY + ELEVENLABS | GEMINI_API_KEY | Naming distinto para la misma API de Gemini |
| Admin seed | SUPERADMIN_* (3) | ADMIN_* (2) | Naming inconsistente |

### Grupo 2 — Web + Catalogo (abundancia-hogar vs bambu)

| Variable | abundancia-hogar | bambu | Nota |
|----------|-----------------|-------|------|
| R2_* | CF_R2_* (5 vars) | R2_* (7 vars) | **Prefijo inconsistente**: CF_R2 vs R2 |
| Admin seed | ADMIN_* | SEED_ADMIN_* | Naming inconsistente |
| SITE_URL | no tiene | SITE_URL | abundancia-hogar no tiene URL del sitio en env |
| GA | no tiene | NEXT_PUBLIC_GA_ID | abundancia-hogar sin analytics |

---

## Coolify CLI

Instalado en `C:\Program Files\Coolify\coolify`. Usar `coolify context use <nombre>` antes de operar.

| Contexto | FQDN | VPS |
|----------|------|-----|
| modern | https://coolify-modern.itera.world | 65.108.148.79 |
| alquimica | https://coolify-alquimica.itera.world | 89.167.29.201 |
| static | https://coolify-static.itera.world | 37.27.248.173 |

**Comandos frecuentes:**
```bash
coolify app list                          # listar apps
coolify app env list <uuid>               # ver env vars (keys only)
coolify app env list <uuid> -s            # ver env vars con valores
coolify app env create <uuid> --key X --value Y
coolify app logs <uuid>                   # logs de la app
coolify database list                     # listar DBs
```

**Notas:**
- Todos los deploys usan auto-deploy via GitHub App (`coolify-itera-modern`).
- Post-deployment command estandar para proyectos con Prisma: `pnpm exec prisma db push`.
- presskit-ar no aparece en ningún contexto Coolify — posiblemente fue eliminado del panel. Verificar.
- itera-tube no aparece en ningún contexto Coolify — nunca fue deployado.
