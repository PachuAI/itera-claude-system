---
description: 'Carga contexto al iniciar sesion. Ejecutar despues de /clear.'
model: 'sonnet'
---

# Carga de Contexto

## Pasos

1. Leer `.planning/STATE.md` (unico archivo obligatorio)
2. Presentar resumen conciso (max 15 lineas):

```markdown
## Sesion Cargada

**Ultima sesion**: [fecha] — [que se hizo en 1 linea]

**Estado modulos**: [solo si hay algo incompleto o bloqueado]

**Deuda tecnica pendiente**: [bullets de Proxima Accion del STATE.md]

---

Continuamos con esto o tenes algo nuevo para arrancar?
```

## Reglas

- NO leer GUARDRAILS.md automaticamente (esta en CLAUDE.md project instructions)
- NO leer CHANGELOG.md
- NO leer codigo fuente
- NO asumir que quiere hacer el usuario
- PREGUNTAR antes de actuar
