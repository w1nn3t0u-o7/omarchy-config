#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

stow_safe() {
  local pkg="$1"
  local backup_dir="$HOME/.dotfiles-backup/$(date +%s)"

  find "dotfiles/$pkg" -type f | while read -r file; do
    rel="${file#dotfiles/$pkg/}"
    target="$HOME/$rel"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      mkdir -p "$(dirname "$backup_dir/$rel")"
      mv "$target" "$backup_dir/$rel"
      echo "WARNING: backed up unexpected real file at $target" >&2
    fi
  done

  stow -d dotfiles -t "$HOME" -R "$pkg"

  find "$HOME/.dotfiles-backup" -maxdepth 1 -type d -mtime +30 -exec rm -rf {} \; 2>/dev/null || true
}

source ./set-target.sh
echo "Running install for target: $INSTALL_TARGET"

echo "Updating Omarchy..."
omarchy update

if ! command -v stow &>/dev/null; then
  echo "Installing stow..."
  omarchy pkg add --noconfirm stow
fi

echo "Stowing dotfiles..."
stow_safe common
[ -d "dotfiles/$INSTALL_TARGET" ] && stow_safe "$INSTALL_TARGET"

echo "Installing packages..."
source ./packages/add-packages.sh

echo "Applying configs..."
source ./configs/apply-configs.sh

echo "Done."
