# AI Agent config

DESIRED_AGENT="pi"

if mise where "$DESIRED_AGENT" &>/dev/null; then
  log_ok "$DESIRED_AGENT already installed via mise, confirming default agent..."
else
  log_step "Installing $DESIRED_AGENT via mise and setting it as default agent..."
  omarchy default agent "$DESIRED_AGENT"
fi

