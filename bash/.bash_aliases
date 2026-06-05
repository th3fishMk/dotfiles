# shellcheck disable=SC2148
# System Management
alias reSource="source ~/.bashrc"
alias ll="ls -la --color=auto"

alias g="git"
alias dotfiles-update="cd \$HOME/.dotfiles && git pull && cd -"
alias dotfiles-update-force="cd \$HOME/.dotfiles && git fetch --all && git reset --hard origin/trunk && cd -"
alias dotfiles-cd="cd \$HOME/.dotfiles"

sysUp() {
	echo "=== Starting System Update ==="

	echo "--- Checking DNF Packages ---"
	sudo dnf upgrade --refresh -y
	echo "+++ DNF update complete"

	if command -v flatpak &>/dev/null; then
		echo "--- Checking Flatpak Packages ---"
		flatpak update -y
		echo "+++ Flatpak update complete"
	fi

	echo "--- Cleaning Up System Tmp/Cache ---"
	sudo dnf autoremove -y

	echo "=== All updates finished successfully ==="
}
