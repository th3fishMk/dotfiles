#!/usr/bin/env bash

sudo dnf install vulkan -y
sudo dnf install xorg-x11-drv-nvidia-cuda-libs -y
# sudo dnf install rpmfusion-nonfree-release-tainted -y
# sudo dnf swap akmod-nvidia akmod-nvidia-open -y
sudo dnf install libva-nvidia-driver libva-utils vdpauinfo -y

sudo dnf4 group install multimedia -y
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf group install -y sound-and-video
sudo dnf install libva-nvidia-driver -y
