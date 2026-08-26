# Catppuccin theme
DESIRED_THEME="Catppuccin"

if [ "$(omarchy theme current)" != "$DESIRED_THEME" ]; then
  echo "Setting theme to $DESIRED_THEME..."
  omarchy theme set "Catppuccin"
fi

