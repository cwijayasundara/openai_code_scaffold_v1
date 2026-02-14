#!/usr/bin/env bash
# Master Linter — runs all custom linters in sequence.
# Collects results and reports a summary.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LINTERS_DIR="$SCRIPT_DIR/linters"
TOTAL_ERRORS=0
FAILED_LINTERS=()

echo "========================================="
echo "  SDSL Linter Suite"
echo "========================================="
echo ""

for linter in "$LINTERS_DIR"/*.sh; do
  linter_name=$(basename "$linter" .sh)
  echo "--- Running: $linter_name ---"
  if bash "$linter"; then
    echo ""
  else
    TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
    FAILED_LINTERS+=("$linter_name")
    echo ""
  fi
done

echo "========================================="
if [[ $TOTAL_ERRORS -gt 0 ]]; then
  echo "  RESULT: FAILED — ${#FAILED_LINTERS[@]} linter(s) failed"
  echo "  Failed: ${FAILED_LINTERS[*]}"
  echo ""
  echo "  Fix the issues above and re-run: bash scripts/lint_all.sh"
  echo "========================================="
  exit 1
else
  echo "  RESULT: ALL PASSED"
  echo "========================================="
fi
