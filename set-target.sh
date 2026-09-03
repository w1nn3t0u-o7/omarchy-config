#!/usr/bin/env bash

# Maps hostname to a config target. Add new machines here.

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
