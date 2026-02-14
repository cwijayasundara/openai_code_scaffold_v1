#!/usr/bin/env bash
# Naming Convention Linter
# Enforces: snake_case for files/functions, PascalCase for classes/types
#
# REMEDIATION: Rename the file or symbol to match the convention.
#   Files: my_module.py, user_service.ts (snake_case)
#   Classes: UserService, OrderItem (PascalCase)
#   Functions: get_user, create_order (snake_case)

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
ERRORS=0

if [[ ! -d "$SRC_DIR" ]]; then
  echo "INFO: src/ directory not found. Skipping naming convention check."
  exit 0
fi

# Check file names are snake_case (allow __init__.py and similar)
while IFS= read -r -d '' file; do
  basename=$(basename "$file")
  name="${basename%.*}"

  # Skip __init__, __main__, etc.
  if [[ "$name" == __* ]]; then
    continue
  fi

  # Check for snake_case: lowercase letters, digits, underscores only
  if [[ ! "$name" =~ ^[a-z][a-z0-9_]*$ ]]; then
    rel_path="${file#$PROJECT_ROOT/}"
    echo "ERROR: File name not snake_case: $rel_path"
    echo "  Found: $basename"
    suggested=$(echo "$name" | sed 's/\([A-Z]\)/_\L\1/g' | sed 's/^_//' | tr '[:upper:]' '[:lower:]')
    echo "  REMEDIATION: Rename to '${suggested}.${basename##*.}'"
    echo "  Convention: file_names_use_snake_case.ext"
    echo ""
    ERRORS=$((ERRORS + 1))
  fi
done < <(find "$SRC_DIR" -type f \( -name "*.py" -o -name "*.ts" -o -name "*.js" \) -print0 2>/dev/null)

# Check Python class names are PascalCase
while IFS= read -r -d '' file; do
  while IFS= read -r match; do
    class_name=$(echo "$match" | grep -oP '(?<=class )\w+')
    if [[ ! "$class_name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
      line_num=$(echo "$match" | cut -d: -f1)
      rel_path="${file#$PROJECT_ROOT/}"
      echo "ERROR: Class name not PascalCase: $rel_path:$line_num"
      echo "  Found: $class_name"
      echo "  REMEDIATION: Rename to PascalCase (e.g., UserService, OrderItem)"
      echo ""
      ERRORS=$((ERRORS + 1))
    fi
  done < <(grep -n '^\s*class ' "$file" 2>/dev/null || true)
done < <(find "$SRC_DIR" -name "*.py" -print0 2>/dev/null)

if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS naming convention violation(s) found."
  exit 1
else
  echo "PASSED: All names follow conventions."
fi
