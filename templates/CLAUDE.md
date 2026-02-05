# [Nombre del Proyecto]

[Una línea describiendo qué es]

## Stack

- Next.js 16 (App Router)
- React 19 + Tailwind v4 + shadcn/ui
- Prisma + PostgreSQL
- Auth.js v5
- Zod

## Estado

En planificación. Ver `.planning/` para avance.

## Decisiones Pendientes

- [ ] Multi-tenant o single-tenant?
- [ ] Deploy: Vercel o Coolify?
- [ ] ...

## Referencias

- `.planning/PROJECT.md` - Definición del proyecto
- `.planning/STATE.md` - Estado actual

---

# Guía de Crecimiento

Este archivo debe crecer SOLO con información específica del proyecto.
Las reglas globales están en `~/.claude/CLAUDE.md`.

## Fase 1: Planificación (~20 líneas)

Lo de arriba. Stack, estado, decisiones pendientes.

## Fase 2: Estructura definida (+20 líneas)

Agregar cuando tengas rutas claras:

```markdown
## URLs

| Ruta | Descripción |
|------|-------------|
| `/` | Landing |
| `/ingresar` | Login |
| `/panel` | Dashboard |
```

## Fase 3: Desarrollo activo (+30 líneas)

Agregar cuando empieces a codear:

```markdown
## Scopes de Commits

- `auth` - Autenticación
- `dashboard` - Panel usuario
- `api` - Endpoints
- `db` - Schema Prisma
- `ui` - Componentes

## Comandos

npm run dev       # Desarrollo
npm run build     # Build
npm run db:push   # Sincronizar schema
npm run db:studio # Prisma Studio
```

## Fase 4: Reglas específicas (+20 líneas)

Agregar cuando descubras patrones/errores específicos:

```markdown
## Reglas del Proyecto

- **Single-tenant**: Solo un admin
- **NO fetch a URLs propias** en Server Components
- [Otras reglas específicas que surjan]
```

## Fase 5: Producción (+20 líneas)

Agregar cuando tengas deploy:

```markdown
## Ambientes

| Ambiente | URL |
|----------|-----|
| Local | http://localhost:3000 |
| Staging | http://... |
| Producción | https://... |

## Credenciales Dev

- Ver `.env.example`
```

---

## Qué NO incluir (ya está en global)

- Idioma (español/inglés)
- Output conciso
- Bash vs PowerShell
- Formato de commits
- Workflow de sesiones (/load, /save)
- Seguridad genérica
- Validación con Zod (patrón general)

## Tamaño ideal por fase

| Fase | Líneas | Total acumulado |
|------|--------|-----------------|
| Planificación | ~20 | 20 |
| Estructura | +20 | 40 |
| Desarrollo | +30 | 70 |
| Reglas específicas | +20 | 90 |
| Producción | +20 | 110 |

**Máximo recomendado: ~120 líneas**

---

_Eliminar esta guía de crecimiento cuando el proyecto esté maduro._
