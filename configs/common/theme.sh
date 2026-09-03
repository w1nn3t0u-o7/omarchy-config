# Catppuccin theme
DESIRED_THEME="Catppuccin"

if [ "$(omarchy theme current)" != "$DESIRED_THEME" ]; then
  log_step "Setting theme to $DESIRED_THEME..."
  omarchy theme set "Catppuccin"
else
  log_ok "$DESIRED_THEME already set, skipping."
fi

