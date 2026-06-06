#!/bin/bash

echo "Today is $(date)"
echo "Configuring your personal desktop applications..."

echo -e "\n--> Verifying Flatpak and adding Flathub repository..."
sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo -e "\n--> Installing native multimedia codecs and host system apps..."

# Enable RPM Fusion if not already done (required for clean, hardware-accelerated media)
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf install -y steam meld obs-studio obs-studio-plugin-x264 obs-studio-plugin-distroav

echo "Installing flatpaks"

APPS=(
	"org.onlyoffice.desktopeditors"
	"com.belmoussaoui.Authenticator"
	"com.belmoussaoui.Decoder"
	"io.gitlab.librewolf-community"
	"org.chromium.Chromium"
	"org.inkscape.Inkscape"
	"org.kde.haruna"
	"org.kde.krita"
	"com.discordapp.Discord"
	"org.jousse.vincent.Pomodorolm"
	"io.github.peazip.PeaZip"
	"com.bitwarden.desktop"
	"org.audacityteam.Audacity"
	"se.sjoerd.Graphs"
	"com.google.Chrome"
	"page.codeberg.impromptux.ytdl-gui"
	"cz.ondrejkolin.Barcoder"
	"dev.lasheen.qr"
	"io.github.fkinoshita.Telegraph"
	"com.oyajun.ColorCode"
	"com.rafaelmardojai.Blanket"
	"page.codeberg.lo_vely.Nucleus"
	"org.blender.Blender"
	"org.gimp.GIMP"
	"org.shotcut.Shotcut"
	"org.kde.kdenlive"
	"org.darktable.Darktable"
	"org.mixxx.Mixxx"
	"org.upscayl.Upscayl"
	"net.blockbench.Blockbench"
	"org.octave.Octave"
	# "com.obsproject.Studio" # swapped for system install
)

for APP in "${APPS[@]}"; do
	echo -e "\n--> Installing: $APP"
	flatpak install -y flathub "$APP"
done

echo -e "\n--> Cleaning package footprints and verifying structural integrity..."
sudo dnf clean all
flatpak uninstall --unused -y
echo -e "\n========================================================="
