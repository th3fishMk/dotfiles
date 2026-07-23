#!/bin/bash
set -euo pipefail

# Detect WSL environment
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    IS_WSL=true
    echo "=== Running in WSL environment ==="
else
    echo "=== Running in Bare-Metal environment ==="
fi

# Common base system updates & setup
sudo apt update && sudo apt upgrade -y
sudo mkdir -p /etc/apt/keyrings

# Base CLI development tools (Safe for both WSL & Bare-Metal)
echo "--- Installing CLI Development Tools ---"
sudo apt install -y \
    build-essential \
    golang-go \
    shfmt \
    curl \
    wget \
    git \
    vim \
    fastfetch \
    ca-certificates \
    file \
    libssl-dev \
    shellcheck

# Docker installation (Essential for both, though Desktop integration works via CLI in WSL)
echo "--- Setting up Docker Repository ---"
sudo apt remove -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc 2>/dev/null || true

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# BARE-METAL ONLY Section (Desktop GUI Apps & Flatpak)
if [ "$IS_WSL" = false ]; then
    echo "--- Bare-Metal Detected: Installing Desktop GUI packages & Flatpak ---"

    sudo apt install -y \
        flatpak \
        discord \
        libwebkit2gtk-4.1-dev \
        libxdo-dev \
        libayatana-appindicator3-dev \
        librsvg2-dev

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
else
    echo "--- WSL Detected: Skipping Flatpak, Discord, and Tauri GUI dependencies ---"
fi

echo "=== Installation finished successfully ==="
