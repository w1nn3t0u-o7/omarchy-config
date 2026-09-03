# hyprmoncfg package

if ! command -v hyprmoncfg &>/dev/null; then
  log_step "Installing hyprmoncfg..."
  omarchy pkg aur add --noconfirm hyprmoncfg-bin
else
  log_ok "hyprmoncfg already installed, skipping."
fi

