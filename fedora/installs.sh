#!/bin/bash
echo "Installing dev things"

sudo dnf -y update

# Enable RPM fusion for clean hardware acceleration codecs
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Install essential dev libs, virtualization, and base system tools
sudo dnf install -y \
    @c-development \
    @virtualization \
    @development-tools \
    gparted \
    gnome-disks \
    fastfetch \
    curl \
    wget \
    htop \
    tldr \
    jq \
    shellcheck \
    webkit2gtk4.1-devel \
    golang \
    shfmt \
    steam \
    meld \
    obs-studio \
    obs-studio-plugin-x264 \
    obs-studio-plugin-distroav \
    syncthing \
    discord

sudo systemctl enable --now syncthing@USER.service

# Tauri-specific
sudo dnf install webkit2gtk4.1-devel \
    openssl-devel \
    file \
    libappindicator-gtk3-devel \
    librsvg2-devel \
    libxdo-devel

# vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
sudo dnf install code -y

# Codium
sudo tee -a /etc/yum.repos.d/vscodium.repo <<'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
sudo dnf install codium -y

sudo dnf remove libreoffice*
# syncthing service

sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo dnf remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine

sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
