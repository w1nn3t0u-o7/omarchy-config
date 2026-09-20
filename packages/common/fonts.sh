# Fonts

if ! fc-list 2>/dev/null | grep -i "Atkinson Hyperlegible" >/dev/null; then
  log_step "Installing Atkinson Hyperlegible font..."
  omarchy pkg add --noconfirm ttf-atkinson-hyperlegible
else
  log_ok "Atkinson Hyperlegible already installed, skipping."
fi
