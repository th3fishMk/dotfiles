#!/bin/bash

sudo dnf update -y
sudo dnf install akmod-nvidia
sudo dnf install xorg-x11-drv-nvidia-cuda

modinfo -F version nvidia
