# Guia de Testing E2E con Playwright

> Referencia interna para todos los proyectos Itera. Ultima actualizacion: 2026-03-25.

## Stack elegido

- **Playwright Test** (`@playwright/test`) para escribir y correr tests
- **Playwright MCP** para explorar la app y generar tests con IA
- **Playwright Test Agents** (planner/generator/healer) para asistencia IA

## Conceptos clave

### Playwright vs Playwright MCP

| | Playwright Test | Playwright MCP |
|---|---|---|
| Que es | Framework de testing, archivos `.spec.ts` | Servidor MCP que le da al LLM control del browser |
| Quien controla | Un script determinista | Claude/IA en tiempo real |
| Velocidad | Milisegundos por accion | Segundos (roundtrip LLM) |
| Determinismo | 100% repetible | No determinista |
| Costo | Gratis, local | Tokens de API por cada paso |
| Para que sirve | Correr tests en CI, dejar corriendo | Explorar, descubrir bugs, generar tests |

**Regla**: MCP para generar y explorar, Playwright Test para ejecutar. Nunca MCP en CI.

---

## Setup inicial en un proyecto

```bash
# Instalar Playwright Test
pnpm create playwright

# Instalar solo Chromium (mas rapido)
pnpm exec playwright install chromium

# Inicializar Test Agents (opcional, para asistencia IA)
pnpm exec playwright init-agents
```

### Estructura de archivos

```
proyecto/
  e2e/                    # o tests/e2e/
    fixtures/             # auth state, datos de prueba
      auth.setup.ts       # login una vez, reutilizar sesion
    helpers/              # utilidades compartidas
      navigation.ts       # funciones de navegacion comunes
    flows/                # tests organizados por flujo
      auth.spec.ts
      clientes.spec.ts
      leads.spec.ts
    playwright.config.ts
```

### Config base (`playwright.config.ts`)

```ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ['list']
  ],
  use: {
    baseURL: process.env.E2E_BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    // Setup: login una vez y guardar estado
    { name: 'setup', testMatch: /.*\.setup\.ts/ },
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'e2e/fixtures/.auth/user.json',
      },
      dependencies: ['setup'],
    },
  ],
  // Levantar el server de dev si no esta corriendo
  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

---

## Reglas criticas (lo que fallo antes y por que)

### 1. NUNCA navegar por URL a rutas internas de SPA

En Next.js App Router, algunas rutas son server-side y otras client-side.
Navegar con `goto()` a una ruta client-side puede dar 404.

```ts
// MAL - puede dar 404 en SPA
await page.goto('/dashboard/causas');

// BIEN - navegar como el usuario
await page.goto('/'); // o la pagina de login
await page.getByRole('link', { name: 'Causas' }).click();
await page.waitForURL('**/causas');
```

**Excepciones**: `goto()` esta bien para:
- La pagina inicial (login, home)
- Rutas que existen como archivos en `app/` (server-side pages)

### 2. Siempre esperar antes de interactuar con elementos async

```ts
// MAL - el modal puede no estar abierto todavia
await page.getByRole('button', { name: 'Nuevo' }).click();
await page.getByLabel('Nombre').fill('Test'); // puede fallar

// BIEN - esperar al dialog
await page.getByRole('button', { name: 'Nuevo' }).click();
await page.getByRole('dialog').waitFor();
await page.getByLabel('Nombre').fill('Test');
```

### 3. Usar locators semanticos, NUNCA selectores CSS

```ts
// MAL - fragil, se rompe con cualquier cambio de clase/estructura
await page.locator('.btn-primary').click();
await page.locator('#name-input').fill('Test');

// BIEN - semantico, resiliente
await page.getByRole('button', { name: 'Guardar' }).click();
await page.getByLabel('Nombre').fill('Test');
await page.getByText('Cliente creado').waitFor();
```

Orden de preferencia:
1. `getByRole()` - el mas robusto
2. `getByLabel()` - para inputs de formulario
3. `getByText()` - para texto visible
4. `getByTestId()` - ultimo recurso, requiere agregar `data-testid` al codigo

### 4. Autenticacion: login UNA vez, reutilizar

```ts
// e2e/fixtures/auth.setup.ts
import { test as setup, expect } from '@playwright/test';

