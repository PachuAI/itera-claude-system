# Guardrails

> Checks preventivos para evitar errores conocidos.
> Se lee con cada `/load`. Debe ser CONCISO y ACCIONABLE.
> Si un error se repite (aparece 2+ veces aca) -> promover a CLAUDE.md como regla permanente.

---

## Stack del Proyecto

| Tecnologia | Version |
|------------|---------|
| [Framework] | [version] |
| [Runtime] | [version] |
| [ORM/DB] | [version] |
| [UI Library] | [version] |

---

## Errores Conocidos

### Formato de cada entrada

```markdown
### [Tecnologia] Titulo descriptivo

**Problema**: Descripcion breve (1 linea)
**Check preventivo**: [CUANDO] -> [ACCION] -> [SI FALLA]

**Agregado**: [fecha]
```

### El Check Preventivo es CLAVE

El check debe ser **ACCIONABLE**, no descriptivo:

```markdown
# MAL - Vago
**Check preventivo**: Revisar imports

# BIEN - Especifico y mecanico
**Check preventivo**: Despues de CADA archivo -> `npm run lint` -> Si falla, arreglar ANTES de continuar
```

Formato: `[CUANDO] -> [ACCION ESPECIFICA] -> [QUE HACER SI FALLA]`

---

## Entradas

*Sin entradas todavia. Se agregan con `/save` cuando se detectan errores.*

---

## Flujo de escalacion

1. Error nuevo -> agregar aca con check preventivo
2. Error se repite (2da vez) -> promover a CLAUDE.md como bullet permanente
3. Marcar aca: "-> promovido a CLAUDE.md [fecha]"

Los checks promovidos a CLAUDE.md se aplican SIEMPRE. Los de aca son el primer filtro.
