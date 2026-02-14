#!/usr/bin/env bash
# Pre-write hook: validates that the agent is writing to a valid location
# and that service files have a spec reference.
#
# This runs BEFORE Claude Code writes or edits a file.

set -euo pipefail

FILE_PATH="${1:-}"
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Normalize path
REL_PATH="${FILE_PATH#$PROJECT_ROOT/}"

# Rule 1: Prevent writing outside recognized directories
VALID_DIRS=("src/" "tests/" "specs/" "docs/" "scripts/" ".claude/")
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

# Rule 2: Warn if creating a new service file without a spec reference
if [[ "$REL_PATH" == "src/service/"* ]] && [[ ! -f "$FILE_PATH" ]]; then
  echo "NOTE: Creating new service file $REL_PATH"
  echo "REMINDER: Add '# Spec: specs/features/<name>.md' in the first 5 lines."
  echo "Create the spec first using: cp specs/templates/feature_spec.md specs/features/<name>.md"
fi

exit 0