const authFile = 'e2e/fixtures/.auth/user.json';

setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill(process.env.E2E_USER!);
  await page.getByLabel('Password').fill(process.env.E2E_PASS!);
  await page.getByRole('button', { name: /entrar|login|ingresar/i }).click();
  await page.waitForURL('**/dashboard**');
  await page.context().storageState({ path: authFile });
});
```

Agregar al `.gitignore`:
```
e2e/fixtures/.auth/
```

---

## Patrones para componentes shadcn/Radix

### Dialog / Modal

```ts
// Abrir
await page.getByRole('button', { name: 'Nueva Causa' }).click();
await page.getByRole('dialog').waitFor();

// Interactuar dentro del dialog
const dialog = page.getByRole('dialog');
await dialog.getByLabel('Titulo').fill('Causa de prueba');
await dialog.getByRole('button', { name: 'Guardar' }).click();

// Verificar que se cerro
await expect(page.getByRole('dialog')).not.toBeVisible();
```

### Select / Combobox (shadcn)

```ts
// Abrir y seleccionar
await page.getByRole('combobox', { name: 'Estado' }).click();
await page.getByRole('option', { name: 'Activo' }).click();

// Verificar seleccion
await expect(page.getByRole('combobox', { name: 'Estado' })).toHaveText('Activo');
```

### DropdownMenu

```ts
await page.getByRole('button', { name: 'Acciones' }).click();
await page.getByRole('menuitem', { name: 'Editar' }).click();
```

### Tabs

```ts
await page.getByRole('tab', { name: 'Historial' }).click();
await expect(page.getByRole('tabpanel')).toContainText('Ultima actualizacion');
```

### Toast / Notificacion

```ts
// Despues de una accion, esperar el toast
await expect(page.getByText('Cliente creado exitosamente')).toBeVisible();
```

### DataTable con paginacion

```ts
// Verificar que hay datos
await expect(page.getByRole('table')).toBeVisible();
const rows = page.getByRole('row');
await expect(rows).toHaveCount(11); // header + 10 filas

// Navegar a pagina 2
await page.getByRole('button', { name: 'Next' }).click();
```

---

## Patron de test: flujo completo (crear -> modificar -> verificar)

```ts
import { test, expect } from '@playwright/test';

test.describe('Flujo de clientes', () => {
  test('crear cliente, cambiar estado, verificar', async ({ page }) => {
    // 1. Navegar al modulo
    await page.goto('/');
    await page.getByRole('link', { name: 'Clientes' }).click();
    await page.waitForURL('**/clientes');

    // 2. Crear
    await page.getByRole('button', { name: 'Nuevo Cliente' }).click();
    await page.getByRole('dialog').waitFor();

    const dialog = page.getByRole('dialog');
    await dialog.getByLabel('Nombre').fill('Juan Test E2E');
    await dialog.getByLabel('Email').fill('juan@test.com');
    await dialog.getByRole('combobox', { name: 'Tipo' }).click();
    await page.getByRole('option', { name: 'Particular' }).click();
    await dialog.getByRole('button', { name: 'Guardar' }).click();

    // 3. Verificar creacion
    await expect(page.getByText('Cliente creado')).toBeVisible();
    await expect(page.getByText('Juan Test E2E')).toBeVisible();

    // 4. Abrir y modificar
    await page.getByText('Juan Test E2E').click();
    await page.waitForURL('**/clientes/**');
    await page.getByRole('button', { name: 'Cambiar Estado' }).click();
    await page.getByRole('dialog').waitFor();
    await page.getByRole('option', { name: 'Activo' }).click();
    await page.getByRole('button', { name: 'Confirmar' }).click();

    // 5. Verificar cambio
    await expect(page.getByText('Estado actualizado')).toBeVisible();
    await expect(page.getByText('Activo')).toBeVisible();
  });
});
```

---

## Como correr tests

```bash
# Correr todos
pnpm exec playwright test

# Correr un archivo especifico
pnpm exec playwright test e2e/flows/clientes.spec.ts

# Correr con browser visible (debugging)
pnpm exec playwright test --headed

# Correr y abrir reporte HTML al terminar
pnpm exec playwright test --reporter=html

