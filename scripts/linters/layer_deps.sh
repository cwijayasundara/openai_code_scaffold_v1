#!/usr/bin/env bash
# Layer Dependency Linter
# Enforces: Types → Config → Repo → Service → Runtime → UI
# Code may only import from layers earlier in the chain.
#
# REMEDIATION: If this linter fails, move the import to the correct layer
# or restructure the dependency so it flows forward (left to right).

set -eo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"

# Layer order: rank by position (0=types, 1=config, 2=repo, 3=service, 4=runtime, 5=ui)
LAYERS="types config repo service runtime ui"
ERRORS=0

get_rank() {
  local target="$1"
  local rank=0
  for layer in $LAYERS; do
    if [[ "$layer" == "$target" ]]; then
      echo "$rank"
      return
    fi
    rank=$((rank + 1))
  done
  echo "-1"
}

get_allowed() {
  local max_rank="$1"
  local rank=0
  local allowed=""
  for layer in $LAYERS; do
    if [[ $rank -le $max_rank ]]; then
      allowed="$allowed $layer"
    fi
    rank=$((rank + 1))
  done
  echo "$allowed"
}

check_file() {
  local file="$1"
  local rel_path="${file#$SRC_DIR/}"
  local file_layer=""

  # Determine which layer this file belongs to
  for layer in $LAYERS; do
    if [[ "$rel_path" == "$layer/"* ]]; then
      file_layer="$layer"
      break
    fi
  done

  if [[ -z "$file_layer" ]]; then
    return  # File not in a recognized layer
  fi

  local file_rank
  file_rank=$(get_rank "$file_layer")

  # Check imports (Python-style: from src.X or import src.X)
  while IFS= read -r line; do
    for target_layer in $LAYERS; do
      local target_rank
      target_rank=$(get_rank "$target_layer")
      if [[ $target_rank -gt $file_rank ]]; then
        if echo "$line" | grep -qE "(from|import).*${target_layer}"; then
          local allowed
          allowed=$(get_allowed "$file_rank")
          echo "ERROR: Layer violation in $rel_path"
          echo "  '$file_layer' (rank $file_rank) imports from '$target_layer' (rank $target_rank)"
          echo "  Line: $line"
          echo "  REMEDIATION: Move this dependency to a lower layer, or restructure"
          echo "  so that '$file_layer' does not depend on '$target_layer'."
          echo "  Allowed imports for '$file_layer':$allowed"
          echo ""
          ERRORS=$((ERRORS + 1))
        fi
      fi
    done
  done < <(grep -nE '^\s*(from|import)\s' "$file" 2>/dev/null || true)
}

if [[ ! -d "$SRC_DIR" ]]; then
  echo "INFO: src/ directory not found. Skipping layer dependency check."
  exit 0
fi

# Find all source files
while IFS= read -r -d '' file; do
  check_file "$file"
done < <(find "$SRC_DIR" -type f \( -name "*.py" -o -name "*.ts" -o -name "*.js" \) -print0 2>/dev/null)

if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS layer dependency violation(s) found."
  echo "Layer order: Types → Config → Repo → Service → Runtime → UI"
  echo "Each layer may only import from layers to its LEFT."
  exit 1
else
  echo "PASSED: All layer dependencies are valid."
fi
