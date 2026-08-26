# SSH Configuration
SSH_KEY_FILE="$HOME/.ssh/id_ed25519"
SSH_KEY_TITLE="$(hostname)"

echo "Configuring SSH environment..."

# Ensure SSH directory exist with correct permissions
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Configure ssh-agent via systemd user service
if systemctl --user is-enabled ssh-agent.service &>/dev/null; then
  echo "ssh-agent user service is already enabled."
else
  echo "Enabling and starting ssh-agent.service..."
  systemctl --user enable --now ssh-agent.service
fi

# Generate primary Ed25519 key if missing
if [ ! -f "$SSH_KEY_FILE" ]; then
  echo "Generating new Ed25519 SSH key for $SSH_KEY_TITLE..."
  ssh-keygen -t ed25519 -C "$SSH_KEY_TITLE" -f "$SSH_KEY_FILE"
  chmod 600 "$SSH_KEY_FILE"
  chmod 644 "${SSH_KEY_FILE}.pub"
fi

# GitHub integration via gh CLI
if command -v gh &>/dev/null; then
  if ! gh auth status &>/dev/null; then
    echo "GitHub CLI not logged in. Starting interactive authentication..."
    gh auth login --hostname github.com --git-protocol ssh --web
  fi
  
  SSH_PUB_KEY=$(cat "${SSH_KEY_FILE}.pub")
  if ! gh ssh-key list 2>/dev/null | grep -q "$SSH_PUB_KEY"; then
    echo "Uploading SSH key '$SSH_KEY_TITLE' to GitHub..."
    gh ssh-key add "${SSH_KEY_FILE}.pub" --title "$SSH_KEY_TITLE" --type authentication
  else
    echo "SSH key '$SSH_KEY_TITLE' is already registered on GitHub."
  fi

  gh config set -h github.com git_protocol ssh
fi

echo "SSH setup complete."