# Ver ultimo reporte
pnpm exec playwright show-report

# Correr en background mientras trabajas en otra cosa
pnpm exec playwright test --reporter=html 2>&1 | tee test-results.log &

# Grabar interacciones para generar codigo base
pnpm exec playwright codegen http://localhost:3000

# Ver trace de un test fallido
pnpm exec playwright show-trace test-results/trace.zip
```

---

## Workflow de desarrollo con IA

### Paso 1: Explorar con Playwright MCP (en Claude Code)
Pedirle a Claude que abra la app y navegue los flujos.
Claude usa las tools `browser_navigate`, `browser_click`, `browser_fill_form`, etc.
Esto sirve para entender la estructura y descubrir edge cases.

### Paso 2: Generar tests deterministas
Pedirle a Claude que escriba archivos `.spec.ts` basados en lo que descubrio.
Los tests deben seguir todas las reglas de esta guia.

### Paso 3: Ejecutar y refinar
Correr `pnpm exec playwright test` en otra terminal.
Si fallan, compartir el error con Claude para que ajuste.

### Paso 4: Healing automatico (opcional)
Si usas Test Agents, el healer puede auto-arreglar selectores rotos.

---

## Variables de entorno para tests

Crear un `.env.test` o `.env.local` con:

```
E2E_BASE_URL=http://localhost:3000
E2E_USER=test@example.com
E2E_PASS=testpassword123
```

**Importante**: usar un usuario de test dedicado, no credenciales reales.

---

## Checklist antes de escribir un test

- [ ] El test navega desde la raiz via clicks, no con goto() a rutas internas
- [ ] Usa locators semanticos (getByRole, getByLabel, getByText)
- [ ] Espera elementos async antes de interactuar (waitFor, waitForURL)
- [ ] Tiene assertions que verifican el resultado esperado
- [ ] No depende de datos especificos que puedan cambiar
- [ ] Limpia lo que crea (o usa datos unicos por corrida, ej: timestamps en nombres)

---

## Herramientas complementarias (opcionales)

| Herramienta | Que hace | Costo |
|---|---|---|
| **Checksum.ai** | Auto-genera tests desde sesiones reales, self-healing | Free tier |
| **Autonoma** | Escanea codebase y genera suite E2E completa | Free tier |
| **Checkly** | Monitoreo 24/7 de flows criticos en produccion | Free 50K runs/mes |

---

## Anti-patrones (NO hacer)

1. **No usar `page.goto()` para rutas internas de SPA** - causa 404s
2. **No usar selectores CSS** (`.class`, `#id`) - se rompen con refactors
3. **No usar `page.waitForTimeout()`** - es un sleep, fragil. Usar `waitFor()` o `waitForURL()`
4. **No correr Playwright MCP en CI** - lento, no determinista, gasta tokens
5. **No hardcodear datos** - usar datos unicos por corrida
6. **No ignorar flaky tests** - investigar y arreglar, no skipear
7. **No testear implementacion** - testear comportamiento del usuario

---

## Validado en proyectos

Errores reales encontrados al generar tests con IA. Cada entrada incluye el proyecto, cuantos tests, y que se descubrio. Usar como guardrails para los proximos.

### ÍTERA Lex (2026-03-25) — 18 tests, 5 archivos

**Puerto alternativo: BetterAuth rechaza origins no configurados**
- Usar un puerto distinto al 3000 (ej: 3015) requiere que BetterAuth lo acepte como origin
- `webServer.env` en playwright.config.ts permite overridear `BETTER_AUTH_URL` y `BETTER_AUTH_TRUSTED_ORIGINS` sin tocar `.env.local`
- Aplica a: cualquier proyecto con BetterAuth que corra tests en puerto dedicado

**Dialogs/modals post-login contaminan el storageState**
- Si la app muestra un dialog al primer login (tour, onboarding, changelog), ese estado se guarda en el `storageState` del auth setup
- Resultado: TODOS los tests posteriores arrancan con el dialog abierto, el overlay intercepta clicks en el sidebar/pagina
- Solucion: en `auth.setup.ts`, cerrar el dialog ANTES de `storageState({ path })` — el state guardado queda limpio
- Patron para cerrar:
  ```ts
  try {
    const dialog = page.getByRole('dialog', { name: /bienvenido/i });
    await dialog.waitFor({ state: 'visible', timeout: 5000 });
    await dialog.getByRole('button', { name: /close/i }).click();
    await dialog.waitFor({ state: 'hidden', timeout: 3000 });
  } catch { /* no aparecio */ }
  ```

