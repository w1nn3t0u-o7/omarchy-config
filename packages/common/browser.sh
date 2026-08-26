# Firefox browser
if ! command -v firefox &>/dev/null; then
  omarchy install browser firefox
fi

if [ "$(xdg-settings get default-web-browser)" != "firefox.desktop" ]; then
  omarchy default browser firefox
fi

# Add dynamic theming based off of Omarchy theme
if ! pacman -Qi omarchy-firefox-theme &>/dev/null; then
  CLONE_DIR="$(mktemp -d)"
  git clone https://github.com/vannrr/omarchy-firefox-theme.git "$CLONE_DIR"
  (cd "$CLONE_DIR" && makepkg -si --noconfirm)
  rm -rf "$CLONE_DIR"
fi
