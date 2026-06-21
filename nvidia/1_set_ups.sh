#!/bin/bash

# https://rpmfusion.org/Howto/NVIDIA

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf update @core

# actual driver installation

sudo dnf install kmodtool akmods mokutil openssl

sudo kmodgenca -a

sudo mokutil --import /etc/pki/akmods/certs/public_key.der
