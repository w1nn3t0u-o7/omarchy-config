# Tailscale
if ! command -v tailscale &>/dev/null; then
  log_step "Installing Tailscale..."
  omarchy install service tailscale
else
  log_ok "Tailscale already installed, skipping."
fi

