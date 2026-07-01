#!/bin/bash
# run this command to fix nvidia-wayland error on tauri apps (and probably some other things)
# cd to the current dir, and then
# run `sh nvidia-fix.sh`

sudo bash -c "echo 'WEBKIT_DISABLE_DMABUF_RENDERER=1' > /etc/environment"
