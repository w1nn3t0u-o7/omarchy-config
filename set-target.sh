#!/usr/bin/env bash

# Maps hostname to a config target. Add new machines here.

# Make log_* helpers available when run standalone (no-op when already sourced).
if ! declare -F log_err >/dev/null 2>&1; then
  # shellcheck source=lib/log.sh
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/log.sh"
fi

case "$(hostname)" in
  laptop-omarchy)
    export INSTALL_TARGET="laptop"
    ;;
  desktop-omarchy)
    export INSTALL_TARGET="desktop"
    ;;
  *)
    log_err "Unknown hostname: $(hostname). Add it to set-target.sh."
    exit 1
    ;;
esac

log_ok "Target set to: $INSTALL_TARGET"
