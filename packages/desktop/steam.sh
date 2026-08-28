# Steam gaming client
if ! command -v steam &>/dev/null && ! pacman -Qi steam &>/dev/null; then
  omarchy install gaming steam
fi

# Gamescope micro-compositor overlay
if ! command -v gamescope &>/dev/null && ! pacman -Qi gamescope &>/dev/null; then
  omarchy pkg add --noconfirm gamescope
fi
