#!/usr/bin/env bash
set -euo pipefail

BUMP_TYPE="${1:-patch}"  # minor/patch
VERSION_FILE="version.txt"

old_ver="$(cat "$VERSION_FILE" | tr -d '[:space:]')"
IFS='.' read -r MAJ MIN PAT <<< "$old_ver"

case "$BUMP_TYPE" in
  minor) MIN=$((MIN+1)); PAT=0 ;;
  patch) PAT=$((PAT+1)) ;;
  *) echo "unknown bump $BUMP_TYPE"; exit 1 ;;
esac

new_ver="${MAJ}.${MIN}.${PAT}"

echo "$new_ver" > "$VERSION_FILE"
echo "old=$old_ver" >> "$GITHUB_OUTPUT"
echo "new=$new_ver"  >> "$GITHUB_OUTPUT"
