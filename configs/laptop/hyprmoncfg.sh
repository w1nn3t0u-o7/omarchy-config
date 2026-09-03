# hyprmoncfg config

if omarchy plugin list 2>/dev/null | grep -q "crmne.hyprmoncfg"; then
  log_ok "Omarchy hyprmoncfg panel already installed, skipping."
else
  log_step "Installing Omarchy hyprmoncfg panel..."
  omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable
fi

log_step "Enabling hyprmoncfgd daemon..."
systemctl --user daemon-reload
systemctl --user enable --now hyprmoncfgd
