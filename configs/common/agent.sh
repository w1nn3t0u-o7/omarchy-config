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

