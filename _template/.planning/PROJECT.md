# [Nombre del Proyecto]

> [Descripción en 1 línea]. Producto tipo: [analogía conocida, ej: "Linktree pero para músicos"].

**Última actualización**: [DD Mes YYYY]

---

## Qué es

[Descripción concisa en 2-3 oraciones de qué hace el proyecto]

| Campo | Valor |
|-------|-------|
| **Marca comercial** | [Nombre público si difiere del interno] |
| **Estado** | [En desarrollo / MVP / Producción / Privado] |
| **Progreso** | [ej: FASE 1 ✅ · FASE 2 ⏳] |
| **Desarrollador** | Pachu (ÍTERA) |

---

## Stack Técnico

| Capa | Tecnología | Versión |
|------|------------|---------|
| Framework | [ej: Next.js (App Router)] | [ej: 16] |
| UI | [ej: React + Tailwind + shadcn/ui] | [ej: 19] |
| Auth | [ej: Auth.js / NextAuth.js] | [ej: v5] |
| ORM | [ej: Prisma] | [ej: 5] |
| DB | [ej: PostgreSQL] | [ej: 17] |
| Deploy | [ej: Coolify en Hetzner VPS] | - |

---

## Arquitectura

| Decisión | Por qué |
|----------|---------|
| [ej: Next.js App Router] | [ej: SSR, API routes integradas, RSC] |
| [ej: Prisma ORM] | [ej: Tipado fuerte, migraciones simples] |
| [ej: shadcn/ui] | [ej: Componentes customizables, no librería pesada] |
| [ej: Services Layer] | [ej: Lógica centralizada, SOLID] |

---

## Módulos / Alcance

### [Módulo 1] ✅
- Feature implementada
- Otra feature implementada

### [Módulo 2] ⏳
- Feature pendiente
- Otra feature pendiente

---

## URLs / Rutas Principales

| Ruta | Descripción |
|------|-------------|
| `/` | [ej: Landing o Dashboard] |
| `/[slug]` | [ej: Perfil público] |
| `/panel` | [ej: Dashboard del usuario] |
| `/admin` | [ej: Panel de administración] |
| `/api/*` | [ej: API endpoints] |

---

## Infraestructura de Producción

### VPS: itera-modern (Hetzner Cloud)

| Recurso | Valor |
|---------|-------|
| **IP** | 65.108.148.79 |
| **Plan** | Hetzner CX32 (8 GB RAM, 76 GB disco) |
| **OS** | Ubuntu 24.04 LTS |
| **Panel** | Coolify 4.0.0-beta.462 |
| **Coolify URL** | https://coolify-modern.iteraestudio.com |

### Deploy

| Aspecto | Detalle |
|---------|---------|
| **Método** | git push → GitHub → Coolify auto-deploy |
| **GitHub App** | coolify-itera-modern |
| **Base de datos** | PostgreSQL 17 (container en Coolify) |
| **SSL** | Let's Encrypt automático vía Traefik |
| **Dominio** | [dominio.com] |

---

## Desarrollo Local

| Herramienta | Detalle |
|-------------|---------|
| **Node.js** | v22.16.0 |
| **PostgreSQL** | 17.5 (via Laragon, corre 24/7) |
| **Puerto dev** | [ej: 3000] |
| **Terminal Claude Code** | Bash (NO PowerShell) |

---

## Estructura del Proyecto

```
[nombre-proyecto]/
├── prisma/              # Schema y migraciones
├── public/              # Assets estáticos
├── src/
│   ├── app/
│   │   ├── (auth)/      # Rutas de autenticación
│   │   ├── (dashboard)/ # Rutas protegidas
│   │   ├── (public)/    # Rutas públicas
│   │   └── api/         # API routes
│   ├── components/
│   │   ├── ui/          # shadcn/ui
│   │   └── [feature]/   # Por módulo
│   └── lib/
│       ├── services/    # Lógica de negocio
│       ├── validations/ # Schemas Zod
│       └── utils/       # Helpers
└── .planning/           # Documentación del proyecto
```

---

## Notas para Agentes IA

1. **[Nota crítica 1]**: [ej: Usar SDK X, NO SDK Y (deprecado)]
2. **[Nota crítica 2]**: [ej: Next.js 16 - cookies/headers/params son async]
3. **[Nota crítica 3]**: [ej: Terminal Claude Code usa Bash, NO PowerShell]
4. **[Nota crítica 4]**: [ej: Validar siempre con Zod antes de procesar]
5. **[Nota crítica 5]**: [ej: Leer GUARDRAILS.md antes de implementar]

---

## Decisiones de Producto

| Decisión | Respuesta |
|----------|-----------|
| [ej: Múltiples X por Y] | ✅/❌ [Justificación breve] |
| [ej: Input manual de Z] | ✅/❌ [Justificación breve] |
| [ej: Integración con API externa] | ✅/❌ [Justificación breve] |

---

## Usuarios / Roles

| Rol | Permisos |
|-----|----------|
| USER | [ej: CRUD de su contenido, publicar] |
| ADMIN | [ej: Todo + gestionar usuarios/planes] |

---

## Documentación Relacionada

| Archivo | Propósito |
|---------|-----------|
| `.planning/STATE.md` | Estado actual y última sesión |
| `.planning/ROADMAP.md` | Fases del proyecto |
| `.planning/GUARDRAILS.md` | Checks preventivos |
| `docs/technical/ARCHITECTURE.md` | Patrones y estructura |
| `docs/ENVIRONMENT.md` | Config de entorno |
