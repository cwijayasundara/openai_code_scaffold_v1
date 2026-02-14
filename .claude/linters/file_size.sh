#!/usr/bin/env bash
# File Size Linter
# Enforces: Max 300 lines per file, max 50 lines per function
#
# REMEDIATION: Split large files by responsibility. Extract large functions
# into smaller helper functions. Each file should have a single clear purpose.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
MAX_FILE_LINES=300
MAX_FUNC_LINES=50
ERRORS=0

if [[ ! -d "$SRC_DIR" ]]; then
  echo "INFO: src/ directory not found. Skipping file size check."
  exit 0
fi

# Check file line counts
while IFS= read -r -d '' file; do
  line_count=$(wc -l < "$file")
  if [[ $line_count -gt $MAX_FILE_LINES ]]; then
    rel_path="${file#$PROJECT_ROOT/}"
    echo "ERROR: File too large: $rel_path ($line_count lines, max $MAX_FILE_LINES)"
    echo "  REMEDIATION: Split this file into smaller modules by responsibility."
    echo "  Each file should have a single clear purpose."
    echo "  Consider extracting related functions into a new file in the same layer."
    echo ""
    ERRORS=$((ERRORS + 1))
  fi
done < <(find "$SRC_DIR" -type f \( -name "*.py" -o -name "*.ts" -o -name "*.js" \) -print0 2>/dev/null)

# Check Python function sizes
while IFS= read -r -d '' file; do
  rel_path="${file#$PROJECT_ROOT/}"
  func_start=""
  func_name=""
  func_line=0
  current_line=0

  while IFS= read -r line; do
    current_line=$((current_line + 1))

    # Detect function definitions
    if echo "$line" | grep -qE '^\s*(def|async def) \w+'; then
      # Check previous function if any
      if [[ -n "$func_name" ]]; then
        func_length=$((current_line - func_line))
        if [[ $func_length -gt $MAX_FUNC_LINES ]]; then
          echo "ERROR: Function too large: $rel_path:$func_line $func_name() ($func_length lines, max $MAX_FUNC_LINES)"
          echo "  REMEDIATION: Extract helper functions for distinct logical steps."
          echo "  Each function should do one thing well."
          echo ""
          ERRORS=$((ERRORS + 1))
        fi
      fi
      func_name=$(echo "$line" | grep -oP '(?<=def )\w+')
      func_line=$current_line
    fi
  done < "$file"

  # Check last function
  if [[ -n "$func_name" ]]; then
    func_length=$((current_line - func_line + 1))
    if [[ $func_length -gt $MAX_FUNC_LINES ]]; then
      echo "ERROR: Function too large: $rel_path:$func_line $func_name() ($func_length lines, max $MAX_FUNC_LINES)"
      echo "  REMEDIATION: Extract helper functions for distinct logical steps."
      echo ""
      ERRORS=$((ERRORS + 1))
    fi
  fi
done < <(find "$SRC_DIR" -name "*.py" -print0 2>/dev/null)

if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS file/function size violation(s) found."
  exit 1
else
  echo "PASSED: All files and functions within size limits."
fi
