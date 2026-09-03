# Firefox browser
if ! command -v firefox &>/dev/null; then
  log_step "Installing Firefox..."
  omarchy install browser firefox
else
  log_ok "Firefox already installed, skipping."
fi

if [ "$(xdg-settings get default-web-browser)" != "firefox.desktop" ]; then
  log_step "Setting Firefox as the default browser..."
  omarchy default browser firefox
else
  log_ok "Firefox is already the default browser, skipping."
fi

# Add dynamic theming based off of Omarchy theme
if ! pacman -Qi omarchy-firefox-theme &>/dev/null; then
  log_step "Installing dynamic omarchy theming for Firefox..."
  CLONE_DIR="$(mktemp -d)"
  git clone https://github.com/vannrr/omarchy-firefox-theme.git "$CLONE_DIR"
  (cd "$CLONE_DIR" && makepkg -si --noconfirm)
  rm -rf "$CLONE_DIR"
else
  log_ok "Dynamic omarchy theming for Firefox already installed, skipping."
fi

