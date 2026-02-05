---
description: "Guarda progreso al finalizar sesion. Actualiza docs de planificacion."
model: "sonnet"
---

# Guardado de Sesion - Fin de Sesion

El usuario quiere guardar el progreso antes de terminar la sesion.

## Tu tarea

1. Revisar GUARDRAILS (fase de aprendizaje)
2. Actualizar STATE.md con estado actual
3. Agregar entrada al CHANGELOG.md (via agente)
4. Ejecutar commit automatico (si hay git)

---

## Pasos

### 1. Fase GUARDRAILS - Revision de Errores (LA MÁS IMPORTANTE)

**ANTES de guardar**, revisar la sesion completa:

#### 1.1 Identificar errores cometidos

Buscar en la conversación:
- Bugs introducidos y luego corregidos
- Soluciones que no funcionaron a la primera
- Problemas de tipos, imports, configuración
- Cualquier "ida y vuelta" innecesaria
- Comandos que fallaron

#### 1.2 Leer GUARDRAILS.md (índice)

Si existe `.planning/GUARDRAILS.md`, leerlo para ver qué errores ya están documentados.

#### 1.3 Para cada error identificado

**Si el error YA estaba en el índice**:

1. Leer la entrada del índice
2. Leer GUARDRAILS-DETAIL.md#anchor para contexto completo
3. Analizar POR QUÉ se cometió igual:
   - ¿El check preventivo no era claro?
   - ¿El check no era suficientemente específico?
   - ¿Faltaba el "cuándo" o "qué hacer si falla"?
   - ¿El check no se aplicó por alguna razón?
4. MEJORAR el check preventivo en el índice
5. Agregar "Reforzado: [fecha]" a la entrada
6. Actualizar la Historia en GUARDRAILS-DETAIL.md

**Si el error NO estaba documentado**:

1. Crear entrada en GUARDRAILS.md (índice) - formato conciso
2. Crear entrada en GUARDRAILS-DETAIL.md - formato completo
3. Asegurar que el check preventivo sea ACCIONABLE

#### 1.4 Formato de entrada - Índice (GUARDRAILS.md)

```markdown
### [Tecnología] Título descriptivo

**Problema**: Descripción breve (1 línea)
**Check preventivo**: [CUÁNDO] → [ACCIÓN] → [SI FALLA]

**Agregado**: [fecha]
**Detalle**: GUARDRAILS-DETAIL.md#anchor
```

**CRÍTICO**: El check preventivo debe ser:
- **CUÁNDO**: En qué momento ejecutarlo (ej: "Después de CADA archivo")
- **ACCIÓN**: Qué hacer exactamente (ej: `npx tsc --noEmit && npm run lint`)
- **SI FALLA**: Qué hacer si falla (ej: "Arreglar ANTES de continuar")

#### 1.5 Formato de entrada - Detalle (GUARDRAILS-DETAIL.md)

```markdown
## anchor-del-error

### [Tecnología] Título descriptivo

**Error**:
\`\`\`
[mensaje de error textual]
\`\`\`

**Por qué ocurre**:
[Explicación completa]

**Solución**:
\`\`\`[lenguaje]
[código de ejemplo]
\`\`\`

**Patrón típico del error**:
\`\`\`[lenguaje]
// Código que causa el error
\`\`\`

**Historia**:
- [fecha]: Agregado - [contexto]
```

#### 1.6 Si GUARDRAILS no existe, CREARLO

1. Analizar stack del proyecto (package.json, composer.json, requirements.txt, etc.)
2. Crear GUARDRAILS.md con:
   - Tabla de stack y versiones
   - Estructura de Parte 1 (stack-específicos) y Parte 2 (generales)
3. Crear GUARDRAILS-DETAIL.md con estructura base
4. Agregar las primeras entradas de errores detectados

---

### 2. Recopilar información de la sesión

Revisa la conversación actual para identificar:
- Qué tareas se completaron
- Qué decisiones se tomaron
- Qué archivos se modificaron
- Qué quedó pendiente

---

### 3. Actualizar STATE.md

Edita `.planning/STATE.md` (SOBRESCRIBIR estado actual):

```markdown
## Sesion Actual
**Fecha**: [YYYY-MM-DD]
**Trabajando en**: [descripción breve]

## Progreso
[Actualizar con lo completado]

## Decisiones Recientes
[Mantener solo últimas ~15 - las anteriores están en CHANGELOG]

## Bloqueadores
[Actualizar si hay nuevos o se resolvieron]

## Próxima Acción
[Qué sigue para la próxima sesión]
```

**IMPORTANTE**: STATE.md debe ser CONCISO. Max 100-150 líneas.

---

### 4. Agregar entrada al CHANGELOG

Usa el agente `doc-changelog`:

```
Task tool:
  subagent_type: "doc-changelog"
  description: "Actualizar CHANGELOG sesion"
  prompt: |
    Sesion del [fecha de hoy].

    Que se hizo:
    - [tarea 1]
    - [tarea 2]

    Archivos clave:
    - [archivo 1] - [cambio]

    Decisiones:
    - [decision 1] (si las hubo)
```

---

### 5. Ejecutar commit automático

#### 5.1 Verificar cambios
```bash
git status --porcelain
```

Si no hay cambios → Skip commit → Ir a paso 6

#### 5.2 Generar mensaje
```bash
git diff --stat
```

**Formato**: `<tipo>(<scope>): <descripción>`

**Tipos**: feat, fix, refactor, style, test, docs, chore

**Reglas**:
- Primera línea max 72 caracteres
- Imperativo ("agregar", "corregir", "implementar")
- Minúsculas, sin punto final
- NO agregar Co-Authored-By

#### 5.3 Ejecutar commit
```bash
git add -A
git commit -m "<mensaje>"
```

---

## 6. Confirmar al usuario

```markdown
## Sesión Guardada

### GUARDRAILS
- [x] Revisados: [N errores analizados]
- [actualizaciones hechas al índice/detail]

### Documentos actualizados
- [x] STATE.md - [breve descripción]
- [x] CHANGELOG.md - Entrada agregada
- [x] GUARDRAILS.md - [si se actualizó]
- [x] GUARDRAILS-DETAIL.md - [si se actualizó]

### Commit realizado
`<tipo>(<scope>): <descripción>`
Branch: [branch] | Archivos: [N]

### Para retomar
[1-2 oraciones de lo que sigue]

---
Podés hacer /clear tranquilo.
```

---

## Checklist mental

Antes de guardar, verificar:
- [ ] GUARDRAILS revisados (errores analizados, checks mejorados si aplica)
- [ ] Tests pasan? (si hubo cambios de código)
- [ ] Build OK? (si hubo cambios que requieren build)

Si falta algo, mencionarlo ANTES de guardar.

---

## Notas

- La fase GUARDRAILS es LA MÁS IMPORTANTE - captura aprendizajes
- El objetivo es que los checks preventivos sean tan buenos que eviten el error
- Si un error se repite, el check no era suficientemente claro/específico
- STATE.md se SOBRESCRIBE (no acumular historial ahí)
- CHANGELOG.md ACUMULA (nunca borrar entradas)
- El commit es OBLIGATORIO si hay cambios y el proyecto tiene git
