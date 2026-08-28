# Discord
if ! command -v discord &>/dev/null && ! pacman -Qi discord &>/dev/null; then
  omarchy pkg add --noconfirm discord
fi
