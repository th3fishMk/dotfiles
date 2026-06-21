#!/bin/bash

sudo dnf install vulkan
sudo dnf install xorg-x11-drv-nvidia-cuda-libs
# sudo dnf install rpmfusion-nonfree-release-tainted
# sudo dnf swap akmod-nvidia akmod-nvidia-open
sudo dnf install libva-nvidia-driver libva-utils vdpauinfo

sudo dnf4 group install multimedia
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf group install -y sound-and-video
sudo dnf install libva-nvidia-driver
