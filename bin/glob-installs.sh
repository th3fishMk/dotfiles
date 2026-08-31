#!/usr/bin/env bash

# Detect WSL environment
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
    IS_WSL=true
    echo "=== Running in WSL environment ==="
else
    echo "=== Running in Bare-Metal environment ==="
fi

echo "--- Installing Rust & Tauri CLI ---"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "--- Installing NVM, Node.js, and Global Packages ---"
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 24
npm install -g pnpm@latest-11 typescript

# BARE-METAL ONLY SECTION
if [ "$IS_WSL" = false ]; then
    echo "--- Bare-Metal Detected: Installing GUI Apps & Flatpaks ---"

    echo "--> Installing Zed Editor"
    curl -f https://zed.dev/install.sh | sh

    echo "--> Installing Brave Browser"
    curl -fsS https://dl.brave.com/install.sh | sh

    echo "--> Installing Flatpak Packages"
    APPS=(
        "com.belmoussaoui.Authenticator"
        "com.github.huluti.Coulr"
        "com.google.Chrome"
        "io.github.nate_xyz.Paleta"
        "io.github.nokse22.asciidraw"
        "io.github.nokse22.Exhibit"
        "io.github.nokse22.minitext"
        "org.chromium.Chromium"
        "org.inkscape.Inkscape"
        "org.kde.haruna"
        "org.kde.krita"
        "org.onlyoffice.desktopeditors"
        "page.codeberg.impromptux.ytdl-gui"
    )

    for APP in "${APPS[@]}"; do
        echo -e "\n--> Installing: $APP"
        flatpak install -y flathub "$APP"
    done

    flatpak uninstall --unused -y
else
    echo "--- WSL Detected: Skipping Zed Editor, Brave Browser, and Flatpak installations ---"
fi
