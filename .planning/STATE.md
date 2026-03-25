# Estado Actual - itera-claude-system

**Ultima actualizacion**: 2026-03-25
**Sesion**: #3

## Que es este proyecto

Sistema de productividad para proyectos Next.js con Claude Code. Incluye:
- Template curado (`_template/`): CLAUDE.md (Full + Simple), /save, /load, /check, /commit, scripts de enforcement
- Auditorias: /security-audit, /operational-audit
- Mapa de proyectos por capas y afinidad (`PROJECT-MAP.md`)
- Indice de infraestructura y deploy (`INFRA.md`)
- Comando `/sync` para propagar reglas entre proyectos del mismo grupo
- Global `~/.claude/CLAUDE.md` con reglas cross-proyecto

## Lo que cambio en esta sesion

### Estandarizacion completa (Fase 1-5)

**Auditoria** (Fase 1):
- Escaneados 18 proyectos en `nextjs/`, inventario de stack, CLAUDE.md, comandos, scripts

**Template actualizado** (Fase 2):
- `GUARDRAILS-DETAIL.md` eliminado del template
- `CLAUDE.md` actualizado con reglas de itera-lex (BetterAuth imports, Zod nullable, React 19 hooks, etc.)
- Referencias fantasma a `nextjs-boilerplate-betterauth/` corregidas en KICKSTART.md y kickstart-nextjs.md

**Propagacion a 14 proyectos** (Fase 3):
- GUARDRAILS-DETAIL.md archivado en 10 proyectos
- /save, /load copiados a 15 proyectos
- /check agregado a 8 proyectos
- scripts/ agregado a 8 proyectos
- CLAUDE.md actualizado en 13 proyectos (guardrails agregados o actualizados)
- itera-lex-docs: CLAUDE.md creado desde cero

**Global + Infra** (Fase 4):
- `~/.claude/CLAUDE.md` reescrito (77 -> 50 lineas, solo lo que Claude no puede descubrir)
- `INFRA.md` creado (9 proyectos deployados, Coolify UUIDs, URLs, puertos)
- Deduplicacion: ~61 lineas redundantes eliminadas de CLAUDE.md de proyectos

**Project Map + /sync** (Fase 5):
- `PROJECT-MAP.md` creado (14 proyectos, 4 grupos de afinidad)
- `/sync` creado en `C:\ALL MY PROJECTS\.claude\commands\`
- Sweep de indices: 7 archivos con referencias rotas/desactualizadas corregidos
- README.md, INFO.txt, vps-overview.md actualizados

## Proximos pasos

1. Correr `/sync` por primera vez para detectar reglas cross-proyecto faltantes
2. Completar Coolify UUIDs faltantes en INFRA.md (5 proyectos sin UUID documentado)
3. Considerar migrar itera-tube, alquimica-hub, presskit-ar de Prisma 5 a 7
