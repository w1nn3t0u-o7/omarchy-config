# AI Agent config

DESIRED_AGENT="pi"
AGENT_FILE="$HOME/.config/omarchy/defaults/agent"

# Ensure the agent is installed via mise
if mise where "$DESIRED_AGENT" &>/dev/null; then
  log_ok "$DESIRED_AGENT already installed via mise, skipping install."
else
  log_step "Installing $DESIRED_AGENT via mise..."
  mise use -g "$DESIRED_AGENT"
fi

# Ensure Omarchy's configured default agent is the desired one.
if [ "$(omarchy default agent 2>/dev/null)" = "$DESIRED_AGENT" ]; then
  log_ok "$DESIRED_AGENT is already the default agent, skipping."
else
  log_step "Setting $DESIRED_AGENT as the default agent..."
  mkdir -p "$(dirname "$AGENT_FILE")"
  printf '%s\n' "$DESIRED_AGENT" >"$AGENT_FILE"
fi

# Automatic install of extension packages for pi
PI_EXT_DIR="$HOME/.pi/agent/extensions"
if [[ -d "$PI_EXT_DIR" ]]; then
  log_phase "Installing pi extension dependencies..."
  for pkg in "$PI_EXT_DIR"/*/package.json; do
    [[ -f "$pkg" ]] || continue
    ext_dir="$(dirname "$pkg")"
    log_step "Installing npm package: $(basename "$ext_dir")"
    (cd "$ext_dir" && npm install --omit=dev --no-audit --no-fund)
    if grep -q '"playwright-core"' "$pkg"; then
      log_ok "Downloading Chromium for $(basename "$ext_dir")..."
      (cd "$ext_dir" && npx playwright install chromium)
    fi
  done
  log_ok "Installed all the npm packages successfully."
else
  log_warn "Extensions directory for pi agent does not exist, skipping package installation."
fi

