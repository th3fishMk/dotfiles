#!/bin/bash
set -e

# Rename the Hostname
echo "Configuring system name..."
RENAME_CHOICE=""
read -rp "Do you want to rename this computer? (y/N): " RENAME_CHOICE
RENAME_CHOICE=$(echo "$RENAME_CHOICE" | tr 'A-Z' 'a-z')
if [[ "$RENAME_CHOICE" == "y" || "$RENAME_CHOICE" == "yes" ]]; then
    read -rp "Enter the new hostname (e.g., fedora-desktop): " INPUT_HOSTNAME
    NEW_HOSTNAME=$(echo "$INPUT_HOSTNAME" | tr 'A-Z' 'a-z' | tr ' _' '-')
    if [ -z "$NEW_HOSTNAME" ]; then
        echo "Hostname was left blank. Skipping configuration."
    else
        echo "Setting hostname to: $NEW_HOSTNAME"
        sudo hostnamectl set-hostname "$NEW_HOSTNAME"
        echo "Updating /etc/hosts file..."
        sudo bash -c "echo '127.0.0.1 $NEW_HOSTNAME' >> /etc/hosts"
    fi
else
    echo "Skipping hostname configuration, keeping default or current."
fi

sudo dnf config-manager \
    --setopt=max_parallel_downloads=10 \
    --setopt=fastestmirror=True \
    --setopt=defaultyes=True \
    --setopt=ip_resolve=4

sudo dnf upgrade --refresh -y

sudo dnf install -y curl wget git vim fastfetch

DOTFILES_DIR="$HOME/.dotfiles"

# If running for the first time, the script clones itself/the repo into the hidden directory
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning repository to local environment..."
    git clone "https://github.com/th3fishMk/dotfiles.git" "$DOTFILES_DIR"
fi

grep -qF 'source "$HOME/.dotfiles/bash/.bashrc"' "$HOME/.bashrc" || echo '[ -f "$HOME/.dotfiles/bash/.bashrc" ] && source "$HOME/.dotfiles/bash/.bashrc"' >>"$HOME/.bashrc"

# link_config() {
#     local source_file="$1"
#     local target_file="$2"
#     mkdir -p "$(dirname "$target_file")"
#     if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
#         echo "Creating backup: $target_file.bak"
#         mv "$target_file" "$target_file".bak
#     fi
#     ln -sf "$source_file" "$target_file"
# }

# link_config "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
# link_config "$DOTFILES_DIR/bash/.bash-aliases" "$HOME/.bash-aliases"
# link_config "$DOTFILES_DIR/bash/.bash-functions" "$HOME/.bash-functions"
