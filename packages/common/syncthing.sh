# Syncthing

if ! command -v syncthing &>/dev/null; then
  echo "Installing syncthing..."
  omarchy pkg add --noconfirm syncthing
else
  echo "syncthing already installed, skipping."
fi

if systemctl --user list-unit-files 2>/dev/null | grep -q '^syncthing.service'; then
  if systemctl --user is-active syncthing.service &>/dev/null; then
    echo "syncthing.service already running, skipping."
  else
    echo "Enabling and starting syncthing.service..."
    systemctl --user enable --now syncthing.service
  fi
else
  echo "WARNING: syncthing.service unit not found; check package unit name." >&2
fi
