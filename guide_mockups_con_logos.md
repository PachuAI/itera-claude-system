# Guia - Mockups y asset sheets con logos + tipografias

Tecnica para armar brand sheets y asset sheets (favicons, OG, social, banners, hero) usando HTML + CSS con ratios exactos, tipografias de Google Fonts y el logo como PNG transparente. Pensado para replicar dentro de Itera Studio via prompt -> HTML -> rasterizar con Puppeteer/Playwright a PNG.

**Caso de uso validado**: shope.ar (2026-04-14). Brand sheet + asset sheet con ~30 formatos diferentes en una sola sesion.

---

## 0. Flujo general

1. **Generar el logo** con ITERA API (`reference_itera_image_api.md`). Usar modo `icons` + `iconStyle: "filled"` + `colorScheme: "monochrome"` para silueta solida. Volvera JPG con fondo blanco.
2. **Procesar a PNG transparente** con Sharp (threshold de luminancia + anti-aliasing suave, ver script al final).
3. **Exportar a todos los tamaños** (16, 32, 48, 64, 96, 128, 192, 256, 512, 1024) con `trim() + resize({ fit: "contain" })` y padding uniforme del 8%.
4. **Elegir tipografia** probando 3-4 candidatas en paralelo con Google Fonts CDN. Display (wordmark) + UI (body) son decisiones separadas.
5. **Armar asset sheet** con artboards de `aspect-ratio` CSS y componentes reutilizables.

---

## 1. Tipografias - criterios de seleccion

### Ejes para elegir display
- **Redondez**: Fredoka, Baloo 2, Nunito > Poppins, Outfit, DM Sans
- **Peso/Gordura**: Nunito 900, Baloo 2 800, Chewy, Sniglet 800 > Quicksand, Comfortaa
- **Single-story "a"** (la "o con patita", tipo 9 al reves): Sniglet, Comfortaa, DynaPuff, Chewy | NO: Fredoka, Baloo, Nunito, Poppins
- **Familiar/playful**: Chewy, DynaPuff, Sniglet, Baloo 2 > Nunito, Poppins

### Ejes para elegir UI/body
- Legibilidad en 14-16px
- Rango de weights (necesitas minimo 400, 500, 600)
- Consistencia con el display (mismo "mood")
- Soporte completo de acentos hispanicos

### Combinaciones probadas y validadas

| Display | UI | Tono | Uso |
|---|---|---|---|
| Baloo 2 700 | Comfortaa | friendly, latam, emprendedor | shope.ar |
| Fredoka 600 | Inter / DM Sans | playful, tech startup | SaaS LATAM |
| Nunito 900 | Nunito 400/500 | bold, corporativo | enterprise |
| DynaPuff 500 | Comfortaa | juguetona, inflada | brand kids/fun |

### Trade-off tipico: Baloo 2 vs Nunito
- **Baloo 2** = curvas mas organicas, nudos circulares, "hola vecino". Mantiene contrachapas abiertos a 16px.
- **Nunito 900** = mas estructurada, trazos verticales, "somos SaaS". En 900 los contrachapas se empastan a tamaño chico.
- **Con logo denso/chunky** -> Baloo gana por no competir visualmente. Nunito 900 pelea con la silueta.

---

## 2. Patron de artboard - ratios exactos en HTML

Cada "asset" es un `<div>` con `aspect-ratio` CSS y contenido dentro. Responsive pero mantiene la proporcion real.

```html
<div class="artboard ar-16x9 th-white">
  <div class="ab-inner stack">
    <div class="lockup"><img src="logo.png"><span class="word">marca</span></div>
    <div class="pl">punchline <span class="hl">destacado.</span></div>
    <div class="sub">tagline secundario</div>
  </div>
</div>
```

```css
.artboard { position: relative; width: 100%; overflow: hidden; display: flex; }
.ar-1x1    { aspect-ratio: 1 / 1; }        /* IG feed, avatar, icons */
.ar-4x5    { aspect-ratio: 4 / 5; }        /* IG portrait */
.ar-16x9   { aspect-ratio: 16 / 9; }       /* hero, Twitter card, YT */
.ar-9x16   { aspect-ratio: 9 / 16; }       /* IG story, reel */
.ar-1.91x1 { aspect-ratio: 1.91 / 1; }     /* OG / Facebook preview */
.ar-3x1    { aspect-ratio: 3 / 1; }        /* Twitter header */
.ar-4x1    { aspect-ratio: 4 / 1; }        /* LinkedIn banner */
```

**Clave**: el contenido interno usa `vw` o `clamp()` para escalar con el artboard, no con la viewport real. Asi a cualquier tamaño de preview mantiene las proporciones internas.

```css
.word { font-size: clamp(18px, 14vw, 180px); }
.pl   { font-size: 6vw; }
```

---

## 3. Themes (fondos) reutilizables

```css
.th-white { background: #fff; color: #111; }
.th-black { background: #000; color: #fff; }
.th-cream { background: #f7f3ec; color: #111; }
.th-navy  { background: #0f172a; color: #fff; }
.th-wa    { background: #25d366; color: #073019; }
.th-slate { background: #1f2937; color: #fff; }
.th-gradient { background: linear-gradient(135deg, #25d366, #128c7e); color: #fff; }
```

