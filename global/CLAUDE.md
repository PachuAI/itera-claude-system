# Claude Global - [TU MARCA]

## Contexto
- Solo developer + agentic coding (Claude + otras IAs)
- Simplicidad sobre arquitecturas complejas
- No adoptar prácticas de equipos grandes
- Pragmático y directo

## Entorno
- Fecha: [ACTUALIZAR: YYYY-MM-DD], GMT-3 Argentina
- OS: Windows 10/11, PowerShell
- Claude Code terminal: Bash (usar mv, cp, rm, NO Move-Item)

## Idioma
- Español: comunicación, docs, commits
- Inglés: código, componentes, tipos, APIs

## Output
- Conciso y directo
- No repetir contenido de archivos leídos
- No explicar paso a paso
- Documentar en archivos, no en terminal

## Desarrollo
- Stack principal: [COMPLETAR: Next.js, React, TypeScript, Tailwind, Laravel, etc.]
- Validar siempre (Zod, schemas)
- No crear archivos innecesarios
- No sobreextenderse codeando - esperar input

## Commits
- Formato: tipo(scope): descripción
- En español, imperativo, max 72 chars
- feat/fix/docs/refactor/chore

## Referencias
- Progressive Disclosure: usar .planning/ cuando exista
- Leer GUARDRAILS.md antes de implementar

## Tools
- Read SIEMPRE antes de Edit/Write
- Task tool (Explore agent) para búsquedas grandes en codebase
- Parallel tool calls cuando no hay dependencias entre ellos

## Seguridad
- NUNCA commitear .env, API keys, secrets
- Documentar env vars en .env.example
- Validar y sanitizar input del usuario

## Git
- Commits pequeños y frecuentes
- NO force push a main/master
- Verificar que funciona antes de commit
- Preguntar antes de: rm archivos, git reset --hard

## Testing y Dependencies
- Correr tests después de cambios críticos
- npm run build para verificar antes de commit
- Avisar antes de agregar nuevas dependencias
