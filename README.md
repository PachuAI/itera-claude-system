# Claude Memory System

Sistema universal de gestión de sesiones con memoria a largo plazo para proyectos con Claude Code.

**Stack-agnostic**: Funciona con cualquier lenguaje o framework (Next.js, Laravel, Python, Go, etc.)

---

## Filosofía

Cinco archivos para mantener contexto entre sesiones:

| Archivo | Pregunta que responde | Actualización |
|---------|----------------------|---------------|
| `PROJECT.md` | ¿Qué es este proyecto? | Raramente (visión, MVP, stack) |
| `STATE.md` | ¿Dónde estamos HOY? | Cada `/save` (sobrescribe) |
| `CHANGELOG.md` | ¿Cómo llegamos hasta acá? | Cada `/save` (acumula) |
| `GUARDRAILS.md` | ¿Qué errores NO repetir? | Cada `/save` (índice conciso) |
| `GUARDRAILS-DETAIL.md` | ¿Por qué ocurren esos errores? | Cada `/save` (enciclopedia) |

**Principios clave**:
- `STATE.md` es conciso para cargar rápido (max 100-150 líneas)
- `CHANGELOG.md` es completo para no perder nada
- `GUARDRAILS.md` es un índice escaneable con checks preventivos
- `GUARDRAILS-DETAIL.md` tiene ejemplos de código y contexto completo
- `PROJECT.md` es inmutable (contexto base del proyecto)

---

## Estructura

```
.planning/                    # Memoria del proyecto
├── PROJECT.md               # Qué es (visión, stack, MVP)
├── STATE.md                 # Dónde estamos hoy
├── CHANGELOG.md             # Cómo llegamos
├── GUARDRAILS.md            # Índice de errores (conciso, ~200 líneas)
└── GUARDRAILS-DETAIL.md     # Enciclopedia de errores (detallado)

.claude/
├── commands/
│   ├── load.md              # /load - inicio de sesión
│   ├── save.md              # /save - fin de sesión
│   └── commit.md            # /commit - solo commit
└── agents/
    └── doc-changelog.md     # Agente Haiku para changelog
```

---

## Flujo de trabajo

### Inicio de sesión
```
/load
→ Lee STATE.md + GUARDRAILS.md (índice)
→ Resume estado actual
→ Internaliza checks preventivos
→ Pregunta qué hacer
```

### Durante la sesión
```
→ Aplica checks preventivos mientras codea
→ Commits por tarea significativa (manual o con /commit)
```

### Fin de sesión
```
/save
→ Revisa errores de la sesión (fase GUARDRAILS)
→ Si hay errores: analiza POR QUÉ, actualiza índice + detail
→ Actualiza STATE.md (sobrescribe última sesión)
→ Llama agente doc-changelog → agrega entrada a CHANGELOG.md
→ Ejecuta commit automático
→ Confirma al usuario
```

---

## Instalación

### Paso 0: Configurar CLAUDE.md global (una sola vez)

```bash
# Copiar template global a ~/.claude/
cp claude-memory-system/global/CLAUDE.md ~/.claude/CLAUDE.md

# Editar con tu contexto (fecha, stack principal, etc.)
```

### Opción A: Proyecto nuevo desde cero

```bash
# 1. Copiar estructura
mkdir -p .claude/commands .claude/agents .planning

# 2. Copiar comandos y agentes
cp claude-memory-system/commands/* .claude/commands/
cp claude-memory-system/agents/* .claude/agents/

# 3. Copiar templates de .planning/
cp claude-memory-system/templates/STATE.md .planning/
cp claude-memory-system/templates/CHANGELOG.md .planning/
cp claude-memory-system/templates/PROJECT.md .planning/

# 4. Copiar template CLAUDE.md a raíz del proyecto
cp claude-memory-system/templates/CLAUDE.md ./CLAUDE.md

# 5. Editar .planning/PROJECT.md y CLAUDE.md con info del proyecto
# 6. Listo, ya podes usar /load y /save
```

### Opción B: Proyecto existente con historial

Ver archivo `BOOTSTRAP.md` para guía detallada de migración.

---

## Comandos disponibles

| Comando | Descripción | Cuándo usarlo |
|---------|-------------|---------------|
| `/load` | Carga contexto al iniciar sesión | Después de `/clear` o al empezar a trabajar |
| `/save` | Guarda progreso y actualiza docs | Al terminar sesión o antes de `/clear` |
| `/commit` | Crea commit con Conventional Commits | Para commits intermedios durante la sesión |

---

## Sistema GUARDRAILS (Progressive Disclosure)

El sistema de guardrails usa **progressive disclosure**: información concisa por defecto, detalle disponible cuando se necesita.

### ¿Por qué dos archivos?

| Archivo | Propósito | Tamaño | Cuándo se lee |
|---------|-----------|--------|---------------|
| `GUARDRAILS.md` | Índice con checks preventivos | ~100-200 líneas | Siempre (con `/load`) |
| `GUARDRAILS-DETAIL.md` | Enciclopedia con código y contexto | Sin límite | Solo cuando se necesita |

