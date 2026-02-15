#!/usr/bin/env bash
# Pre-write hook: blocks writes to src/ unless an approved plan exists.
# Warns when creating new service files without a spec reference.

set -euo pipefail

FILE_PATH="${1:-}"
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

REL_PATH="${FILE_PATH#$PROJECT_ROOT/}"

# Rule 1: Prevent writing outside recognized directories
VALID_DIRS=("src/" "tests/" "specs/" ".claude/")
VALID=false
for dir in "${VALID_DIRS[@]}"; do
  if [[ "$REL_PATH" == "$dir"* ]]; then
    VALID=true
    break
  fi
done

# Allow root-level config files
if [[ "$REL_PATH" != *"/"* ]]; then
  VALID=true
fi

if [[ "$VALID" == "false" ]]; then
  echo "BLOCKED: Writing to unrecognized directory: $REL_PATH"
  echo "REMEDIATION: Files must be in one of: ${VALID_DIRS[*]}"
  exit 1
fi

# Rule 2: Block writes to src/ unless an approved plan exists
if [[ "$REL_PATH" == "src/"* ]]; then
  PLANS_DIR="$PROJECT_ROOT/specs/plans"

  if [[ ! -d "$PLANS_DIR" ]]; then
    echo "BLOCKED: No specs/plans/ directory found."
    echo ""
    echo "REMEDIATION:"
    echo "  1. Write the spec:  cp .claude/templates/feature_spec.md specs/features/<name>.md"
    echo "  2. Write the plan:  cp .claude/templates/execution_plan.md specs/plans/<name>.md"
    echo "  3. Get human approval (change Status to 'Approved')"
    exit 1
  fi

  APPROVED_PLAN_FOUND=false
  for plan_file in "$PLANS_DIR"/*.md; do
    [[ -f "$plan_file" ]] || continue
    if grep -qi '^\*\*Status\*\*:.*approved' "$plan_file" 2>/dev/null; then
      APPROVED_PLAN_FOUND=true
      break
    fi
  done

  if [[ "$APPROVED_PLAN_FOUND" == "false" ]]; then
    echo "BLOCKED: No approved execution plan found in specs/plans/"
    echo ""
    echo "REMEDIATION:"
    echo "  1. Write the plan: cp .claude/templates/execution_plan.md specs/plans/<name>.md"
    echo "  2. Get human approval: change **Status**: Approved"
    echo ""
    echo "Existing plans:"
    for plan_file in "$PLANS_DIR"/*.md; do
      [[ -f "$plan_file" ]] || { echo "  (none)"; break; }
      plan_name=$(basename "$plan_file")
      plan_status=$(grep -i '^\*\*Status\*\*:' "$plan_file" | head -1 | sed 's/.*: *//' || echo "unknown")
      echo "  $plan_name — Status: $plan_status"
    done
    exit 1
  fi
fi

# Rule 3: Warn if creating a new service file without a spec reference
if [[ "$REL_PATH" == "src/service/"* ]] && [[ ! -f "$FILE_PATH" ]]; then
  echo "NOTE: Creating new service file $REL_PATH"
  echo "REMINDER: Add '# Spec: specs/features/<name>.md' in the first 5 lines."
fi

exit 0
