#!/usr/bin/env bash
# check-page-metadata.sh — Verifica que las pages tengan metadata o generateMetadata.
# Exit code 0 = todo OK, 1 = faltan.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Buscar page.tsx en app (excluyendo api/)
files=$(find src/app -name "page.tsx" -not -path "*/api/*" 2>/dev/null || true)

if [ -z "$files" ]; then
  echo -e "${GREEN}No se encontraron pages.${NC}"
  exit 0
fi

violations=0

for file in $files; do
  if ! grep -q "export const metadata\|export async function generateMetadata\|export function generateMetadata" "$file"; then
    # Excluir pages de admin que no necesitan metadata pública
    # Cubre route groups: (protected), (admin), y login
    if echo "$file" | grep -q "(protected)\|(admin)\|admin/login"; then
      echo -e "${YELLOW}SIN METADATA (admin, OK)${NC}: $file"
    else
      echo -e "${RED}SIN METADATA${NC}: $file"
      violations=$((violations + 1))
    fi
  fi
done

echo ""
if [ $violations -gt 0 ]; then
  echo -e "${RED}$violations page(s) pública(s) sin metadata.${NC}"
  exit 1
else
  echo -e "${GREEN}Todas las pages públicas tienen metadata.${NC}"
  exit 0
fi
