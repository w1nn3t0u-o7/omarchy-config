# hyprmoncfg config

echo "Configuring hyprmoncfg..."
if omarchy plugin list 2>/dev/null | grep -q "crmne.hyprmoncfg"; then
  echo "  Omarchy hyprmoncfg panel already installed, skipping."
else
  omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable
  echo "  Omarchy hyprmoncfg panel installed."
fi

echo "Enabling hyprmoncfgd daemon..."
systemctl --user daemon-reload
systemctl --user enable --now hyprmoncfgd
