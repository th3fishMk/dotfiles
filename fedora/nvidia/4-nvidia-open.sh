#!/usr/bin/env bash

sudo dnf install rpmfusion-nonfree-release-tainted -y
sudo dnf swap akmod-nvidia akmod-nvidia-open -y
