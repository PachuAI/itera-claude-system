# Bootstrap: Integrar Claude Memory System en Proyecto Existente

> Guía para integrar el sistema de memoria en un proyecto que ya tiene desarrollo avanzado.

---

## Contexto

Estamos integrando un sistema de gestión de sesiones para mantener memoria a largo plazo entre sesiones de desarrollo. El proyecto ya tiene avance, así que no partimos de cero.

### Estructura del sistema

```
.planning/
├── PROJECT.md           # Contexto base del proyecto (raramente cambia)
├── STATE.md             # Estado actual (se sobrescribe cada /save)
├── CHANGELOG.md         # Historial de sesiones (se acumula cada /save)
├── GUARDRAILS.md        # Índice de errores conocidos (conciso)
└── GUARDRAILS-DETAIL.md # Enciclopedia de errores (detallado)

.claude/
├── commands/
│   ├── load.md          # Inicio de sesión
│   ├── save.md          # Fin de sesión
│   └── commit.md        # Solo commit
└── agents/
    └── doc-changelog.md # Agente para actualizar changelog
```

### Qué hace cada archivo

| Archivo | Propósito | Cuándo se actualiza |
|---------|-----------|---------------------|
| `PROJECT.md` | "Qué es este proyecto" - contexto inmutable | Raramente |
| `STATE.md` | "Dónde estamos HOY" - estado conciso | Cada `/save` (sobrescribe) |
| `CHANGELOG.md` | "Cómo llegamos" - historial completo | Cada `/save` (acumula) |
| `GUARDRAILS.md` | "Qué errores NO repetir" - índice | Cuando se detectan errores |
| `GUARDRAILS-DETAIL.md` | "Por qué ocurren" - enciclopedia | Cuando se detectan errores |

---

## Tarea para Claude: Crear la estructura inicial

### Paso 1: Copiar archivos base

```bash
# Crear carpetas
mkdir -p .claude/commands .claude/agents .planning

# Copiar comandos y agentes
cp claude-memory-system/commands/* .claude/commands/
cp claude-memory-system/agents/* .claude/agents/

# Copiar templates (opcional, mejor crearlos desde cero con contexto real)
cp claude-memory-system/templates/* .planning/
```

### Paso 2: Crear PROJECT.md

Analiza el proyecto actual (README, código, commits recientes) y crea `.planning/PROJECT.md`:

```markdown
# [Nombre del Proyecto]

## Qué es

[Descripción concisa en 2-3 oraciones de qué hace el proyecto]

## Stack

**Frontend**: [ej: Next.js 14, React 18, TailwindCSS]
**Backend**: [ej: Node.js, Express, PostgreSQL]
**Deploy**: [ej: Vercel, Railway, Docker]

## MVP / Alcance

[Qué features debe tener para considerarse "completo"]

### Módulos principales

- [Módulo 1]: [descripción breve]
- [Módulo 2]: [descripción breve]
- [Módulo 3]: [descripción breve]

## Decisiones Arquitectónicas

| Decisión | Por qué |
|----------|---------|
| [ej: Prisma ORM] | [ej: Tipado fuerte, migraciones simples] |
| [ej: shadcn/ui] | [ej: Componentes customizables] |
```

### Paso 3: Crear STATE.md

Analiza el estado actual del proyecto y crea `.planning/STATE.md`:

```markdown
# Estado Actual

## Sesión Actual

**Fecha**: [hoy]
**Trabajando en**: Integrando sistema de memoria

---

## Progreso General

[Resumen de dónde está el proyecto]

| Módulo/Feature | Estado | Notas |
|----------------|--------|-------|
| [Módulo 1] | ✅ Completo | [notas si aplica] |
| [Módulo 2] | 🚧 En progreso | [qué falta] |
| [Módulo 3] | ⏸️ Pendiente | |

---

## Decisiones Recientes

| Fecha | Decisión |
|-------|----------|
| [fecha] | [decisión importante] |

---

## Próxima Acción

[Qué sigue - puede ser continuar con desarrollo, testing, deploy, etc.]

---

## Bloqueadores

**Sin bloqueadores activos**
```

### Paso 4: Migrar/Crear CHANGELOG.md

**Si ya existe** un changelog, changelog.md, HISTORY.md o similar:
- Moverlo a `.planning/CHANGELOG.md`
- Verificar que el formato sea consistente con el template

**Si no existe**:
- Crear `.planning/CHANGELOG.md`
- Reconstruir historial básico desde git log o memoria de sesiones:

```bash
# Ver commits recientes agrupados por fecha
git log --pretty=format:"%ad - %s" --date=format:"%d %b %Y" | head -30
```

Formato de cada entrada:

```markdown
## [DD Mes AAAA] - Título descriptivo

### Qué se hizo
- Punto 1
- Punto 2

### Archivos clave
- `path/archivo` - qué cambió

### Decisiones
- Decisión técnica importante (si hubo)

---
```

### Paso 5: GUARDRAILS (se crean automáticamente)

**No es necesario crearlos de entrada**. Se crean automáticamente con `/save` cuando se detecta el primer error en una sesión.

El sistema crea DOS archivos:
- `GUARDRAILS.md` - Índice conciso con checks preventivos
- `GUARDRAILS-DETAIL.md` - Enciclopedia con código y contexto

**Si querés crearlos de entrada**, analiza el stack del proyecto:

