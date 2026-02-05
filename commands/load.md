---
description: "Carga contexto al iniciar sesion. Ejecutar despues de /clear."
model: "sonnet"
---

# Carga de Contexto - Inicio de Sesion

El usuario quiere retomar el trabajo. Cargar contexto y resumir estado.

## Pasos

### 1. Leer documentos base

```
.planning/STATE.md      ← SIEMPRE (estado actual)
.planning/GUARDRAILS.md ← SIEMPRE (índice de checks preventivos)
.planning/PROJECT.md    ← Solo si es primera sesión o usuario lo pide
```

**IMPORTANTE**: Solo leer GUARDRAILS.md (índice), NO leer GUARDRAILS-DETAIL.md.
El detalle solo se lee cuando se necesita entender un error específico.

### 2. Leer contexto adicional (opcional)

```
.planning/CHANGELOG.md  ← Últimas 2-3 entradas para contexto reciente
```

### 3. Internalizar checks preventivos

Del GUARDRAILS.md, identificar los checks que aplican al trabajo pendiente.
Estos se deben aplicar mecánicamente mientras se codea.

### 4. Presentar resumen

```markdown
## Sesion Cargada

**Proyecto**: [nombre del proyecto]
**Ultima sesion**: [fecha] - [que se hizo]

### Estado actual
- [Resumen de donde estamos]
- [Bloqueadores si los hay]

### Checks preventivos activos
- [Check 1 relevante para el trabajo pendiente]
- [Check 2 relevante]

### Proxima accion sugerida
[Lo que sigue segun STATE.md]

---

¿Continuamos con esto o hay algo mas urgente?
```

## Reglas

- NO leer archivos de código automáticamente
- NO asumir qué quiere hacer el usuario
- SER CONCISO en el resumen (máximo 20 líneas)
- SIEMPRE preguntar antes de actuar
- MENCIONAR checks preventivos relevantes (no todos, solo los que aplican)
- NO leer GUARDRAILS-DETAIL.md en /load (solo el índice)

## Aplicar checks durante la sesión

Después de /load, mientras se trabaja:

1. **Antes de modificar archivo**: Revisar si hay check aplicable
2. **Después de modificar archivo**: Ejecutar check si corresponde
3. **Si el check falla**: Arreglar ANTES de continuar con otro archivo

## Notas

- Si `.planning/STATE.md` no existe, indicar al usuario que debe crearlo
- Si `.planning/GUARDRAILS.md` no existe, está OK (se crea con /save al detectar errores)
- Si el usuario pide contexto de un error específico, ENTONCES leer GUARDRAILS-DETAIL.md
