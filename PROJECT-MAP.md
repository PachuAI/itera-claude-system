# Project Map — ITERA Next.js

> Indice de todos los proyectos, clasificados por capas funcionales y agrupados por afinidad.
> Usar para propagar reglas entre proyectos similares (`/sync`).
> Ultima actualizacion: 2026-04-10

---

## Proyectos por Capas

| Proyecto | auth | crud | ai | files | marketing | Otras capas | Estado | Deploy |
|----------|------|------|----|-------|-----------|-------------|--------|--------|
| itera-lex | BA+MT | P7 | Anthropic+Google | R2+Drive | landing+blog | calendar, payments, transcription, tts, pdf | activo | si |
| itera-estudio | BA | P7 | Gemini | R2 | — | API interna (ecosistema) | activo | si |
| itera-link | BA | P7 | — (Itera Estudio API) | R2 | landing+SEO | banners IA, link-in-bio, MT en desarrollo | activo | si |
| shope-ar (Shopear) | BA | P7 | — (Itera Estudio API) | R2 | landing+SEO | whatsapp (checkout), MT en desarrollo | activo | si |
| itera-chatbots-platform | BA | P7 | AI SDK v6 | — | — | realtime (SSE widget) | stand-by | no |
| bambu-web-corporativa | BA | P7 | — | R2 | corporativa+catalogo | email (captacion) | activo | si |
| alquimica-web-corporativa | BA | P7 | — | — | corporativa | email (contacto) | activo | no |
| alquimica-hub | NA5 | P5 | — | R2 | link-in-bio | precios multi-lista | legacy | si |
| presskit-ar | NA5 | P5 | — | R2/local | — | email (nodemailer), pdf | activo | si |
| itera-tube | NA5 | P5 | Gemini | — | — | tts (ElevenLabs), scraping (yt-dlp) | activo | parcial |
| wsp-facil | NA5 | P5 | OpenAI+Gemini | — | — | transcription (Groq+Whisper+ElevenLabs) | activo | no |
| itera-yt-downloader | NA5 | P5 | — | — | — | scraping (yt-dlp), realtime (SSE) | pausado | no |
| itera-lat | — | — | — | — | portfolio | — | activo | si |
| itera-pages | — | — | — | — | landing pages | — | activo | no |
| itera-lex-docs | — | — | — | — | documentacion | — | pausado | si |

> **BA** = BetterAuth, **NA5** = NextAuth v5, **MT** = multi-tenant, **P7** = Prisma 7, **P5** = Prisma 5

---

## Grupos de Afinidad

### Grupo 1 — SaaS (con o sin IA)

**Proyectos**: itera-lex, itera-estudio, itera-link, shope-ar (Shopear)

**Stack comun**: Next.js 16 + Prisma 7 + BetterAuth + Tailwind v4 + shadcn/ui

**Reglas que fluyen dentro del grupo**:
- BetterAuth (globalThis singleton, nextCookies, disableRefresh, imports, CLI)
- Prisma 7 completo (prisma.config.ts, generated imports, $transaction, findMany+take)
- Multi-tenant: registro publico, tenant isolation, ownership validation
- Service layer obligatorio (auth -> authorize -> validate -> service -> audit -> revalidate)
- Security checklists completos (IDOR, FK validation, ownership, upload validation)
- Ecosistema: integración via Itera Estudio API para generación de imágenes (Shopear banners, IteraLink banners)
- AI (donde aplique): prompts en ingles, rate limiting, confirmacion humana para side effects

**Referencia**: itera-lex es el proyecto mas maduro del grupo (MT completo, billing, AI).

**Nota**: itera-link y shope-ar están en transición de single-tenant a multi-tenant. alquimica-hub es el repo legacy de IteraLink (solo producción del cliente, no recibe features nuevas).

---

### Grupo 2 — Web + Catalogo + Admin (clientes)

**Proyectos**: bambu-web-corporativa-catalogo, alquimica-web-corporativa, presskit-ar

**Stack comun**: Next.js 16 + Prisma (5 o 7) + auth + sitio publico + panel admin

**Reglas que fluyen dentro del grupo**:
- Admin panel con guard de auth
- Catalogo publico con SEO (sitemap, robots, OG images, metadata)
- Upload de imagenes a R2 (MIME validation, file.size server-side)
- Zod forms con React Hook Form
- Deploy Docker/Coolify
- Queries publicas filtrar por estado (published/active)

---

### Grupo 3 — Content Tools

**Proyectos**: itera-tube, wsp-facil, itera-yt-downloader

**Stack comun**: Next.js 16 + Prisma 5 + NextAuth v5 + procesamiento de media

**Reglas que fluyen dentro del grupo**:
- yt-dlp CLI para scraping (NUNCA youtube-transcript npm)
- Rate limiting para APIs externas (Gemini, ElevenLabs, Groq)
- SSE/streaming para progreso en tiempo real
- AI analysis con parseo defensivo de responses
- Audio/video processing con limites de tamano

**Diferencias internas**:
- itera-tube: TTS (ElevenLabs), YouTube content
- wsp-facil: STT (Groq+Whisper+ElevenLabs Scribe), WhatsApp audio
- itera-yt-downloader: download + metadata extraction

---

### Grupo 4 — Marketing / Static

**Proyectos**: itera-lat, itera-pages, itera-lex-docs

**Stack comun**: Next.js 16 + Tailwind v4 + contenido estatico

**Reglas que fluyen dentro del grupo**:
- SEO (metadata, sitemap, robots, OG images)
- Performance (next/image, lazy loading, Framer Motion)
- Sin Prisma, sin auth, sin server actions
- Deploy estatico o SSG

---

## Como usar este mapa

1. **Propagar reglas**: cuando un proyecto descubre un error/patron, verificar si aplica a otros del mismo grupo
2. **`/sync`**: correr desde `C:\ALL MY PROJECTS\` para detectar reglas que estan en un proyecto pero no en otros del mismo grupo
3. **Nuevo proyecto**: ubicar en el grupo correcto y copiar el CLAUDE.md del proyecto mas afin como base
4. **Cross-pollination**: reglas de Grupo 1 pueden bajar a Grupo 2 (ej: security checklists). Reglas de Grupo 3 pueden subir a Grupo 1 (ej: rate limiting AI).