```markdown
# GUARDRAILS.md (índice)

## Stack del Proyecto

| Tecnología | Versión |
|------------|---------|
| [Framework] | [versión] |
| [ORM] | [versión] |

## Parte 1: Guardrails Específicos del Stack

*Sin entradas todavía.*

## Parte 2: Guardrails Generales

*Sin entradas todavía.*
```

```markdown
# GUARDRAILS-DETAIL.md (enciclopedia)

## Parte 1: Stack-Específicos

*Sin entradas todavía.*

## Parte 2: Generales

*Sin entradas todavía.*
```

---

## Sistema GUARDRAILS - Progressive Disclosure

El sistema de GUARDRAILS usa progressive disclosure para balancear velocidad y detalle:

### Por qué dos archivos

| Archivo | Lee con /load | Tamaño | Propósito |
|---------|---------------|--------|-----------|
| `GUARDRAILS.md` | ✅ Siempre | ~100-200 líneas | Checks preventivos accionables |
| `GUARDRAILS-DETAIL.md` | ❌ Solo si necesita | Sin límite | Código, contexto, historia |

### El check preventivo es CLAVE

Cada entrada en el índice tiene un **check preventivo** que debe ser ACCIONABLE:

```markdown
# MAL - Vago, no previene nada
**Check preventivo**: Revisar imports antes de commitear

# BIEN - Específico, cuándo, qué hacer si falla
**Check preventivo**: Después de CADA archivo → `npm run lint` → Si falla, arreglar ANTES de continuar
```

Formato: `[CUÁNDO] → [ACCIÓN ESPECÍFICA] → [QUÉ HACER SI FALLA]`

### Flujo de uso

1. **Con /load**: Claude lee índice → internaliza checks
2. **Mientras codea**: Claude aplica checks mecánicamente
3. **Si comete error**: Claude lee DETAIL para entender por qué
4. **Con /save**: Si hubo errores, actualiza índice (mejora check) y detail

---

## Flujo de trabajo después de integrar

### Inicio de sesión
```
Usuario: /load
Claude: Lee STATE.md + GUARDRAILS.md → Resume → Lista checks → Pregunta qué hacer
Usuario: "Continuemos con X" o "Hay que implementar Y"
```

### Durante la sesión
```
Claude: Trabaja en las tareas
Claude: Aplica checks preventivos mientras codea
Claude: Commits por tarea significativa (con /commit o manualmente)
```

### Fin de sesión
```
Usuario: /save
Claude: Revisa errores → GUARDRAILS (índice + detail) → STATE → CHANGELOG → commit
Claude: Confirma qué se guardó
Usuario: /clear (listo para próxima sesión)
```

---

## Checklist de integración

- [ ] Crear carpetas `.planning/` y `.claude/commands/` y `.claude/agents/`
- [ ] Copiar comandos y agentes desde `claude-memory-system/`
- [ ] Crear `PROJECT.md` con contexto base del proyecto
- [ ] Crear `STATE.md` con estado actual (analizar git log + código)
- [ ] Migrar o crear `CHANGELOG.md` con historial básico
- [ ] GUARDRAILS se crean automáticamente (o crear manualmente si querés)
- [ ] Probar flujo: `/load` → trabajar → `/save`
- [ ] Confirmar que el changelog se acumula correctamente
- [ ] Confirmar que commits automáticos funcionan (si tenés git)

---

## Migración desde otro sistema de docs

Si tu proyecto ya tiene otros archivos de planning/documentación:

### Si tenés ROADMAP.md, PLAN.md, o similar
- **Mantenerlos** - este sistema es aditivo
- Extraer el estado actual al `STATE.md`
- El historial de hitos/fases va al `CHANGELOG.md`

### Si tenés TODO.md o task lists
- Migrar tasks abiertas a `STATE.md` → sección "Próxima Acción"
- Migrar tasks completadas al `CHANGELOG.md`

### Si tenés múltiples archivos de notas
- Consolidar contexto importante en `STATE.md`
- Mover historial a `CHANGELOG.md`
- Archivar notas viejas en `docs/archive/` o borrarlas

**Regla de oro**: STATE.md debe ser conciso (max 100-150 líneas). Si algo no se usa hace semanas, no va en STATE.

---

## Troubleshooting

### "El agente doc-changelog no funciona"
Verificar que el archivo esté en `.claude/agents/doc-changelog.md` y tenga el frontmatter correcto.

### "Los comandos /load y /save no aparecen"
Verificar que estén en `.claude/commands/` con extension `.md` y frontmatter.

### "El changelog se genera en el lugar equivocado"
El agente busca `.planning/CHANGELOG.md`. Asegurate de que el archivo exista ahí.

### "Los commits no se ejecutan automáticamente"
Verificar que el proyecto tenga git inicializado. Si no tenés git, está bien - solo se saltea el commit.

### "GUARDRAILS no se crean"
Se crean solo cuando hay errores en la sesión. Si no hubo errores, no se crean (y está bien).

---

## Notas finales

- Este sistema es **ADITIVO**, no reemplaza lo que funcionaba
- Si algo no aplica a tu proyecto, ignoralo o customizalo
- La clave es: **STATE** para contexto rápido, **CHANGELOG** para historial, **GUARDRAILS** para no repetir errores
- Progressive disclosure: índice rápido, detalle cuando se necesita
- Adaptar según las necesidades del proyecto

**Filosofía**: Menos es más. Si un documento no se lee hace semanas, borrarlo o archivarlo.
