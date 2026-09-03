# Omarchy plugin for Syncthing

PLUGIN_ID="io.github.ilyazar.syncthing"
PLUGIN_REPO="https://github.com/omarchy-QOL/syncshell.git"

echo "Configuring Syncthing shell plugin..."
if omarchy plugin list 2>/dev/null | grep -q "$PLUGIN_ID"; then
  echo "  $PLUGIN_ID already installed, skipping."
else
  omarchy plugin add "$PLUGIN_REPO" --enable
  echo "  $PLUGIN_ID installed and enabled."
fi