**`isVisible()` no acepta timeout — NO sirve para esperar elementos**
- `isVisible()` es un snapshot instantaneo, retorna `true/false` sin esperar
- `isVisible({ timeout: 3000 })` compila pero el timeout NO hace nada — retorna `false` inmediatamente
- Solucion: usar `waitFor({ state: 'visible', timeout })` dentro de try-catch para deteccion condicional
- Aplica a: cualquier patron "si aparece X, hacer Y"

**Sidebar click falla intermitentemente por overlays animados**
- Radix Dialog overlay (`data-state="open"`) con animaciones CSS intercepta pointer events incluso despues de "cerrarse"
- El click en el sidebar se ve como exitoso pero la navegacion no ocurre
- Solucion: despues de cerrar un dialog, esperar `state: 'hidden'` (no solo hacer click en Close)
- Alternativa: para `beforeEach`, usar `goto('/ruta')` directo si la ruta es server-side page (tiene carpeta en `app/`)

**`getByText()` con texto duplicado en la pagina**
- "Tareas por vencer" aparecia 2 veces (widget card title + sidebar stat) → strict mode violation
- Solucion: `.first()` cuando el texto puede repetirse, o locator mas especifico con `.filter()`
- Regla: en dashboards con widgets/cards, asumir que los textos estadisticos se repiten

**`goto('/')` en apps multi-dominio puede ir a la landing, no al dashboard**
- Si el proyecto tiene proxy multi-dominio o route groups `(marketing)` + `(app)`, `/` puede ser la landing publica
- Solucion: usar `goto('/dashboard')` explicitamente para la ruta autenticada

**Helper de navegacion reutilizable ahorra duplicacion**
- Crear `e2e/helpers/navigation.ts` con funciones como `dismissTourIfVisible(page)` y `goToDashboard(page)`
- Importar en cada spec en vez de copiar el try-catch en cada `beforeEach`

---

### Alquimica Hub (2026-03-25) — 14 tests, 3 archivos

**shadcn `CardTitle` no es un heading**
- `getByRole('heading', { name: 'Panel Admin' })` falla porque shadcn `CardTitle` renderiza un `<div>`, no `<h1>`/`<h2>`
- Solucion: usar `getByText('Panel Admin', { exact: true }).first()` o verificar el tag real del componente antes de escribir el locator
- Aplica a: cualquier proyecto con shadcn/ui

**Locators regex ambiguos por textos que se solapan**
- `getByRole('link', { name: /panel/i })` matcheo 2 elementos: "Panel Admin" (logo) y "Panel" (nav button) → strict mode violation
- Solucion: usar `{ name: 'Panel', exact: true }` cuando hay textos que comparten substring
- Regla: siempre verificar si el texto del locator podria matchear mas de un elemento en la pagina

**Tests sin sesion necesitan override explicito del storageState**
- El proyecto de Playwright inyecta `storageState` del auth setup a todos los tests del proyecto `chromium`
- Tests de login o paginas publicas que NO deben tener sesion necesitan: `test.use({ storageState: { cookies: [], origins: [] } })`
- Regla: poner el override en el `describe` block, no en cada test individual

**Windows: `taskkill //F //IM node.exe` mata TODOS los procesos Node**
- Incluyendo otros dev servers, Playwright MCP, y cualquier cosa Node
- Solucion: usar `pnpm exec kill-port <puerto>` para matar solo el proceso en un puerto especifico

**Prisma Client desactualizado con dev server corriendo**
- Si `prisma generate` falla por DLL locked (dev server tiene el archivo abierto), el query engine queda viejo y tira `PrismaClientKnownRequestError` en runtime
- Solucion: matar dev server → `prisma generate` → reiniciar dev server
- Sintoma: queries funcionan desde `node -e` pero fallan en Next.js (usan distinto query engine)
