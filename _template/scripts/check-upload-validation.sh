#!/usr/bin/env bash
# check-upload-validation.sh — Verifica que las rutas de upload validen MIME y tamaño.
# Exit code 0 = todo OK, 1 = falta validación.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Buscar archivos de upload routes
files=$(grep -rl "formData\|\.get('file')\|\.get(\"file\")" src/app/api/ --include="*.ts" 2>/dev/null || true)

if [ -z "$files" ]; then
  echo -e "${GREEN}No se encontraron rutas de upload.${NC}"
  exit 0
fi

violations=0

for file in $files; do
  # Verificar que el archivo tenga validación de MIME
  if ! grep -q "file\.type\|ALLOWED_MIME\|mime" "$file"; then
    echo -e "${RED}SIN VALIDACION MIME${NC}: $file"
    violations=$((violations + 1))
  fi

  # Verificar que el archivo tenga validación de tamaño
  if ! grep -q "file\.size\|MAX_FILE_SIZE\|maxSize" "$file"; then
    echo -e "${RED}SIN VALIDACION TAMANO${NC}: $file"
    violations=$((violations + 1))
  fi
done

echo ""
if [ $violations -gt 0 ]; then
  echo -e "${RED}$violations problema(s) de validación en upload routes.${NC}"
  exit 1
else
  echo -e "${GREEN}Upload routes validadas correctamente.${NC}"
  exit 0
fi
