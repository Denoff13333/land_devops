#!/usr/bin/env bash
set -euo pipefail

NEW_VER="$1"
BRANCH_NAME="${2:-unknown}"
PR_NUMBER="${3:-N/A}"
NOW="$(date '+%Y.%m.%d %H:%M:%S')"

CHANGELOG="CHANGELOG.md"
TMP="$(mktemp)"

{
  echo "[${NEW_VER}] - ${NOW} ${BRANCH_NAME} (PR #${PR_NUMBER})"
  echo ""
  git log -1 --pretty=format:"- %s" || true
  echo ""
  cat "$CHANGELOG"
} > "$TMP"

mv "$TMP" "$CHANGELOG"
