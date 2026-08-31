#!/usr/bin/env bash

# run this command to fix nvidia-wayland error on tauri apps (and probably some other things)

sudo bash -c "echo 'WEBKIT_DISABLE_DMABUF_RENDERER=1' > /etc/environment"
