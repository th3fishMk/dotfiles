#!/usr/bin/env bash

set -e

echo "===================================================="
echo "Starting Fedora System Deployment"
echo "===================================================="

# 1. Optimize Package Manager
echo "Optimizing DNF configuration..."
sudo bash -c 'cat << EOF >> /etc/dnf/dnf.conf
max_parallel_downloads=10
fastestmirror=True
defaultyes=True
EOF'

# 2. System Upgrade
echo "Upgrading system packages..."
sudo dnf upgrade --refresh -y

# 3. Base Utilities
echo "Installing core utilities..."
sudo dnf install -y curl wget git vim fastfetch

# 4. Dotfiles Automation
DOTFILES_DIR="$HOME/.dotfiles"
echo "Deploying system configuration files..."

# If running for the first time, the script clones itself/the repo into the hidden directory
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning repository to local environment..."
    git clone "https://github.com/th3fishMk/dotfiles.git" "$DOTFILES_DIR"
fi

# Link deployment helper function
link_config() {
    local source_file="$1"
    local target_file="$2"

    mkdir -p "$(dirname "$target_file")"

    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "Creating backup: $target_file.bak"
        mv "$target_file" "$target_file".bak
    fi

    echo "Linking: $target_file -> $source_file"
    ln -sf "$source_file" "$target_file"
}

# Safely deploy the new bash environment
link_config "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link_config "$DOTFILES_DIR/bash/.bash-aliases" "$HOME/.bash-aliases"
link_config "$DOTFILES_DIR/bash/.bash-functions" "$HOME/.bash-functions"

# 5. Rename the Hostname
echo "Configuring system name..."

# Initialize choice variable
RENAME_CHOICE=""

# Ask user if they want to rename the machine
read -rp "Do you want to rename this computer? (y/N): " RENAME_CHOICE

# Convert input to lowercase to handle 'Y' or 'y'
RENAME_CHOICE=$(echo "$RENAME_CHOICE" | tr 'A-Z' 'a-z')

# Check if the user explicitly said yes
if [[ "$RENAME_CHOICE" == "y" || "$RENAME_CHOICE" == "yes" ]]; then

    # Prompt for the actual name
    read -rp "Enter the new hostname (e.g., fedora-desktop): " INPUT_HOSTNAME

    # Clean up input: lowercase and swap spaces/underscores for hyphens
    NEW_HOSTNAME=$(echo "$INPUT_HOSTNAME" | tr 'A-Z' 'a-z' | tr ' _' '-')

    # If they answered yes but left the name blank, skip safely
    if [ -z "$NEW_HOSTNAME" ]; then
        echo "Hostname was left blank. Skipping configuration."
    else
        echo "Setting hostname to: $NEW_HOSTNAME"
        sudo hostnamectl set-hostname "$NEW_HOSTNAME"

        # Safely append to /etc/hosts without complex quoting
        echo "Updating /etc/hosts file..."
        sudo bash -c "echo '127.0.0.1 $NEW_HOSTNAME' >> /etc/hosts"
    fi
else
    echo "Skipping hostname configuration, keeping default or current."
fi

echo "===================================================="
echo "System deployment finished successfully."
echo "===================================================="
