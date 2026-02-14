#!/usr/bin/env bash
# Post-write hook: runs targeted linters on the file that was just written.
# Only runs the relevant linters based on file location.
#
# This runs AFTER Claude Code writes or edits a file.

set -uo pipefail

FILE_PATH="${1:-}"
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LINTERS_DIR="$PROJECT_ROOT/scripts/linters"

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

REL_PATH="${FILE_PATH#$PROJECT_ROOT/}"
ERRORS=0

# Only lint source files
if [[ "$REL_PATH" != "src/"* ]]; then
  exit 0
fi

echo "--- Post-write lint for: $REL_PATH ---"

# Always check file size
if bash "$LINTERS_DIR/file_size.sh" 2>/dev/null; then
  :
else
  ERRORS=$((ERRORS + 1))
fi

# Always check naming
if bash "$LINTERS_DIR/naming_conventions.sh" 2>/dev/null; then
  :
else
  ERRORS=$((ERRORS + 1))
fi

# Check structured logging
if bash "$LINTERS_DIR/structured_logging.sh" 2>/dev/null; then
  :
else
  ERRORS=$((ERRORS + 1))
fi

# Check layer deps
if bash "$LINTERS_DIR/layer_deps.sh" 2>/dev/null; then
  :
else
  ERRORS=$((ERRORS + 1))
fi

# Check spec coverage for service files
if [[ "$REL_PATH" == "src/service/"* ]]; then
  if bash "$LINTERS_DIR/spec_coverage.sh" 2>/dev/null; then
    :
  else
    ERRORS=$((ERRORS + 1))
  fi
fi

if [[ $ERRORS -gt 0 ]]; then
  echo "WARNING: $ERRORS linter(s) reported issues after writing $REL_PATH"
  echo "Read the error messages above — they contain remediation instructions."
  # Exit 0 so we don't block the write, but the agent sees the warnings
fi

exit 0
