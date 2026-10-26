# Syncthing

if ! command -v syncthing &>/dev/null; then
  log_step "Installing Syncthing..."
  omarchy pkg add --noconfirm syncthing
else
  log_ok "Syncthing already installed, skipping."
fi

# Arch ships syncthing.service as a *user* unit; some setups use the
# system-wide template syncthing@<user>.service instead.
user_unit="syncthing.service"
system_unit="syncthing@$(id -un).service"

if ! systemctl --user show-environment >/dev/null 2>&1; then
  # Don't mistake "no user bus" (missing XDG_RUNTIME_DIR, e.g. tty/ssh/cron)
  # for "unit not found" -- that was a misleading warning before.
  log_warn "Cannot reach the systemd user manager (XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-unset}); skipping Syncthing service setup."
elif systemctl --user is-active --quiet "$user_unit"; then
  log_ok "$user_unit already running, skipping."
elif systemctl --user cat "$user_unit" >/dev/null 2>&1; then
  log_step "Enabling and starting $user_unit..."
  systemctl --user enable --now "$user_unit"
elif systemctl cat "$system_unit" >/dev/null 2>&1; then
  # System-scope unit exists; it needs root, so only report state here.
  if systemctl is-active --quiet "$system_unit"; then
    log_ok "$system_unit already running, skipping."
  else
    log_warn "$system_unit exists but is not running; enable it with: sudo systemctl enable --now $system_unit"
  fi
elif pgrep -x syncthing >/dev/null 2>&1; then
  log_ok "Syncthing is already running, but not under a systemd unit; nothing to enable."
else
  log_warn "No Syncthing systemd unit found ($user_unit or $system_unit)."
fi
