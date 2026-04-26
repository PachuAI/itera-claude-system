#!/usr/bin/env bash
# cf-purge.sh — Purgar cache de Cloudflare por dominio.
#
# Requiere CLOUDFLARE_API_TOKEN en env (o ~/.config/cloudflare/token en disco).
# El token necesita permisos: Zone | Cache Purge | Purge + Zone | Zone | Read.
#
# Uso:
#   cf-purge.sh <dominio>                # purga todo el cache de la zona
#   cf-purge.sh <dominio> <url1> [url2]  # purga URLs especificas (max 30)
#
# Ejemplos:
#   cf-purge.sh pachu.dev
#   cf-purge.sh itera.lat https://itera.lat/style.css https://itera.lat/index.html

set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
TOKEN_FILE="${HOME}/.config/cloudflare/token"
TOKEN="${CLOUDFLARE_API_TOKEN:-}"

if [[ -z "$TOKEN" ]] && [[ -f "$TOKEN_FILE" ]]; then
  TOKEN="$(cat "$TOKEN_FILE")"
fi

if [[ -z "$TOKEN" ]]; then
  echo "ERROR: token no encontrado. Setea CLOUDFLARE_API_TOKEN o pone el token en $TOKEN_FILE" >&2
  exit 1
fi

# ── Args ──────────────────────────────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
  echo "Uso: cf-purge.sh <dominio> [url1 url2 ...]" >&2
  exit 1
fi

DOMAIN="$1"; shift
URLS=("$@")

# ── Resolver zone_id ──────────────────────────────────────────────────────────
ZONE_ID="$(curl -sS \
  -H "Authorization: Bearer $TOKEN" \
  "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}" \
  | jq -r '.result[0].id // empty')"

if [[ -z "$ZONE_ID" ]]; then
  echo "ERROR: no se encontro zona para dominio '$DOMAIN'" >&2
  exit 1
fi

# ── Build payload ─────────────────────────────────────────────────────────────
if [[ ${#URLS[@]} -eq 0 ]]; then
  echo "purgando TODO el cache de $DOMAIN (zone $ZONE_ID)..."
  PAYLOAD='{"purge_everything":true}'
else
  echo "purgando ${#URLS[@]} URL(s) de $DOMAIN (zone $ZONE_ID)..."
  PAYLOAD="$(jq -n --argjson urls "$(printf '%s\n' "${URLS[@]}" | jq -R . | jq -s .)" '{files: $urls}')"
fi

# ── Ejecutar ──────────────────────────────────────────────────────────────────
RESPONSE="$(curl -sS -X POST \
  "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/purge_cache" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data "$PAYLOAD")"

SUCCESS="$(echo "$RESPONSE" | jq -r '.success')"
if [[ "$SUCCESS" != "true" ]]; then
  echo "ERROR de Cloudflare:" >&2
  echo "$RESPONSE" | jq . >&2
  exit 1
fi

echo "OK — cache purgado en $DOMAIN"
