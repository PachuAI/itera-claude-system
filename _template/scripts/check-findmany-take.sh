#!/usr/bin/env bash
# check-findmany-take.sh — Detecta findMany sin take en el código.
# Busca llamadas a .findMany( que no tengan `take` en el objeto de argumentos.
# Exit code 0 = todo OK, 1 = hay findMany sin take.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Buscar archivos .ts/.tsx con findMany (excluyendo node_modules, generated, .next)
files=$(grep -rl "\.findMany(" src/ --include="*.ts" --include="*.tsx" 2>/dev/null | grep -v "src/generated/" | grep -v "src/lib/generated/" || true)

if [ -z "$files" ]; then
  echo -e "${GREEN}No se encontraron llamadas a findMany.${NC}"
  exit 0
fi

violations=0

for file in $files; do
  # Buscar findMany que NO tenga take en las siguientes 20 líneas
  # (queries con includes/selects largos necesitan ventana más amplia)
  line_numbers=$(grep -n "\.findMany(" "$file" | cut -d: -f1)

  for line_num in $line_numbers; do
    # Leer las siguientes 20 líneas después del findMany
    block=$(sed -n "${line_num},$((line_num + 20))p" "$file")

    if ! echo "$block" | grep -q "take"; then
      echo -e "${RED}SIN TAKE${NC}: $file:$line_num"
      violations=$((violations + 1))
    fi
  done
done

echo ""
if [ $violations -gt 0 ]; then
  echo -e "${RED}$violations findMany sin take encontrado(s).${NC}"
  echo "Agregar 'take: N' con un límite razonable (50-5000 según el caso)."
  exit 1
else
  echo -e "${GREEN}Todos los findMany tienen take.${NC}"
  exit 0
fi
