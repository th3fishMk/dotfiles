#!/usr/bin/env bash

sudo dnf update -y
sudo dnf install akmod-nvidia -y
sudo dnf install xorg-x11-drv-nvidia-cuda -y

modinfo -F version nvidia
