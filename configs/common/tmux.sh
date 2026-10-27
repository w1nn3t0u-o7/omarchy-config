# Tmux Plugin Manager and plugins

TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_REPO="https://github.com/tmux-plugins/tpm"

if [ -d "$TPM_DIR/.git" ]; then
  log_ok "TPM already installed, skipping."
else
  log_step "Installing Tmux Plugin Manager..."
  mkdir -p "$HOME/.tmux/plugins"
  git clone --depth=1 "$TPM_REPO" "$TPM_DIR"
fi

log_step "Installing tmux plugins..."

tmp_dir="$(mktemp -d)"
socket_dir="$tmp_dir/socket"
socket="$socket_dir/tmux-$(id -u)/default"
mkdir -p "$socket_dir/tmux-$(id -u)"
chmod 700 "$tmp_dir" "$socket_dir" "$socket_dir/tmux-$(id -u)"

cleanup_tpm() {
  [ -n "${socket:-}" ] && tmux -S "$socket" kill-server 2>/dev/null || true
  rm -rf "$tmp_dir"
}
trap cleanup_tpm EXIT

# Run TPM against an isolated server (no config, so continuum does not restore
# the live environment while installing).
env -u TMUX -u TMUX_PANE TMUX_TMPDIR="$socket_dir" \
  tmux -f /dev/null new-session -d -s "tpm-bootstrap-$$"
env -u TMUX -u TMUX_PANE TMUX_TMPDIR="$socket_dir" \
  tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
env -u TMUX -u TMUX_PANE TMUX_TMPDIR="$socket_dir" \
  bash "$TPM_DIR/bin/install_plugins"

trap - EXIT
cleanup_tpm
