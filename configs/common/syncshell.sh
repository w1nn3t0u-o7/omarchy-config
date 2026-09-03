# Omarchy plugin for Syncthing

PLUGIN_ID="io.github.ilyazar.syncthing"
PLUGIN_REPO="https://github.com/omarchy-QOL/syncshell.git"

if omarchy plugin list 2>/dev/null | grep -q "$PLUGIN_ID"; then
  log_ok "$PLUGIN_ID already installed, skipping."
else
  log_step "Installing $PLUGIN_ID..."
  omarchy plugin add "$PLUGIN_REPO" --enable
fi

