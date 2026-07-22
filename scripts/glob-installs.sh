#!/bin/bash

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
cargo install create-tauri-app --locked

# Zed Editor
curl -f https://zed.dev/install.sh | sh

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
# Prevent resourcing
\. "$HOME/.nvm/nvm.sh"
nvm install 24

# Installing global stuff
npm install -g pnpm@latest-11
npm install -g typescript

# Brave Browser
curl -fsS https://dl.brave.com/install.sh | sh

echo "Installing flatpaks"
APPS=(
    "cc.arduino.arduinoide"
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
