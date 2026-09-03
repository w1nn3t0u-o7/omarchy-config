# omarchy-config

Automated dotfiles, system packages, and configuration management for Omarchy Linux environments across multiple machines.


> **Note:** This is a personal configuration repository, tailored to my own machines, hostnames, and preferences (theme, packages, keybindings). Feel free to fork it and adapt it to your own setup, but running `INSTALL.sh` as-is on your machine will apply my personal choices, not sensible defaults for a stranger.

---

## Architecture Overview

Configurations and package installations are split by host target:

```text
omarchy-config/
├── dotfiles/
│   ├── common/              # Shared dotfiles symlinked across all machines
│   ├── laptop/              # Laptop-specific dotfiles (e.g., monitor profiles)
│   └── desktop/             # Desktop-specific dotfiles
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

## Prerequisites

- A fresh [Omarchy](https://omarchy.org) installation.
- Your machine's hostname registered in `set-target.sh` (see [Adding a New Machine Hostname](#3-adding-a-new-machine-hostname) below). Unregistered hostnames cause the installer to exit with an error.

## Setup on a Fresh Machine

### 1. Install Omarchy

Follow the [official Omarchy installation guide](https://omarchy.org) to get a working base system.

### 2. Clone This Repo

```
mkdir -p ~/Projects
git clone https://github.com/w1nn3t0u-o7/omarchy-config.git ~/Projects/omarchy-config
```

### 3. Run the Installer

```
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

```
cd ~/Projects/omarchy-config
git pull
./INSTALL.sh
```

---

## Adding New Configs, Files, or Packages

### 1. Adding a Dotfile

Place the file in `dotfiles/common/` (for all systems) or `dotfiles/<target>/` (for machine-specific settings) matching your home directory structure:

```
# Example: Adding a shared Alacritty config
mkdir -p ~/Projects/omarchy-config/dotfiles/common/.config/alacritty
cp ~/.config/alacritty/alacritty.toml ~/Projects/omarchy-config/dotfiles/common/.config/alacritty/

# Relink immediately
cd ~/Projects/omarchy-config
./INSTALL.sh
```

### 2. Adding a Package

Create or edit a `.sh` script under `packages/common/` or `packages/<target>/`:

```
# packages/common/tools.sh
omarchy pkg add --noconfirm ripgrep fd fzf
```

### 3. Adding a New Machine Hostname

If you ever add a third machine, register its hostname in `set-target.sh`:

```
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

## Credits

The overall structure of this repo was inspired by [pomartel/omarchy-install-scripts](https://github.com/pomartel/omarchy-install-scripts), an excellent reference for automating Omarchy machine setup. Go check it out.
