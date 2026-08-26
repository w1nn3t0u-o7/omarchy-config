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
    echo "Unknown hostname: $(hostname). Add it to set-target.sh." >&2
    exit 1
    ;;
esac

echo "Target set to: $INSTALL_TARGET"
