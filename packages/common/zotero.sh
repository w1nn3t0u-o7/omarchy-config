# Zotero
# zotero-bin is an AUR package; there is no official-repo equivalent.

if ! command -v zotero &>/dev/null && ! pacman -Qi zotero-bin &>/dev/null; then
  log_step "Installing Zotero (zotero-bin from AUR)..."
  omarchy pkg aur add zotero-bin || {
    log_err "Could not install zotero-bin; check that the AUR is reachable."
    return 1
  }
else
  log_ok "Zotero already installed, skipping."
fi