Cada artboard cambia solo de theme para generar N variantes sin duplicar HTML.

---

## 4. Componentes reutilizables

### Lockup (icono + wordmark)
```css
.lockup { display: inline-flex; align-items: center; gap: 4%; }
.lockup img { width: 22%; height: auto; }
.lockup .word {
  font-family: var(--display);
  font-weight: 700;
  line-height: 1;
  letter-spacing: -0.02em;
}
.lockup.sm img { width: 14%; }
.lockup.lg img { width: 30%; }
```

### Punchline
```css
.pl { font-family: var(--display); font-weight: 600; line-height: 1.05; letter-spacing: -0.03em; }
.pl .hl { font-weight: 800; } /* palabra destacada */
```

### Chip / CTA
```css
.chip {
  display: inline-block;
  font-family: var(--ui); font-weight: 500;
  font-size: clamp(10px, 1.1vw, 13px);
  padding: .4em 1em; border-radius: 999px;
  background: rgba(0,0,0,.08);
}
.th-dark .chip { background: rgba(255,255,255,.18); }
```

### Inner layouts
```css
.ab-inner { padding: 6%; width: 100%; height: 100%; display: flex; flex-direction: column; }
.ab-inner.center { align-items: center; justify-content: center; text-align: center; }
.ab-inner.stack  { justify-content: space-between; }
```

---

## 5. Checklist de formatos estandar

Para una sheet completa de marca web:

### Favicons / iconos
- [ ] `favicon.ico` multi-size (16, 32, 48)
- [ ] `icon.png` 512 maskable (PWA)
- [ ] `apple-icon.png` 180x180
- [ ] Android: 192, 512 para manifest

### Social preview
- [ ] OG image 1200x630 (ratio 1.91:1) - light, dark, brand
- [ ] Twitter card 1200x675 (16:9)
- [ ] LinkedIn preview = OG

### Contenido social
- [ ] IG feed 1080x1080 (1:1)
- [ ] IG portrait 1080x1350 (4:5)
- [ ] IG story / reel cover 1080x1920 (9:16)

### Banners / portadas
- [ ] LinkedIn banner 1584x396 (4:1)
- [ ] Twitter header 1500x500 (3:1)
- [ ] YouTube cover 2560x1440 (16:9)
- [ ] Hero web 16:9

### Lockups
- [ ] Horizontal (icono + wordmark) en light / dark / color
- [ ] Vertical (icono arriba, wordmark abajo)
- [ ] Icono solo

---

## 6. Pipeline con ITERA API

### Paso 1: generar logo
```bash
curl -s -X POST https://app.iteraestudio.com/api/v1/generate \
  -H "Authorization: Bearer $ITERA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Pictogram icon, solid filled silhouette of a person sitting leaned back in an armchair, side view, holding a smartphone with one hand",
    "modeOptions": {
      "mode": "icons",
      "options": { "iconStyle": "filled", "colorScheme": "monochrome" }
    },
    "negativePrompt": "background, shadows, line art, outlines only, 3D, depth, face features, multiple subjects"
  }'
```

**Tips**:
- Tirar 3 variaciones en paralelo (el modelo es inconsistente).
- El modo `icons` devuelve JPG con fondo blanco. El modo `asset-png` + `assetType: "render"` agrega prefix "3D-style" al prompt y suele dar volumen 3D (bueno para 3D, malo para flat).
- `assetType: "element"` + `outputStyle: "flat"` en imagenes de personas tiende a dar line-art finito, no silueta solida.

### Paso 2: procesar a PNG transparente

Script `process-logo.mjs` con Sharp. Threshold de luminancia con curva suave para anti-aliasing.

```js
import sharp from "sharp";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const DIR = dirname(fileURLToPath(import.meta.url));
const TARGETS = process.argv.slice(2);

async function buildMasks(name) {
  const { data, info } = await sharp(join(DIR, `${name}.png`))
    .ensureAlpha().raw().toBuffer({ resolveWithObject: true });
  const { width, height } = info;

  const black = Buffer.alloc(width * height * 4);
  const white = Buffer.alloc(width * height * 4);

  for (let i = 0; i < data.length; i += 4) {
    const lum = 0.2126 * data[i] + 0.7152 * data[i+1] + 0.0722 * data[i+2];
    // curva suave: >220 lum -> transparente, <60 -> opaco, entre medio interpolacion
    let alpha;
    if (lum >= 220) alpha = 0;
    else if (lum <= 60) alpha = 255;
    else alpha = Math.round(((220 - lum) / (220 - 60)) * 255);

    black[i]=0; black[i+1]=0; black[i+2]=0; black[i+3]=alpha;
    white[i]=255; white[i+1]=255; white[i+2]=255; white[i+3]=alpha;
  }

  await sharp(black, { raw: { width, height, channels: 4 } })
    .png().toFile(join(DIR, `${name}-black.png`));
  await sharp(white, { raw: { width, height, channels: 4 } })
    .png().toFile(join(DIR, `${name}-white.png`));

  // exports en tamaños estandar con padding 8%
  for (const variant of ["black", "white"]) {
    for (const size of [16, 32, 48, 64, 96, 128, 192, 256, 512, 1024]) {
      const pad = Math.round(size * 0.08);
      await sharp(join(DIR, `${name}-${variant}.png`))
        .trim({ threshold: 1 })
        .resize(size - pad*2, size - pad*2, { fit: "contain", background: { r:0, g:0, b:0, alpha:0 } })
        .extend({ top:pad, bottom:pad, left:pad, right:pad, background: { r:0, g:0, b:0, alpha:0 } })
        .png().toFile(join(DIR, `final/${name}-${variant}-${size}.png`));
    }
  }
}

for (const t of TARGETS) await buildMasks(t);
```

