# Discord
if ! command -v discord &>/dev/null && ! pacman -Qi discord &>/dev/null; then
  log_step "Installing Discord..."
  omarchy pkg add --noconfirm discord
else
  log_ok "Discord already installed, skipping."
fi
