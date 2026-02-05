# Quick Start - Claude Memory System

Cómo usar este paquete en 5 minutos.

---

## Instalación en proyecto nuevo

```bash
# 1. Copiar estructura completa
cp -r claude-memory-system/commands .claude/
cp -r claude-memory-system/agents .claude/
cp -r claude-memory-system/templates .planning/

# 2. Editar .planning/PROJECT.md con info de tu proyecto
# 3. Editar .planning/STATE.md con estado actual
# 4. GUARDRAILS.md y GUARDRAILS-DETAIL.md se crean automáticamente con /save

# Listo! Ya podes usar:
# - /load (cargar contexto)
# - /save (guardar progreso)
# - /commit (crear commit)
```

---

## Instalación en proyecto existente

```bash
# 1. Copiar comandos y agentes
cp -r claude-memory-system/commands .claude/
cp -r claude-memory-system/agents .claude/

# 2. Crear .planning/ manualmente con contexto real del proyecto
mkdir .planning

# 3. Ver BOOTSTRAP.md para guía detallada
```

---

## Uso diario

### Inicio de sesión
```
> /load
```
Claude lee STATE.md + GUARDRAILS.md (índice), te resume dónde quedó el proyecto y qué checks preventivos aplicar.

### Durante la sesión
Trabajá normalmente. Claude aplica los checks preventivos mientras codea.
Si querés commitear algo:
```
> /commit
```

### Fin de sesión
```
> /save
```
Claude revisa errores → actualiza GUARDRAILS (índice + detail) → STATE → CHANGELOG → commit automático.

---

## Sistema GUARDRAILS (Progressive Disclosure)

Dos archivos para evitar repetir errores:

| Archivo | Propósito | Tamaño |
|---------|-----------|--------|
| `GUARDRAILS.md` | Índice con checks preventivos | ~100-200 líneas |
| `GUARDRAILS-DETAIL.md` | Enciclopedia con código y contexto | Sin límite |

**¿Por qué dos archivos?**
- El índice se lee siempre (rápido)
- El detalle solo cuando se necesita entender un error
- Progressive disclosure: info concisa por defecto, detalle disponible

**El check preventivo es CLAVE**:
```markdown
# MAL - Vago
**Check preventivo**: Revisar imports

# BIEN - Específico y accionable
**Check preventivo**: Después de CADA archivo → `npm run lint` → Si falla, arreglar ANTES de continuar
```

---

## Personalización

### Cambiar formato de STATE.md
Editá `templates/STATE.md` y adaptar secciones a tu proyecto.

### Cambiar formato de commits
Editá `commands/commit.md` y modificar el formato.

### Usar Sonnet en vez de Haiku para changelog
En `agents/doc-changelog.md`, cambiar:
```yaml
model: haiku  →  model: sonnet
```

---

## Archivos incluidos

```
claude-memory-system/
├── README.md              # Documentación completa
├── BOOTSTRAP.md           # Guía de integración
├── QUICK-START.md         # Esta guía
├── INFO.txt               # Metadatos
│
├── commands/
│   ├── load.md           # /load
│   ├── save.md           # /save
│   └── commit.md         # /commit
│
├── agents/
│   └── doc-changelog.md  # Agente changelog
│
└── templates/
    ├── PROJECT.md        # Contexto base
    ├── STATE.md          # Estado actual
    ├── CHANGELOG.md      # Historial
    ├── GUARDRAILS.md     # Índice de errores
    └── GUARDRAILS-DETAIL.md  # Enciclopedia de errores
```

---

## Preguntas frecuentes

**¿Funciona sin git?**
Sí, solo se saltea el paso del commit automático.

**¿Funciona con cualquier lenguaje?**
Sí, es 100% agnóstico de stack.

**¿Los dos archivos de GUARDRAILS son obligatorios?**
No. Se crean automáticamente con `/save` cuando se detecta el primer error.

**¿Por qué dos archivos de GUARDRAILS?**
Progressive disclosure: índice rápido para checks, detalle para entender errores.

**¿Puedo modificar los comandos?**
Sí, son archivos markdown normales. Adaptá lo que necesites.

---

## Siguiente paso

Lee `README.md` para entender la filosofía completa del sistema.
