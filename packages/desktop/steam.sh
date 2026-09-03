# Steam gaming client

if ! command -v steam &>/dev/null && ! pacman -Qi steam &>/dev/null; then
  log_step "Installing Steam..."
  omarchy install gaming steam
else
  log_ok "Steam already installed, skipping."
fi

# Gamescope micro-compositor overlay
if ! command -v gamescope &>/dev/null && ! pacman -Qi gamescope &>/dev/null; then
  log_step "Installing gamescope..."
  omarchy pkg add --noconfirm gamescope
else
  log_ok "gamescope already installed, skipping."
fi
