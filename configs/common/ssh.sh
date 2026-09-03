# SSH Configuration
SSH_KEY_FILE="$HOME/.ssh/id_ed25519"
SSH_KEY_TITLE="$(hostname)"

# Ensure SSH directory exist with correct permissions
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Configure ssh-agent via systemd user service
if systemctl --user is-active ssh-agent.service &>/dev/null; then
  log_ok "ssh-agent user service is already enabled, skipping."
else
  log_step "Enabling and starting ssh-agent.service..."
  systemctl --user enable --now ssh-agent.service
fi

# Generate primary Ed25519 key if missing
if [ ! -f "$SSH_KEY_FILE" ]; then
  log_step "Generating new Ed25519 SSH key for $SSH_KEY_TITLE..."
  ssh-keygen -t ed25519 -C "$SSH_KEY_TITLE" -f "$SSH_KEY_FILE"
  chmod 600 "$SSH_KEY_FILE"
  chmod 644 "${SSH_KEY_FILE}.pub"
else
  log_ok "SSH key already exists, skipping."
fi

# GitHub integration via gh CLI
if command -v gh &>/dev/null; then
  if ! gh auth status &>/dev/null; then
    log_step "GitHub CLI not logged in. Starting interactive authentication..."
    gh auth login --hostname github.com --git-protocol ssh --scopes "repo,read:org,admin:public_key,admin:ssh_signing_key" --skip-ssh-key --web
  elif ! gh auth status 2>&1 | grep -q "admin:public_key"; then
    log_step "Refreshing GitHub CLI permissions for SSH key management..."
    gh auth refresh -h github.com -s "admin:public_key,admin:ssh_signing_key"
  else
    log_ok "Already logged in Github CLI, skipping."
  fi
  
  SSH_PUB_KEY_RAW=$(awk '{print $2}' "${SSH_KEY_FILE}.pub")
  if ! gh ssh-key list 2>/dev/null | grep -q "$SSH_PUB_KEY_RAW"; then
    log_step "Uploading SSH key '$SSH_KEY_TITLE' to GitHub..."
    gh ssh-key add "${SSH_KEY_FILE}.pub" --title "$SSH_KEY_TITLE" --type authentication
  else
    log_ok "SSH key '$SSH_KEY_TITLE' is already registered on GitHub."
  fi

  gh config set -h github.com git_protocol ssh
fi

