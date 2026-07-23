#!/usr/bin/env bash

set -e

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

# Ensure git is installed before proceeding
if ! command -v git &>/dev/null; then
    echo "Git not found. Installing Git..."
    if command -v dnf &>/dev/null; then
        sudo dnf install -y git
    elif command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y git
    else
        echo "Error: Neither dnf nor apt package manager was found to install Git." >&2
        exit 1
    fi
fi

DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning repository to local environment..."
    git clone "https://github.com/th3fishMk/dotfiles.git" "$DOTFILES_DIR"
fi

grep -qF 'source "$HOME/.dotfiles/bash/.bashrc"' "$HOME/.bashrc" || echo '[ -f "$HOME/.dotfiles/bash/.bashrc" ] && source "$HOME/.dotfiles/bash/.bashrc"' >>"$HOME/.bashrc"

echo "Figuring out which install script to run"
if command -v dnf &>/dev/null; then
    INSTALL_SCRIPT="$DOTFILES_DIR/fedora/installs.sh"
elif command -v apt &>/dev/null; then
    INSTALL_SCRIPT="$DOTFILES_DIR/ubuntu/installs.sh"
else
    echo "Error: Unable to detect supported package manager (dnf/apt)." >&2
    exit 1
fi

if [ -f "$INSTALL_SCRIPT" ]; then
    echo "Running installation script: $INSTALL_SCRIPT"
    bash "$INSTALL_SCRIPT"
else
    echo "Error: Installation script not found at $INSTALL_SCRIPT" >&2
    exit 1
fi

glob_installs="$DOTFILES_DIR/bin/glob-installs.sh"
if [ -f "$glob_installs" ]; then
    echo "Executing: $glob_installs"
    bash "$glob_installs"
else
    echo "Error: glob script not found at: $glob_installs" >&2
    exit 1
fi

echo "Finished successfully"
