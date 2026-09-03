# Spotify
if ! command -v spotify &>/dev/null; then
  log_step "Installing Spotify..."
  omarchy install service spotify
else
  log_ok "Spotify already installed, skipping."
fi

