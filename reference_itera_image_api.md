# Itera Estudio — API de Generación de Imágenes

Servicio interno de ITERA. Usa Gemini para generar imágenes. Hosted en app.iteraestudio.com.

**Endpoint:** `POST https://app.iteraestudio.com/api/v1/generate`

**Auth:** Bearer token — env var `ITERA_API_KEY` (agregar a `.env.local` del proyecto que la use).

**Rate limit:** 10 req/min

---

## Parámetros (JSON body)

| Parámetro | Tipo | Requerido | Descripción |
|---|---|---|---|
| `prompt` | string (max 2000) | Si* | Descripción de la imagen |
| `aspectRatio` | enum | No | `"1:1"` (default), `"3:4"`, `"4:3"`, `"9:16"`, `"16:9"` |
| `negativePrompt` | string (max 2000) | No | Qué evitar en la generación |
| `referenceImages` | array (max 4) | No | `[{ "data": "<base64>", "mimeType": "image/jpeg" }]` — max 12MB por imagen |
| `referenceMode` | enum | No | `"edit"`, `"inspiration"`, `"combine"` — cómo usar las referencias |
| `modeOptions` | object | No | Modo de generación + opciones (ver abajo) |
| `customColors` | array (max 3) | No | Hex colors: `["#FF0000", "#00FF00"]` |
| `save` | boolean | No | `true` para guardar en galería de Itera Estudio |

*Se requiere `prompt` o `referenceImages` (al menos uno).

---

## Modos de generación (`modeOptions`)

### General (default — sin `modeOptions`)

Sin parámetro `modeOptions`, Gemini decide el formato de salida (generalmente JPEG o WEBP).
Ideal para fotos de producto, banners, heroes de páginas.

```json
{
  "prompt": "...",
  "aspectRatio": "16:9"
}
```

---

### Asset PNG — fondo transparente ⭐ MÁS USADO

**Para logos, íconos, assets y cualquier imagen con canal alfa.**

Flujo interno: Gemini genera con fondo verde → Sharp hace chromakey → sube a R2 como PNG con transparencia. La respuesta tendrá `"mimeType": "image/png"`.

```json
{
  "prompt": "minimalist coffee cup logo, clean lines",
  "modeOptions": {
    "mode": "asset-png",
    "options": {
      "assetType": "element",
      "intent": "create",
      "outputStyle": "flat"
    }
  },
  "negativePrompt": "text, letters, background, shadows"
}
```

**Parámetros de `asset-png`:**

| Campo | Tipo | Opciones |
|---|---|---|
| `assetType` | string (requerido) | `element`, `ornament`, `render` |
| `intent` | string (opcional) | `cutout`, `restyle`, `create` |
| `outputStyle` | string (opcional) | `photorealistic`, `illustration`, `3d-render`, `flat` |

**Recomendaciones para logos:**
- `assetType: "render"` + `outputStyle: "flat"` → limpio, aspecto vectorial (ideal para logos de negocio)
- `assetType: "element"` + `outputStyle: "illustration"` → más orgánico/artístico
- `assetType: "element"` + `outputStyle: "3d-render"` → logos con volumen
- Siempre agregar `"background, shadows"` en `negativePrompt` para mejor recorte del chromakey

---

### Icons

```json
{
  "modeOptions": {
    "mode": "icons",
    "options": {
      "iconStyle": "line-art",
      "colorScheme": "monochrome"
    }
  }
}
```

| Campo | Opciones |
|---|---|
| `iconStyle` | `line-art`, `flat`, `3d`, `filled` |
| `colorScheme` | `monochrome`, `vibrant`, `pastel`, `duotone` |

---

### Product Photo

```json
{
  "modeOptions": {
    "mode": "product-photo",
    "options": {
      "angle": "front",
      "background": "white"
    }
  }
}
```

| Campo | Opciones |
|---|---|
| `angle` | `front`, `45deg`, `top-down` |
| `background` | `white`, `neutral-gray`, `gradient` |

---

### Social Banner

```json
{
  "modeOptions": {
    "mode": "social-banner",
    "options": {
      "platform": "instagram-post",
      "overlayText": "Texto sobre la imagen",
      "style": "minimal",
      "tone": "professional"
    }
  }
}
```

| Campo | Opciones |
|---|---|
| `platform` | `youtube`, `instagram-post`, `instagram-story`, `linkedin`, `twitter`, `facebook` |
| `overlayText` | string (max 80 chars) |
| `style` | `photorealistic`, `illustration`, `minimal`, `typographic` |
| `tone` | `vibrant`, `professional`, `dark`, `light` |

---

### Pattern / Texture

```json
{
  "modeOptions": {
    "mode": "pattern-texture",
    "options": {
      "patternType": "geometric",
      "colorPalette": "monochrome",
      "density": "medium"
    }
  }
}
```

| Campo | Opciones |
|---|---|
| `patternType` | `geometric`, `organic`, `floral`, `abstract`, `lines`, `dots` |
| `colorPalette` | `monochrome`, `colorful`, `pastel`, `dark`, `earthy` |
| `density` | `sparse`, `medium`, `dense` |

---

### Mockup

```json
{
  "modeOptions": {
    "mode": "mockup",
    "options": {
      "deviceType": "laptop",
      "context": "desk"
    }
  }
}
```

| Campo | Opciones |
|---|---|
| `deviceType` | `laptop`, `smartphone`, `tablet`, `monitor`, `browser`, `poster` |
| `context` | `studio`, `hand`, `desk`, `lifestyle`, `minimal` |

---

## Respuesta exitosa

```json
{
  "url": "https://pub-b001cc284fef4344bebb75d11c802241.r2.dev/generated/...",
  "prompt": "...",
  "finalPrompt": "...",
  "seed": 12345,
  "aspectRatio": "1:1",
  "mimeType": "image/png",
  "saved": false,
  "id": null
}
```

La URL es pública (R2 de Itera Studio). Para usar la imagen: `curl -sL <url> -o public/images/nombre.png`

---

## Ejemplos completos (curl)

**Logo con fondo transparente:**
```bash
curl -s -X POST https://app.iteraestudio.com/api/v1/generate \
  -H "Authorization: Bearer $ITERA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "minimalist crossfit gym logo, bold typography",
    "modeOptions": { "mode": "asset-png", "options": { "assetType": "render", "intent": "create", "outputStyle": "flat" } },
    "negativePrompt": "background, shadows, gradients"
  }'
```

**Hero 16:9 para web:**
```bash
curl -s -X POST https://app.iteraestudio.com/api/v1/generate \
  -H "Authorization: Bearer $ITERA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "modern law firm office, natural light, editorial photography",
    "aspectRatio": "16:9",
    "negativePrompt": "text, letters, logos, watermarks, people"
  }'
```

**Icon set monocromático:**
```bash
curl -s -X POST https://app.iteraestudio.com/api/v1/generate \
  -H "Authorization: Bearer $ITERA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "settings gear icon",
    "modeOptions": { "mode": "icons", "options": { "iconStyle": "line-art", "colorScheme": "monochrome" } }
  }'
```

---

## Tips generales

- **Prompts en inglés** → mejor resultado (Gemini)
- **Asset PNG**: SIEMPRE agregar `"background, shadows"` en `negativePrompt` para mejor chromakey
- **Heroes**: `aspectRatio: "16:9"`, evitar texto con `negativePrompt`
- **Sin `modeOptions`** → JPEG/WEBP (fotos, banners) — **Con `asset-png`** → PNG transparente (logos, íconos)
- Si falla, reintentar con prompt más corto/simple (el modelo a veces rechaza prompts complejos)
