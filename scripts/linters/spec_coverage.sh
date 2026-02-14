#!/usr/bin/env bash
# Spec Coverage Linter
# Enforces: Every service module must trace to a spec file.
#
# REMEDIATION: Create a spec in specs/features/ before implementing.
# Use the template at specs/templates/feature_spec.md.
# Add a "# Spec: specs/features/<name>.md" comment at the top of the module.

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
  echo "WARN: specs/features/ directory not found. Creating it."
  mkdir -p "$SPECS_DIR"
fi

# Check each service module references a spec
while IFS= read -r -d '' file; do
  basename=$(basename "$file")
  # Skip __init__ files
  if [[ "$basename" == "__init__"* ]]; then
    continue
  fi

  rel_path="${file#$PROJECT_ROOT/}"

  # Check for spec reference comment
  if ! head -5 "$file" | grep -q '# Spec:'; then
    echo "ERROR: No spec reference in $rel_path"
    echo "  REMEDIATION: Add a spec reference comment in the first 5 lines:"
    echo "    # Spec: specs/features/<feature-name>.md"
    echo "  Then create the spec file using the template:"
    echo "    cp specs/templates/feature_spec.md specs/features/<feature-name>.md"
    echo ""
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Extract the referenced spec path
  spec_ref=$(head -5 "$file" | grep '# Spec:' | sed 's/.*# Spec: *//' | tr -d '[:space:]')
  if [[ ! -f "$PROJECT_ROOT/$spec_ref" ]]; then
    echo "ERROR: Referenced spec not found for $rel_path"
    echo "  Referenced: $spec_ref"
    echo "  REMEDIATION: Create the spec file at $spec_ref"
    echo "    cp specs/templates/feature_spec.md $spec_ref"
    echo ""
    ERRORS=$((ERRORS + 1))
  fi
done < <(find "$SRC_DIR/service" -type f \( -name "*.py" -o -name "*.ts" -o -name "*.js" \) -print0 2>/dev/null)

if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS service module(s) missing spec references."
  echo "Every service module must trace to a spec. No code without specs."
  exit 1
else
  echo "PASSED: All service modules reference valid specs."
fi
