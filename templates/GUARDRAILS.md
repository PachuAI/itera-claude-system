# Guardrails - Índice

> Checks preventivos para evitar errores conocidos.
> Se lee con cada `/load`. Debe ser CONCISO y ACCIONABLE.
> Para contexto completo y ejemplos de código: ver GUARDRAILS-DETAIL.md

---

## Stack del Proyecto

<!--
INSTRUCCIÓN PARA CLAUDE: Al crear este archivo, analizar package.json,
composer.json, requirements.txt o equivalente y completar esta tabla.
-->

| Tecnología | Versión |
|------------|---------|
| [Framework] | [versión] |
| [Runtime] | [versión] |
| [ORM/DB] | [versión] |
| [UI Library] | [versión] |

---

## Parte 1: Guardrails Específicos del Stack

> Errores específicos de las tecnologías usadas en este proyecto.
> Aplican solo a proyectos con el mismo stack.

### Formato de cada entrada

```markdown
### [Tecnología] Título descriptivo

**Problema**: Descripción breve (1 línea)
**Check preventivo**: [CUÁNDO] → [ACCIÓN] → [SI FALLA]

**Agregado**: [fecha] | **Reforzado**: [fecha] (N veces)
**Detalle**: GUARDRAILS-DETAIL.md#anchor
```

### Categorías sugeridas

- `[Framework]` - Errores del framework principal
- `[ORM]` - Queries, migraciones, schemas
- `[Auth]` - Autenticación, sesiones, tokens
- `[UI]` - Componentes, estilos, responsive
- `[API]` - Endpoints, validaciones, respuestas
- `[Build]` - Compilación, bundling
- `[Testing]` - Tests específicos del framework

### Entradas

<!-- Agregar entradas específicas del stack aquí -->

*Sin entradas todavía. Se agregan con `/save` cuando se detectan errores.*

---

## Parte 2: Guardrails Generales

> Errores que NO son específicos del stack.
> Aplican a cualquier proyecto: DevOps, Git, CI/CD, etc.
> Se pueden reciclar entre proyectos de cualquier tecnología.

### Categorías sugeridas

- `[DevOps]` - Deploy, containers, servidores
- `[Coolify]` - Específicos de Coolify
- `[Docker]` - Containers, images, compose
- `[Git]` - Branches, merges, hooks
- `[CI/CD]` - Pipelines, builds automáticos
- `[DNS/SSL]` - Dominios, certificados
- `[Infra]` - VPS, redes, storage
- `[Proceso]` - Workflow, documentación

### Entradas

<!-- Agregar entradas generales aquí -->

*Sin entradas todavía. Se agregan con `/save` cuando se detectan errores.*

---

## Cómo usar este archivo

1. **Con /load**: Claude lee este índice y menciona 2-3 checks relevantes
2. **Mientras codea**: Claude aplica los checks preventivos mecánicamente
3. **Si comete error**: Claude lee GUARDRAILS-DETAIL.md para entender por qué
4. **Con /save**: Si hubo errores, se actualiza el índice (y el detail)

## Reglas del Check Preventivo

El check debe ser **ACCIONABLE**, no descriptivo:

```markdown
# MAL - Vago
**Check preventivo**: Revisar imports

# BIEN - Específico y mecánico
**Check preventivo**: Después de CADA archivo → `npm run lint` → Si falla, arreglar ANTES de continuar
```

Formato: `[CUÁNDO] → [ACCIÓN ESPECÍFICA] → [QUÉ HACER SI FALLA]`