### Paso 3: asset sheet

HTML con todos los formatos, cada uno en un `.tile` con `.label` + `.preview.artboard` + `.note`.

---

## 7. Rasterizar HTML -> PNG

Para exportar cada artboard como PNG listo para usar (no solo preview web):

### Opcion A: Playwright (recomendado)
```js
import { chromium } from "playwright";
const browser = await chromium.launch();
const page = await browser.newPage();
await page.goto("file://" + __dirname + "/assets.html");
await page.waitForFunction(() => document.fonts.ready);

const tiles = await page.$$(".artboard");
for (const [i, tile] of tiles.entries()) {
  await tile.screenshot({ path: `out/asset-${i}.png`, omitBackground: false });
}
```

### Opcion B: Puppeteer con device scale
```js
await page.setViewportSize({ width: 1200, height: 630, deviceScaleFactor: 2 });
```

**Tips**:
- Esperar `document.fonts.ready` para que Google Fonts cargue antes del screenshot
- `deviceScaleFactor: 2` para retina/print quality
- Para OG exacto: ratio 1200x630, pasa `clip: { x, y, width: 1200, height: 630 }`

---

## 8. Guardrails

### Tamaño y legibilidad
- **Favicon 16px**: silueta debe ser reconocible a esa escala. Probar siempre en 16 y 32 antes de aprobar.
- **OG 1200x630**: el texto principal NO debe ocupar mas del 60% del ancho. Dejar padding generoso.
- **Story 9:16**: los primeros 250px verticales los tapan los controles de IG. Dejar esa zona libre.

### Tipografia
- **Display en 900/800**: verificar a 16-20px que no se empaste. Si se empasta, bajar a 700.
- **Mix display+UI**: NUNCA mezclar dos fuentes display. Siempre display para wordmark/headings + UI sans para body/botones.
- **Single-story "a"**: Comfortaa / Sniglet / Quicksand. Double-story: Baloo / Nunito / Fredoka / Inter.

### Pipeline API
- Generar 3 variaciones en paralelo por iteracion. El modelo es inconsistente dentro del mismo prompt.
- Procesar JPGs a PNG transparente siempre via luminance threshold, NUNCA alpha por keyer de color porque el logo puede tener sombras interiores.
- Guardar el `finalPrompt` del response para entender que modifico el backend (prefix "3D-style", "single element", etc.)

### Aspect ratios estandar 2026
| Plataforma | Formato | Ratio | Pixels |
|---|---|---|---|
| Favicon | multi | 1:1 | 16 / 32 / 48 |
| Apple touch | icon | 1:1 | 180 |
| Android / PWA | icon | 1:1 | 192 / 512 |
| OG / FB / LinkedIn preview | landscape | 1.91:1 | 1200x630 |
| Twitter card | landscape | 16:9 | 1200x675 |
| IG feed square | square | 1:1 | 1080x1080 |
| IG feed portrait | portrait | 4:5 | 1080x1350 |
| IG story / reel cover | portrait | 9:16 | 1080x1920 |
| LinkedIn banner | landscape | 4:1 | 1584x396 |
| Twitter header | landscape | 3:1 | 1500x500 |
| YouTube cover | landscape | 16:9 | 2560x1440 |
| Hero web | landscape | 16:9 | 1920x1080 |

---

## 9. Workflow para replicar en Itera Studio

1. Usuario pide: "brand para [cliente], nicho [X], mood [Y]"
2. Itera genera 3 variaciones de logo con prompt + modo `icons/filled/monochrome`
3. Usuario elige una -> procesamos a masters PNG transparentes
4. Itera genera preview de 3-4 tipografias -> usuario elige display + UI
5. Itera genera asset sheet HTML usando templates de este doc + logo + tipografia elegidas
6. Preview navegable para el usuario. Al aprobar, Playwright rasteriza cada artboard a PNG final
7. Entrega ZIP con toda la sheet + masters

El template de asset sheet es basicamente estatico: cambian las variables CSS (`--display`, `--ui`, `--ink`, `--brand`) y las URLs de los logos. Todo lo demas (artboards, themes, layouts) es reutilizable.

---

## Referencia cruzada
- API de imagenes: `reference_itera_image_api.md`
- Generacion de assets tecnicos (favicon.ico multi-size, manifest.json): ver `next/app/icon.tsx` docs Next.js 16
