# omarchy-config

Automated dotfiles, system packages, and configuration management for Omarchy Linux environments across multiple machines.

---

## Architecture Overview

Configurations and package installations are split by host target:

```text
omarchy-config/
├── dotfiles/
│   ├── common/              # Shared dotfiles symlinked across all machines
│   ├── laptop/              # Laptop-specific dotfiles (e.g., battery/trackpad)
│   └── desktop/             # Desktop-specific dotfiles (e.g., multi-monitor/GPU)
├── packages/
│   ├── common/              # Base packages installed on every machine
│   ├── laptop/              # Laptop-only packages
│   └── desktop/             # Desktop-only packages
├── configs/
│   ├── common/              # Shared setup scripts (e.g., SSH, git, themes)
│   ├── laptop/              # Laptop configuration scripts
│   └── desktop/             # Desktop configuration scripts
├── set-target.sh            # Maps machine hostname to target (laptop / desktop)
└── INSTALL.sh               # Main idempotent installer
```

---

## Setup on a Fresh Machine

Follow these steps when setting up on a new device.

### 1. Set the Hostname
Ensure your hostname matches one defined in `set-target.sh` (`laptop-omarchy` or `desktop-omarchy`):

```bash
hostnamectl set-hostname desktop-omarchy
```

### 2. Authenticate GitHub CLI & Clone
Authenticate via the browser using `gh` with the required key-management scopes, then clone the private repository:

```bash
# Authenticate
gh auth login --hostname github.com --git-protocol ssh --scopes "repo,read:org,admin:public_key,admin:ssh_signing_key" --skip-ssh-key --web

# Clone repository
mkdir -p ~/Projects
gh repo clone w1nn3t0u-o7/omarchy-config ~/Projects/omarchy-config
```

### 3. Run the Installer

```bash
cd ~/Projects/omarchy-config
chmod +x INSTALL.sh
./INSTALL.sh
```

`INSTALL.sh` handles the rest automatically:
- Generates an Ed25519 SSH key titled after your hostname.
- Uploads the public key to your GitHub account.
- Starts and enables the user `ssh-agent.service`.
- Updates system packages via `omarchy`.
- Symlinks common and target-specific dotfiles via `stow` (safely backing up conflicts to `~/.dotfiles-backup/`).
- Installs all defined packages and runs configuration scripts.

---

## Updating an Existing Machine

Because all installer steps and Stow links are idempotent, you can run updates anytime without fear of breaking active configs.

### Pull and Apply Latest Changes
To sync changes pushed from another machine:

```bash
cd ~/Projects/omarchy-config
git pull
./INSTALL.sh
```

---

## Adding New Configs, Files, or Packages

### 1. Adding a Dotfile
Place the file in `dotfiles/common/` (for all systems) or `dotfiles/<target>/` (for machine-specific settings) matching your home directory structure:

```bash
# Example: Adding a shared Alacritty config
mkdir -p ~/Projects/omarchy-config/dotfiles/common/.config/alacritty
cp ~/.config/alacritty/alacritty.toml ~/Projects/omarchy-config/dotfiles/common/.config/alacritty/

# Relink immediately
cd ~/Projects/omarchy-config
./INSTALL.sh
```

### 2. Adding a Package
Create or edit a `.sh` script under `packages/common/` or `packages/<target>/`:

```bash
# packages/common/tools.sh
omarchy pkg add --noconfirm ripgrep fd fzf
```

### 3. Adding a New Machine Hostname
If you ever add a third machine, register its hostname in `set-target.sh`:

```bash
case "$(hostname)" in
  laptop-omarchy)
    export INSTALL_TARGET="laptop"
    ;;
  desktop-omarchy)
    export INSTALL_TARGET="desktop"
    ;;
  workstation-omarchy)
    export INSTALL_TARGET="desktop"
    ;;
  *)
    echo "Unknown hostname: $(hostname). Add it to set-target.sh." >&2
    exit 1
    ;;
esac
```

---

## Pushing Changes Back to GitHub

```bash
cd ~/Projects/omarchy-config
git add .
git commit -m "Update dotfiles and package lists"
git push
```
