#!/usr/bin/env bash
# check-scaffold.sh — Verifica que los archivos scaffold del kickstart existan.
# Ejecutar manualmente o como parte de CI.
# Exit code 0 = todo OK, 1 = faltan archivos.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

missing=0
warned=0

check_required() {
  if [ ! -f "$1" ]; then
    echo -e "${RED}FALTA${NC}: $1"
    missing=$((missing + 1))
  fi
}

check_optional() {
  if [ ! -f "$1" ]; then
    echo -e "${YELLOW}SUGERIDO${NC}: $1"
    warned=$((warned + 1))
  fi
}

echo "== Verificando archivos scaffold =="
echo ""

# Archivos siempre requeridos
check_required ".nvmrc"
check_required "Dockerfile"
check_required ".dockerignore"
check_required "src/lib/env.ts"
check_required "src/lib/types/actions.ts"
check_required "src/lib/utils/slugify.ts"
check_required "src/components/shared/EmptyState.tsx"

# Error boundaries y loading (al menos el público)
check_required "src/app/(public)/error.tsx"
check_required "src/app/(public)/loading.tsx"

# Opcionales (si hay admin)
if [ -d "src/app/admin" ]; then
  check_optional "src/app/admin/(protected)/error.tsx"
  check_optional "src/app/admin/(protected)/loading.tsx"
fi

# Si hay auth module
if [ -f "src/lib/auth.ts" ]; then
  check_optional "src/lib/auth-action.ts"
fi

echo ""
if [ $missing -gt 0 ]; then
  echo -e "${RED}$missing archivo(s) requerido(s) faltante(s).${NC}"
  exit 1
elif [ $warned -gt 0 ]; then
  echo -e "${YELLOW}$warned archivo(s) sugerido(s) faltante(s).${NC}"
  exit 0
else
  echo -e "${GREEN}Todos los archivos scaffold presentes.${NC}"
  exit 0
fi
