# Ghostty
if ! command -v ghostty &>/dev/null; then
  log_step "Installing Ghostty..."
  omarchy install terminal ghostty
else
  log_ok "Ghostty already installed, skipping."
fi

# Set default terminal if not already configured as primary
FIRST_TERM=$(grep -v "^#" "$HOME/.config/xdg-terminals.list" 2>/dev/null | head -n 1 || true)
if [[ "$FIRST_TERM" != *"ghostty"* ]]; then
  log_step "Setting Ghostty as the default terminal..."
  omarchy default terminal ghostty
else
  log_ok "Ghostty is already the default terminal, skipping."
fi
# Maybe ghostty-nautilus for file manager integration?
