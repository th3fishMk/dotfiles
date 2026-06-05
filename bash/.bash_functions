# shellcheck disable=SC2148
# ====================================================================
# Custom Shell Functions (Loaded into RAM on startup)
# ====================================================================

# 1. System Maintenance & Cleanup Utilities
clean_system() {
	echo "Cleaning journal logs..."
	sudo journalctl --vacuum-time=3d
	echo "Cleaning package cache..."
	sudo dnf clean all
}

# 2. Text/File Search Helpers
find_text() {
	if [ -z "$1" ]; then
		echo "Usage: find_text <string_to_search>"
		return 1
	fi
	grep -rnw '.' -e "$1"
}

# 3. Network & Connectivity Diagnostics
my_ip() {
	echo "Local IP:"
	hostname -I | awk '{print $1}'
	echo "Public IP:"
	curl -s https://ifconfig.me
	echo ""
}

# 4. Git Automation Scripts
quick_commit() {
	local message="${1:-Auto-commit update}"
	git add .
	git commit -m "$message"
	git push
}
