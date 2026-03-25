# Changelog de Mejoras al Kickstart

Registro de mejoras al sistema de kickstart ITERA, motivadas por errores encontrados en proyectos reales.

---

## [13 Mar 2026] - Scaffold desde día 1 + enforcement automático

### Origen
Auditoría de calidad (QG + Codex) del proyecto `bambu-web-corporativa-catalogo` encontró 26 issues en un proyecto chico (landing + catálogo + admin). Los issues se agrupan en:

1. **Archivos scaffold faltantes** (deberían existir desde el kickstart): .nvmrc, Dockerfile, .dockerignore, error.tsx, loading.tsx, env.ts, EmptyState, ActionResult, slugify, auth-action
2. **Reglas mecánicas sin enforcement** (findMany sin take, uploads sin validar, CSV sin sanitizar): están en CLAUDE.md como prosa pero nada las hace cumplir automáticamente
3. **Deuda DRY natural** (interfaces duplicadas, helpers copiados): se detecta al auditar el conjunto, no al escribir cada archivo

### Qué se cambió

#### En el kickstart-nextjs.md (Paso 6):
- Agregar creación automática de archivos scaffold:
  - `.nvmrc` (22)
  - `src/lib/types/actions.ts` (ActionResult compartido)
  - `src/lib/utils/slugify.ts` (slugify compartido)
  - `src/lib/env.ts` (validación Zod de env vars)
  - `src/lib/auth-action.ts` (requireAuthAction — si módulo auth)
  - `src/app/(public)/error.tsx` y `loading.tsx`
  - `src/app/admin/(protected)/error.tsx` y `loading.tsx` (si módulo auth)
  - `src/components/shared/EmptyState.tsx`
  - `Dockerfile` multi-stage con TZ
  - `.dockerignore`
  - `next.config.ts` con `output: 'standalone'`
  - `eslint.config.mjs` con `src/generated/**` en ignores

#### En check.md:
- Agregar Check J: Scaffold files (verifica que existan los archivos base)
- Agregar verificación de upload routes (MIME + size validation)
- Agregar verificación de CSV exports (sanitización de fórmulas)

#### Nuevo: scripts/check-scaffold.sh
- Script que verifica la existencia de los archivos scaffold requeridos
- Ejecutable como pre-commit hook o manualmente

#### Nuevo: scripts/check-findmany-take.sh
- Script que busca findMany sin take en el código
- Enforcement automático de la regla más olvidada

#### En CLAUDE.md y CLAUDE-simple.md:
- Agregar regla de "auditoría por archivo" al cerrar
- Agregar regla de "tipos compartidos desde el primer uso"

---

## [13 Mar 2026] - Fix falsos positivos en check-findmany-take.sh

### Origen
Al adoptar los scripts de enforcement en `itera-lex`, el script `check-findmany-take.sh` reportó 24 violaciones. Investigación reveló que solo 7 eran reales — el resto eran falsos positivos porque las queries con `include`/`select` largos (típico en Prisma) empujan el `take` más allá de la ventana de 10 líneas del script.

### Qué se cambió

#### En scripts/check-findmany-take.sh:
- Ampliar ventana de búsqueda de 10 a 20 líneas después del `findMany(`
- Queries con includes/selects de 12-18 líneas ahora se detectan correctamente
- Reducción de falsos positivos: de ~17 a 0 en itera-lex (proyecto con queries complejas)

---

_Este archivo crece con cada mejora al kickstart._
