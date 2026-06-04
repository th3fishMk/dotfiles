#!/bin/bash

# Ensure script is run as a normal user, not as root directly,
# since we need to accurately target your home directory (~).
if [ "$EUID" -eq 0 ]; then
	echo "Error: Please run this script as your regular user (without sudo)."
	echo "The script will ask for sudo when it needs to remove system packages."
	exit 1
fi

echo "========================================================="
echo "Starting total purge of VS Code and VSCodium from Fedora..."
echo "========================================================="

# ---------------------------------------------------------------------
# 1. REMOVE SYSTEM PACKAGES (DNF / CODIUM REPO)
# ---------------------------------------------------------------------
echo -e "\n--> Uninstalling DNF packages and third-party repositories..."

# Remove binaries
sudo dnf remove -y code code-insiders codium

# Remove Paul Carroty's vscodium repository file if it exists
if [ -f /etc/yum.repos.d/vscodium.repo ]; then
	echo "Removing VSCodium third-party repository file..."
	sudo rm /etc/yum.repos.d/vscodium.repo
fi

# Clean DNF cache to completely clear out metadata
sudo dnf clean all

# ---------------------------------------------------------------------
# 2. REMOVE FLATPAK PACKAGES
# ---------------------------------------------------------------------
echo -e "\n--> Checking for and removing Flatpak installations..."

if command -v flatpak &>/dev/null; then
	# Uninstall apps if they exist
	flatpak uninstall -y com.visualstudio.code 2>/dev/null || true
	flatpak uninstall -y com.vscodium.codium 2>/dev/null || true
	# Remove any leftover unused flatpak runtimes/runtimes cache
	flatpak uninstall --unused -y
else
	echo "Flatpak is not installed, skipping..."
fi

# ---------------------------------------------------------------------
# 3. WIPE ALL USER DATA, CACHES, AND EXTENSIONS (HOME DIR)
# ---------------------------------------------------------------------
echo -e "\n--> Purging all config, cache, and extension directories..."

# Standard VS Code Directories
rm -rf ~/.vscode
rm -rf ~/.config/Code
rm -rf ~/.cache/Code

# VSCodium Directories
rm -rf ~/.vscodium
rm -rf ~/.config/VSCodium
rm -rf ~/.cache/VSCodium

# Flatpak sandboxed data directories
rm -rf ~/.var/app/com.visualstudio.code
rm -rf ~/.var/app/com.vscodium.codium

# ---------------------------------------------------------------------
# 4. FINALIZE
# ---------------------------------------------------------------------
echo -e "\n========================================================="
echo "SUCCESS: VS Code and VSCodium have been totally wiped."
echo "========================================================="
echo "Note: Per-project '.vscode' folders inside your coding project"
echo "directories remain untouched. To find and delete them, run:"
echo "find /path/to/projects -type d -name '.vscode' -exec rm -rf {} +"

# ---------------------------------------------------------------------
# 3. WIPE NODE, NPM, AND NVM DATA
# ---------------------------------------------------------------------
echo -e "\n--> Purging NVM, Node runtimes, and global npm packages..."
rm -rf ~/.nvm
rm -rf ~/.npm
rm -rf ~/.node-gyp

# Strip out the NVM configuration lines from bash/zsh profiles
for profile in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc"; do
	if [ -f "$profile" ]; then
		echo "Removing NVM environment setup lines from $profile..."
		# This filters out the lines containing NVM_DIR or nvm.sh/bash_completion blocks
		sed -i '/NVM_DIR/d' "$profile"
		sed -i '/nvm\.sh/d' "$profile"
		sed -i '/bash_completion/d' "$profile"
	fi
done

# ---------------------------------------------------------------------
# 4. WIPE ALL EDITORS USER DATA AND CACHES
# ---------------------------------------------------------------------
echo -e "\n--> Purging all editor config, cache, and extension directories..."
# VS Code
rm -rf ~/.vscode ~/.config/Code ~/.cache/Code
# VSCodium
rm -rf ~/.vscodium ~/.config/VSCodium ~/.cache/VSCodium
# Flatpak sandboxed data
rm -rf ~/.var/app/com.visualstudio.code ~/.var/app/com.vscodium.codium

# ---------------------------------------------------------------------
# 5. FINALIZE
# ---------------------------------------------------------------------
echo -e "\n========================================================="
echo "SUCCESS: Everything has been totally wiped."
echo "========================================================="
echo "Please close this terminal window or run 'source ~/.bashrc'"
echo "to apply the environment changes to your active shell."
