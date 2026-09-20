#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/log.sh"

cd "$(dirname "${BASH_SOURCE[0]}")"

stow_safe() {
  local pkg="$1"
  local backup_dir="$HOME/.dotfiles-backup/$(date +%s)"

  # Only back up real (non-symlink) files that would be shadowed by stow.
  # Mirror stow's --ignore so we never touch generated dirs like node_modules.
  while IFS= read -r file; do
    rel="${file#dotfiles/$pkg/}"
    target="$HOME/$rel"

    # Already a symlink (stow-managed or otherwise) -> let stow handle it.
    if [ -L "$target" ]; then
      continue
    fi

    if [ -e "$target" ]; then
      mkdir -p "$(dirname "$backup_dir/$rel")"
      mv "$target" "$backup_dir/$rel"
      log_warn "Backed up unexpected real file at $target"
    fi
  done < <(find "dotfiles/$pkg" \( -name node_modules -o -name .git \) -prune -o -type f -print)

  stow -d dotfiles -t "$HOME" --no-folding --ignore='node_modules' -v -R "$pkg"

  find "$HOME/.dotfiles-backup" -maxdepth 1 -type d -mtime +30 -exec rm -rf {} \; 2>/dev/null || true
}

source ./set-target.sh
log_phase "Running install for target: $INSTALL_TARGET"

log_step "Updating Omarchy..."
omarchy update

if ! command -v stow &>/dev/null; then
  log_step "Installing stow..."
  omarchy pkg add --noconfirm stow
else
  log_ok "Stow already installed, skipping."
fi

log_phase "Stowing dotfiles..."
stow_safe common
[ -d "dotfiles/$INSTALL_TARGET" ] && stow_safe "$INSTALL_TARGET"

source ./packages/add-packages.sh
source ./configs/apply-configs.sh

log_ok "Done."
