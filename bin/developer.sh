#!/bin/bash

echo "Today is " "$(date)"
echo "Configuring secure, minimal development environment..."

sudo dnf clean all
sudo dnf -y update

# Enable RPM fusion for clean hardware acceleration codecs
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Install essential dev libs, virtualization, and base system tools
sudo dnf install -y @c-development @virtualization @development-tools \
    mscore-fonts-all gparted gnome-disks fastfetch openssl-devel \
    curl wget file htop tldr jq shellcheck \
    webkit2gtk4.1-devel libappindicator-gtk3-devel librsvg2-devel \
    libxdo-devel golang

# Brave Browser
curl -fsS https://dl.brave.com/install.sh | sh

# Zed Editor
curl -f https://zed.dev/install.sh | sh

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
cargo install create-tauri-app --locked

# Unity
sudo yum update -y
sudo yum install unityhub -y
# vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf install code -y
sudo dnf install dotnet-sdk-10.0 -y

echo -e "\n========================================================="
