#!/usr/bin/env bash
# check-auth-guards.sh — Verifica que las API routes admin tengan guard de auth.
# Exit code 0 = todo OK, 1 = falta auth.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Buscar API routes en admin
files=$(find src/app/api/admin -name "route.ts" 2>/dev/null || true)

if [ -z "$files" ]; then
  echo -e "${GREEN}No se encontraron API routes admin.${NC}"
  exit 0
fi

violations=0

for file in $files; do
  if ! grep -q "auth()\|requireAuth\|requireApiAccess\|getSession" "$file"; then
    echo -e "${RED}SIN AUTH GUARD${NC}: $file"
    violations=$((violations + 1))
  fi
done

echo ""
if [ $violations -gt 0 ]; then
  echo -e "${RED}$violations API route(s) admin sin guard de autenticación.${NC}"
  exit 1
else
  echo -e "${GREEN}Todas las API routes admin tienen auth guard.${NC}"
  exit 0
fi
