#!/usr/bin/env bash
# Structured Logging Linter
# Enforces: No raw print/console statements. Use the project logger.
#
# REMEDIATION: Replace print()/console.log() with the structured logger.
#   Python: from src.runtime.logger import logger; logger.info("message", key=value)
#   JS/TS:  import { logger } from '@/runtime/logger'; logger.info("message", { key: value })

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
ERRORS=0

if [[ ! -d "$SRC_DIR" ]]; then
  echo "INFO: src/ directory not found. Skipping structured logging check."
  exit 0
fi

# Check Python files for print()
while IFS= read -r -d '' file; do
  while IFS= read -r match; do
    line_num=$(echo "$match" | cut -d: -f1)
    line_content=$(echo "$match" | cut -d: -f2-)
    rel_path="${file#$PROJECT_ROOT/}"
    echo "ERROR: Raw print() in $rel_path:$line_num"
    echo "  Line: $line_content"
    echo "  REMEDIATION: Replace with structured logger:"
    echo "    from src.runtime.logger import logger"
    echo "    logger.info(\"descriptive message\", extra={\"key\": value})"
    echo ""
    ERRORS=$((ERRORS + 1))
  done < <(grep -n '^\s*print(' "$file" 2>/dev/null || true)
done < <(find "$SRC_DIR" -name "*.py" -print0 2>/dev/null)

# Check JS/TS files for console.log/warn/error
while IFS= read -r -d '' file; do
  while IFS= read -r match; do
    line_num=$(echo "$match" | cut -d: -f1)
    line_content=$(echo "$match" | cut -d: -f2-)
    rel_path="${file#$PROJECT_ROOT/}"
    echo "ERROR: Raw console.* in $rel_path:$line_num"
    echo "  Line: $line_content"
    echo "  REMEDIATION: Replace with structured logger:"
    echo "    import { logger } from '@/runtime/logger';"
    echo "    logger.info('descriptive message', { key: value });"
    echo ""
    ERRORS=$((ERRORS + 1))
  done < <(grep -n 'console\.\(log\|warn\|error\|debug\|info\)' "$file" 2>/dev/null || true)
done < <(find "$SRC_DIR" \( -name "*.ts" -o -name "*.js" \) -print0 2>/dev/null)

if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS raw logging statement(s) found."
  echo "All logging must use the structured logger for observability."
  exit 1
else
  echo "PASSED: All logging uses structured logger."
fi
