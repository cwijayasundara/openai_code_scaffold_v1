#!/usr/bin/env bash
# Post-commit hook: validates that committed changes align with specs.
# Checks that any modified service files still reference valid specs.

set -uo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "--- Post-commit spec alignment check ---"

# Get files changed in the last commit
CHANGED_FILES=$(git diff --name-only HEAD~1 HEAD 2>/dev/null || echo "")

if [[ -z "$CHANGED_FILES" ]]; then
  echo "No changed files detected. Skipping."
  exit 0
fi

WARNINGS=0

while IFS= read -r file; do
  if [[ "$file" == src/service/* ]]; then
    full_path="$PROJECT_ROOT/$file"
    if [[ -f "$full_path" ]]; then
      if ! head -5 "$full_path" | grep -q '# Spec:'; then
        echo "WARNING: Service file changed without spec reference: $file"
        WARNINGS=$((WARNINGS + 1))
      fi
    fi
  fi
done <<< "$CHANGED_FILES"

if [[ $WARNINGS -gt 0 ]]; then
  echo "Found $WARNINGS service file(s) without spec references."
  echo "Consider adding spec references before the next commit."
fi

echo "Post-commit check complete."
