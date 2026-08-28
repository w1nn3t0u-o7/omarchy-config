# Ghostty
if ! command -v ghostty &>/dev/null; then
  omarchy install terminal ghostty
fi

# Set default terminal if not already configured as primary
FIRST_TERM=$(grep -v "^#" "$HOME/.config/xdg-terminals.list" 2>/dev/null | head -n 1 || true)
if [[ "$FIRST_TERM" != *"ghostty"* ]]; then
  omarchy default terminal ghostty
fi
# Maybe ghostty-nautilus for file manager integration?
