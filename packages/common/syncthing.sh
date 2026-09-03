# Syncthing

if ! command -v syncthing &>/dev/null; then
  log_step "Installing Syncthing..."
  omarchy pkg add --noconfirm syncthing
else
  log_ok "Syncthing already installed, skipping."
fi

if systemctl --user list-unit-files 2>/dev/null | grep -q '^syncthing.service'; then
  if systemctl --user is-active syncthing.service &>/dev/null; then
    log_ok "syncthing.service already running, skipping."
  else
    log_step "Enabling and starting syncthing.service..."
    systemctl --user enable --now syncthing.service
  fi
else
  log_warn "syncthing.service unit not found; check package unit name."
fi