**Beneficios**:
- `/load` es rápido (no carga 2000+ líneas)
- El índice es escaneable antes de codear
- El detalle está disponible cuando se comete un error
- Fácil de reciclar entre proyectos (el índice es portable)

### Estructura de GUARDRAILS.md (Índice)

```markdown
# Guardrails - Índice

## Stack del Proyecto
| Tecnología | Versión |
|------------|---------|
| Next.js    | 16      |

---

## Parte 1: Guardrails Específicos del Stack

### [TypeScript] Unused imports/variables

**Problema**: `no-unused-vars` falla en commit
**Check preventivo**: Después de CADA archivo → `npx tsc --noEmit && npm run lint` → Si falla, arreglar ANTES de continuar

**Agregado**: 2026-01-28 | **Reforzado**: 2026-01-30 (2 veces)
**Detalle**: GUARDRAILS-DETAIL.md#typescript-unused

---

## Parte 2: Guardrails Generales

[Errores de DevOps, Git, Infra - aplican a cualquier proyecto]
```

### El Check Preventivo es CLAVE

El check preventivo debe ser **ACCIONABLE**, no descriptivo:

```markdown
# MAL - Vago, no previene nada
**Check preventivo**: Revisar imports antes de commitear

# BIEN - Específico, accionable, mecánico
**Check preventivo**: Después de CADA archivo → `npx tsc --noEmit && npm run lint` → Si falla, arreglar ANTES de continuar
```

Formato del check: `[CUÁNDO] → [ACCIÓN ESPECÍFICA] → [QUÉ HACER SI FALLA]`

### Estructura de GUARDRAILS-DETAIL.md (Enciclopedia)

```markdown
# Guardrails - Detalle

## typescript-unused

### [TypeScript] Unused imports/variables (error MÁS COMÚN)

**Error**:
\`\`\`
error  'X' is defined but never used  @typescript-eslint/no-unused-vars
\`\`\`

**Por qué ocurre**:
1. Escribís código pensando en usar algo
2. Cambiás de enfoque durante la implementación
3. No limpiás el código que dejó de usarse
4. ESLint lo detecta al commitear (muy tarde)

**Por qué `tsc --noEmit` NO lo detecta**:
TypeScript verifica TIPOS, no linting. Unused imports son válidos para TS.

**Solución**:
\`\`\`bash
# Después de CADA archivo:
npx tsc --noEmit && npm run lint
\`\`\`

**Patrón típico del error**:
\`\`\`typescript
// Escribí esto pensando usar db:
import { db } from '@/lib/db'

// Después cambié la implementación
// Pero dejé el import → ESLint falla
\`\`\`

**Historia**:
- 2026-01-28: Agregado después de acumular 20+ errores en una sesión
- 2026-01-30: Reforzado - se volvió a cometer por no correr lint después de cada archivo
```

### Flujo cuando se comete un error

```
┌─────────────────────────────────────────────────────────────────┐
│  /save detecta que se cometió un error durante la sesión        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  1. ¿El error ya estaba en GUARDRAILS.md?                       │
│     → SÍ: Analizar POR QUÉ se cometió igual                     │
│           - ¿El check no era claro?                             │
│           - ¿El check no era visible/específico?                │
│           - ¿Faltaba el "cuándo" o "qué hacer si falla"?        │
│           → MEJORAR el check en el índice                       │
│           → Agregar "Reforzado: [fecha]"                        │
│                                                                 │
│     → NO: Agregar nueva entrada                                 │
│           → Entrada CONCISA en GUARDRAILS.md (índice)           │
│           → Entrada DETALLADA en GUARDRAILS-DETAIL.md           │
└─────────────────────────────────────────────────────────────────┘
```

### Formato de entrada - Índice (GUARDRAILS.md)

```markdown
### [Tecnología] Título descriptivo del problema

**Problema**: Descripción breve (1 línea)
**Check preventivo**: [CUÁNDO] → [ACCIÓN] → [SI FALLA]

**Agregado**: [fecha] | **Reforzado**: [fecha] (N veces)
**Detalle**: GUARDRAILS-DETAIL.md#anchor
```

### Formato de entrada - Detalle (GUARDRAILS-DETAIL.md)

```markdown
## anchor-del-error

### [Tecnología] Título descriptivo del problema

**Error**: [mensaje de error textual]

**Por qué ocurre**:
[Explicación completa del contexto]

**Solución**:
[Código de ejemplo, comandos, etc.]

**Patrón típico**:
[Ejemplo de código que causa el error]

**Historia**:
- [fecha]: Agregado - [contexto de cómo se descubrió]
- [fecha]: Reforzado - [por qué se volvió a cometer]
```

### Categorías sugeridas

**Stack-específicos (Parte 1)**:
- `[Framework]`, `[ORM]`, `[Auth]`, `[UI]`, `[API]`, `[Build]`, `[Testing]`

