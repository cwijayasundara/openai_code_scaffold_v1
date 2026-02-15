#!/usr/bin/env bash
# Spec Coverage Linter
# Enforces: Every service module must trace to a spec file.
#
# REMEDIATION: Add "# Spec: specs/features/<name>.md" in the first 5 lines.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
SPECS_DIR="$PROJECT_ROOT/specs/features"
ERRORS=0

if [[ ! -d "$SRC_DIR/service" ]]; then
  echo "INFO: src/service/ directory not found. Skipping spec coverage check."
  exit 0
fi

if [[ ! -d "$SPECS_DIR" ]]; then
  mkdir -p "$SPECS_DIR"
fi

while IFS= read -r -d '' file; do
  basename=$(basename "$file")
  [[ "$basename" == "__init__"* ]] && continue

  rel_path="${file#$PROJECT_ROOT/}"

  if ! head -5 "$file" | grep -q '# Spec:'; then
    echo "ERROR: No spec reference in $rel_path"
    echo "  REMEDIATION: Add '# Spec: specs/features/<name>.md' in the first 5 lines."
    echo ""
    ERRORS=$((ERRORS + 1))
    continue
  fi

  spec_ref=$(head -5 "$file" | grep '# Spec:' | head -1 | sed 's/.*# Spec: *//' | tr -d '[:space:]')
  if [[ ! -f "$PROJECT_ROOT/$spec_ref" ]]; then
    echo "ERROR: Referenced spec not found: $spec_ref (in $rel_path)"
    echo "  REMEDIATION: Create the spec: cp .claude/templates/feature_spec.md $spec_ref"
    echo ""
    ERRORS=$((ERRORS + 1))
  fi
done < <(find "$SRC_DIR/service" -type f \( -name "*.py" -o -name "*.ts" -o -name "*.js" \) -print0 2>/dev/null)

if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS service module(s) missing spec references."
  exit 1
else
  echo "PASSED: All service modules reference valid specs."
fi
