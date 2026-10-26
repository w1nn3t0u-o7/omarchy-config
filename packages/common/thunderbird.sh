# Thunderbird email client

if ! command -v thunderbird &>/dev/null && ! pacman -Qi thunderbird &>/dev/null; then
  log_step "Installing Thunderbird..."
  omarchy pkg add --noconfirm thunderbird
else
  log_ok "Thunderbird already installed, skipping."
fi
