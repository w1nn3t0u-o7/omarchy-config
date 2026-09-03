# Fonts

if ! fc-list | grep -qi "Atkinson Hyperlegible"; then
  log_step "Installing Atkinson Hyperlegible font..."
  omarchy pkg add --noconfirm ttf-atkinson-hyperlegible
else
  log_ok "Atkinson Hyperlegible already installed, skipping."
fi
