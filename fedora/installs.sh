#!/usr/bin/env bash
set -e

echo "Installing custom fedora tools..."

echo "Optimizing DNF"
sudo dnf config-manager setopt \
    max_parallel_downloads=10 \
    fastestmirror=True \
    defaultyes=True \
    ip_resolve=4

echo "Updating the system..."
sudo dnf upgrade --refresh -y

echo "Enabling RPM Fusion and Codecs"
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

echo "Installing fonts"
sudo dnf install google-noto-fonts-all
# 😀 😁 😂 🤣 😊 😇 🙂 😉 😌 😍 😘 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥰 😂 🤔 🤭 🤫 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🤗 🤔 🤐 🤨 😬 🙄 😯 😮 😲 🥱 😴 🤤 😪 😵 🤫 🤧 🥴 🤢 🤮 🤧 😷 🤒 🤕 👋 🤚 🖐️ ✋ 🖖 👌 🤏 ✌️ 🤞 🤟 🤘 🤙 👈 👉 👆 🖕 👇 ☝️ 👍 👎 ✊ 👊 🤛 🤜 👏 🙌 👐 🤲 🙏 💪 🦾 🦵 🦶 👂 👃 👀 👁️ 👄 🧠 🫀 🫁 🦷 🦴 👶 👦 👧 👨 👩 🧓 👴 👵 🙍 🙎 🙅 🙆 💁 🙋 🧏 🙇 🤦 🤷 👮 🕵️ 💂 🥷 👷 🤴 👸 👰 🤵 👼 🎅 🤶 🦸 🦹 🧛 🧞 🧟 💀 🧌 👻 🧑‍⚕️ 🧑‍🎓 🧑‍🏫 🧑‍⚖️ 🧑‍🌾 🧑‍🍳 🧑‍🔧 🧑‍🏭 🧑‍💼 🧑‍🔬 🧑‍💻 🧑‍🎤 🧑‍🎨 🧑‍✈️ 🧑‍🚀 🧑‍🚒 🧑‍⚕️ 👩‍🍼 👨‍🍼 🤱 👩‍🍼 👨‍🍼 👩‍👦 👩‍👧 👨‍👦 👨‍👧 👩‍👧‍👦 👨‍👧‍👦 👩‍👨‍👦 👨‍👨‍👦 👩‍👩‍👦 👩‍👨‍👧 👨‍👨‍👧 👩‍👩‍👧 👩‍👨‍👧‍👦 👨‍👨‍👧‍👦 👩‍👩‍👧‍👦 👩‍👩‍👦‍👦 👨‍👨‍👦‍👦 👩‍👩‍👧‍👧 👨‍👨‍👧‍👧 👩‍👦 👨‍👦 👩‍👧 👨‍👧 💏 💑 👬 👭 ❤️ 🧡 💛 💚 💙 💜 🖤 🤍 🤎 💔 ❣️ 💕 💞 💓 💗 💖 💘 💝 💟 ☮️ ✝️ ☦️ ☪️ 🕉️ ☸️ ✡️ 🕎 🔯 ☯️ ☬ 📿 🛐 ⚛️ 🛕 🕋 ⛩️ 🛤️ 🛣️ 🗺️ 🗾 🏞️ 🌋 ⛰️ 🌋 🐶 🐱 🐭 🐹 🐰 🦊 🐻 🐼 🐻‍❄️ 🐨 🐯 🦁 🐮 🐷 🐸 🐵 🐔 🐧 🐦 🐤 🦆 🦅 🦉 🦇 🐺 🐗 🐴 🦄 🐝 🐛 🦋 🐌 🐞 🐜 🪲 🦟 🦗 🕷️ 🕸️ 🦂 🐢 🐍 🦎 🦖 🦕 🐙 🦑 🦐 🦞 🦀 🐡 🐠 🐟 🐬 🐳 🐋 🦈 🐊 🐅 🐆 🦓 🦍 🦧 🦣 🐘 🦛 🦏 🐪 🐫 🦒 🦘 🦬 🐃 🐂 🐄 🐎 🐖 🐏 🐑 🐐 🦌 🐕 🐩 🐈 🐈‍⬛ 🐓 🦃 🦤 🦚 🦜 🦢 🦩 🕊️ 🐇 🦝 🦨 🦡 🦫 🦦 🦥 🐁 🐀 🐿️ 🦔 🌵 🎄 🌲 🌳 🌴 🌱 🌿 ☘️ 🍀 🎍 🪴 🎋 🍃 🍂 🍁 🍄 🌾 💐 🌷 🌹 🥀 🌺 🌸 🌼 🌻 🌞 🌝 🌛 🌜 🌚 🌕 🌖 🌗 🌘 🌑 🌒 🌓 🌔 🌙 🌎 🌍 🌏 💫 ⭐️ 🌟 ✨ ⚡️ ☄️ 💥 🔥 🌈 ☀️ 🌤️ ⛅️ 🌥️ ☁️ 🌦️ 🌧️ ⛈️ 🌩️ 🌨️ ❄️ ☃️ ⛄️ 🌬️ 💨 🌪️ 🌫️ 🌁 💧 💦 🫧 🌊 ☔️ 🌂 🏕️ 🏠 🏡 🏢 🏣 🏤 🏥 🏦 🏨 🏩 💒 🏪 🏫 🏬 🏭 🏯 🏰 💒 🗼 🗽 🗿 🗽 🎠 🎡 🎢 💈 🎪 🚂 🚃 🚄 🚅 🚆 🚇 🚈 🚉 🚊 🚝 🚞 🚋 🚌 🚍 🚎 🚐 🚑 🚒 🚓 🚔 🚕 🚖 🚗 🚘 🚙 🚚 🚛 🚜 🛴 🚲 🛵 🏍️ 🛺 🚨 🚔 🚑 🚒 🚐 🚓 🛞 🚦 🚥 🛣️ 🛤️ 🛢️ ⛽ 🚧 🚏 ⚓ 🚤 🛥️ 🛳️ ⛴️ 🚢 ⛵ 🛶 🚁 🛩️ ✈️ 🛫 🛬 🛸 🚀 🛶 ⛵ 🚀 🛸 🎈 🎏 🎀 🎁 🎊 🎉 🎎 🏮 🎐 🎌 🏴 🏳️ 🏁 🚩 🎌

# Install essential dev libs, virtualization, and base system tools
echo "Installing base tools via dnf"
sudo dnf install -y \
    @c-development \
    @development-tools \
    @virtualization \
    curl \
    discord \
    fastfetch \
    flatpak \
    git \
    gnome-disks \
    golang \
    gparted \
    htop \
    jq \
    meld \
    obs-studio \
    obs-studio-plugin-distroav \
    obs-studio-plugin-x264 \
    shellcheck \
    shfmt \
    steam \
    syncthing \
    tldr \
    vim \
    wget

echo "Installing tauri dependencies"
sudo dnf install -y \
    webkit2gtk4.1-devel \
    openssl-devel \
    file \
    libappindicator-gtk3-devel \
    librsvg2-devel \
    libxdo-devel

echo "Enabling system services"
# sudo systemctl enable --now syncthing@USER.service
systemctl --user enable --now syncthing.service
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Performing some necessary clean up"
sudo dnf remove -y docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine \
    libreoffice*

echo "Installing docker"
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo -y
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
