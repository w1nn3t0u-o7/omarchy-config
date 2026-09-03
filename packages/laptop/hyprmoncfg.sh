# hyprmoncfg package

echo "Installing hyprmoncfg..."
if ! command -v hyprmoncfg &>/dev/null; then
  omarchy pkg aur add --noconfirm hyprmoncfg-bin
else
  echo "  hyprmonconfig already installed, skipping."
fi