**Generales (Parte 2)**:
- `[DevOps]`, `[Coolify]`, `[Docker]`, `[Git]`, `[CI/CD]`, `[DNS/SSL]`, `[Infra]`

### Beneficio del reciclaje

Al finalizar varios proyectos, podés:
1. **Recopilar índices** de proyectos con mismo stack → GUARDRAILS-NEXTJS16.md
2. **Recopilar generales** de todos los proyectos → GUARDRAILS-GENERAL.md
3. **Importar al iniciar** proyecto nuevo según stack + generales

---

## Beneficios

- **Memoria persistente**: Claude recuerda entre sesiones sin leer todo el código
- **Onboarding rápido**: Nuevos devs leen STATE.md y saben dónde está el proyecto
- **Historial completo**: CHANGELOG captura TODO lo que se hizo (no se pierde nada)
- **Prevención activa**: GUARDRAILS con checks accionables evitan errores
- **Progressive disclosure**: Índice rápido, detalle cuando se necesita
- **Stack-agnostic**: Funciona con cualquier lenguaje/framework
- **Zero config**: Solo copiar archivos y empezar

---

## Customización

### Adaptar formato de STATE.md

Editá `templates/STATE.md` según tu proyecto:
- Si usás sprints, agregá sección "Sprint Actual"
- Si tenés módulos, usá tabla de progreso
- Si no tenés módulos, usá lista simple

### Adaptar formato de commits

Editá `commands/commit.md` si tu proyecto usa otro estándar:
- Cambiar tipos (feat/fix/docs → add/change/remove)
- Cambiar formato (Conventional Commits → otro)

### Cambiar modelo del agente changelog

Por defecto usa Haiku (económico). Si querés más detalle:
```yaml
# En agents/doc-changelog.md
model: sonnet  # o claude-opus-4
```

---

## FAQ

### ¿Qué pasa si no tengo git en mi proyecto?

Los comandos `/load` y `/save` funcionan igual. El commit automático se saltea si no hay git.

### ¿Puedo usar otro formato de changelog?

Sí, editá `agents/doc-changelog.md` con el formato que prefieras.

### ¿Funciona con MCP servers?

Sí, es 100% compatible. Los comandos son skills estándar de Claude Code.

### ¿Qué pasa si mi .planning/ tiene otros archivos?

No hay problema. Este sistema es aditivo, no reemplaza lo que ya tenés.

### ¿Los dos archivos de GUARDRAILS son obligatorios?

No. Se crean automáticamente con `/save` cuando se detecta el primer error. Si no hay errores, no se crean.

### ¿Por qué dos archivos de GUARDRAILS en vez de uno?

Progressive disclosure: el índice carga rápido y es escaneable (~200 líneas), el detalle tiene ejemplos de código que pueden ser 2000+ líneas. No querés cargar todo eso en cada `/load`.

---

## CLAUDE.md - Global vs Proyecto

Este sistema separa instrucciones en dos niveles:

### Global (`~/.claude/CLAUDE.md`)

Reglas universales que aplican a **todas** las sesiones:
- Idioma (español docs, inglés código)
- Output conciso
- Bash vs PowerShell
- Formato de commits
- Seguridad básica

**No incluir en proyectos** - ya está en global.

### Proyecto (`CLAUDE.md` en raíz)

Información específica del proyecto:
- Stack tecnológico
- URLs y ambientes
- Scopes de commits
- Reglas específicas del proyecto

Ver `templates/CLAUDE.md` para guía de crecimiento por fases.

### Crecimiento recomendado

| Fase | Contenido | Líneas |
|------|-----------|--------|
| Planificación | Stack, decisiones pendientes | ~20 |
| Estructura | URLs, rutas | ~40 |
| Desarrollo | Scopes, comandos | ~70 |
| Reglas | Patrones específicos | ~90 |
| Producción | Ambientes, credenciales | ~110 |

**Máximo recomendado: ~120 líneas**

---

## Archivos incluidos

```
claude-memory-system/
├── README.md                 # Este archivo
├── BOOTSTRAP.md              # Guía de integración en proyecto existente
├── QUICK-START.md            # Guía rápida
├── INFO.txt                  # Metadatos del paquete
│
├── global/
│   └── CLAUDE.md            # Template CLAUDE.md global (~/.claude/)
│
├── commands/
│   ├── load.md              # Comando /load
│   ├── save.md              # Comando /save (con fase GUARDRAILS)
│   └── commit.md            # Comando /commit
│
├── agents/
│   └── doc-changelog.md     # Agente para changelog
│
└── templates/
    ├── CLAUDE.md            # Template de CLAUDE.md para proyectos
    ├── STATE.md             # Template de STATE
    ├── CHANGELOG.md         # Template de CHANGELOG
    ├── PROJECT.md           # Template de PROJECT
    ├── GUARDRAILS.md        # Template de índice
    └── GUARDRAILS-DETAIL.md # Template de enciclopedia
```

---

## Créditos

Sistema desarrollado y validado en múltiples proyectos reales (Laravel, Next.js, Python).

**Licencia**: Uso libre. Copiá, modificá, compartí.
