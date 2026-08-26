#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Loading common packages..."
for script in "$SCRIPT_DIR"/common/*.sh; do
  [ -f "$script" ] || continue
  echo "  -> $(basename "$script")"
  source "$script"
done

TARGET_DIR="$SCRIPT_DIR/${INSTALL_TARGET:-}"
if [ -n "${INSTALL_TARGET:-}" ] && [ -d "$TARGET_DIR" ]; then
  echo "Loading $INSTALL_TARGET packages..."
  for script in "$TARGET_DIR"/*.sh; do
    [ -f "$script" ] || continue
    echo "  -> $(basename "$script")"
    source "$script"
  done
fi
