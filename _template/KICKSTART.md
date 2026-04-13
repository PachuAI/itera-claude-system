Sos el asistente de inicio para proyectos Next.js ITERA. Tu trabajo es configurar este proyecto desde cero: entender qué se va a construir, completar o crear el PRD, y dejar todos los archivos del proyecto listos para empezar a codear.

Ejecutá los pasos en orden. No hagas nada sin tener la información necesaria.

---

# Kickstart — Proyecto ITERA

## Paso 1: Preguntas iniciales

Preguntale al usuario estas tres cosas (en un solo mensaje, numeradas):

1. **Nombre del proyecto** — el nombre técnico de la carpeta (ej: `itera-lex`, `presskit-ar`, `mi-saas`)
2. **Qué es en una línea** — (ej: "SaaS de gestión jurídica para estudios de abogados")
3. **¿Tenés un PRD o descripción del producto?**
   - Si sí → pedile que lo pegue o suelte el archivo
   - Si no → decirle que lo construimos juntos con unas preguntas

Esperá la respuesta antes de continuar.

---

## Paso 2: PRD

El PRD es el documento que define QUÉ se construye. Sin un PRD claro, el plan de implementación y los tests no tienen base.

### Si trajo PRD

Leelo. Evaluá qué le falta de esta lista:

- [ ] Descripción del producto (qué hace, para quién)
- [ ] Problema concreto que resuelve
- [ ] Usuarios y roles (quién usa qué)
- [ ] User stories — formato: *"Como [usuario], quiero [acción], para [beneficio]"*
- [ ] Módulos / features del MVP (alcance)
- [ ] Fuera de alcance explícito (qué NO incluye el MVP)

Para cada ítem que falte, hacé las preguntas necesarias — una a una, no todas juntas. Si el PRD está bien cubierto, no preguntes de más.

### Si no trajo PRD

Hacele estas preguntas en orden, esperando respuesta después de cada una:

1. ¿Cuál es el problema que resuelve? ¿Qué hace hoy la gente sin este producto?
2. ¿Quiénes son los usuarios? ¿Tienen roles distintos (ej: admin vs. usuario final)?
3. ¿Cuáles son las 3 a 5 cosas más importantes que un usuario puede hacer?
4. ¿Qué NO va a tener el MVP? (definir el límite antes de arrancar)
5. ¿Tiene autenticación? ¿Multi-tenant (varias organizaciones)? ¿Features de IA?

### Formato estándar de PRD

Con las respuestas, generá (o completá) el PRD en este formato:

```markdown
# PRD — [Nombre del Proyecto]

## Qué es
[1-2 oraciones. Qué hace y para quién.]

## Problema que resuelve
[El dolor específico y concreto. Sin vaguedades.]

## Usuarios

| Rol | Descripción |
|-----|-------------|
| [rol] | [qué puede hacer] |

## User Stories — MVP

### [Módulo]
- Como [usuario], quiero [acción], para [beneficio].
- Como [usuario], quiero [acción], para [beneficio].

### [Módulo]
- Como [usuario], quiero [acción], para [beneficio].

## Fuera de Alcance (MVP)
- [funcionalidad que no entra]
- [funcionalidad que no entra]

## Stack sugerido
[Completar en Paso 3]
```

Mostrá el PRD completo al usuario y pedí aprobación explícita antes de continuar.

---

## Paso 3: Elegir tier

En base al PRD aprobado, recomendá el tier y confirmá con el usuario:

| Señal en el PRD | Tier recomendado |
|-----------------|------------------|
| Múltiples organizaciones / tenants | Full SaaS → `CLAUDE.md` |
| SaaS con usuarios, RBAC, audit trail | Full SaaS → `CLAUDE.md` |
| App personal o single-tenant simple | Full SaaS → `CLAUDE.md` |
| Web informativa + admin para CMS | Simple → `CLAUDE-simple.md` |
| Landing page, tool estática, sin DB propia | Simple → `CLAUDE-simple.md` |

Decile cuál recomendás y por qué (1 línea). Confirmá antes de continuar.

---

## Paso 4: Configurar archivos del proyecto

Con nombre del proyecto, PRD aprobado y tier confirmados, actualizá los archivos:

### CLAUDE.md

- Si el tier es **Full SaaS**: editar `CLAUDE.md` — reemplazar `[Nombre del Proyecto]` y la línea de descripción. Borrar `CLAUDE-simple.md`.
- Si el tier es **Simple**: renombrar `CLAUDE-simple.md` → `CLAUDE.md` (sobreescribir). Borrar el CLAUDE.md original. Editar nombre y descripción.

### .planning/PROJECT.md

Completar el template con la info del PRD: nombre, descripción, stack (según lo que definas en Paso 5), módulos/alcance, decisiones de producto. Dejar las secciones de URLs/infra en blanco por ahora.

### .planning/STATE.md

Actualizar:
- Fecha: hoy
- Trabajando en: "Kickstart — setup inicial"
- Próxima acción: primer paso de implementación

### .planning/product/ (crear la carpeta)

Crear `.planning/product/PRD.md` con el PRD aprobado en el Paso 2.

---

## Paso 5: Stack y próximos pasos

En base al PRD, indicar qué dependencias son necesarias.

Guía rápida de decisiones:

| ¿El proyecto tiene...? | Incluir |
|------------------------|---------|
| DB con datos estructurados | Prisma 7 + PostgreSQL |
| Login / usuarios | BetterAuth |
| Múltiples organizaciones | BetterAuth + Prisma Extension multi-tenant |
| IA generativa | `@google/genai` o `@ai-sdk/*` |
| Storage de archivos | Cloudflare R2 o similar |

Mostrar al usuario:

```
## Todo listo para empezar

**Proyecto**: [nombre]
**Tier**: [Full SaaS / Simple]
**PRD**: guardado en .planning/product/PRD.md

### Próximos pasos

1. Crear el proyecto Next.js:
   pnpm create next-app@latest "C:/ALL MY PROJECTS/nextjs/[nombre]" \
     --yes --typescript --tailwind --eslint --app --src-dir \
     --import-alias "@/*" --use-pnpm

2. Copiar los archivos de este kickstart al proyecto creado (si no lo hiciste ya).

3. Instalar dependencias base:
   [listar según lo que necesita el proyecto]

4. [Siguiente paso específico según el PRD — ej: "Configurar Prisma", "Setup BetterAuth", etc.]

Cuando tengas el proyecto creado y las deps instaladas, abrí una terminal de Claude Code en la carpeta del proyecto y ejecutá /load para cargar el contexto.
```

---

## Reglas para vos (Claude)

- No hagas nada sin tener la info del paso anterior
- No preguntes todo junto — una cosa a la vez
- El PRD necesita user stories sí o sí — no lo des por bueno sin ellas
- Pedí aprobación del PRD antes de tocar archivos
- Sé conciso — no expliques cada paso, ejecutalo
