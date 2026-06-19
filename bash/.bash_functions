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

# 5. Update dnf and flatpak
sysUp() {
	echo "=== Starting System Update ==="

	echo "--- Checking DNF Packages ---"
	sudo dnf upgrade -y
	echo "+++ DNF update complete"

	if command -v flatpak &>/dev/null; then
		echo "--- Checking Flatpak Packages ---"
		flatpak update -y
		echo "+++ Flatpak update complete"
	fi

	echo "=== All updates finished successfully ==="
}

# removes all subdir in a file, moves the file and delete empty folders
remove_subfolder() {
	# Default to the current directory if no argument is provided
	local TARGET_DIR="${1:-.}"

	# Ensure the provided path is a valid directory
	if [ ! -d "$TARGET_DIR" ]; then
		echo "Error: '$TARGET_DIR' is not a valid directory." >&2
		return 1
	fi

	# Convert TARGET_DIR to an absolute or clean path to prevent path resolution bugs
	local BASE_DIR
	BASE_DIR=$(cd "$TARGET_DIR" && pwd)

	echo "Flattening directory: $BASE_DIR"
	echo "--------------------------------"

	# Counters for the final round-up report
	local renamed_count=0
	local skipped_count=0

	# 1. Move and rename files from subdirectories
	# Using process substitution '< <(...)' at the bottom fixes the subshell counter trap
	while IFS= read -r -d '' file; do
		# Get the full directory of the file and the filename itself
		local file_dir=$(dirname "$file")
		local base_name=$(basename "$file")

		# Extract the relative path from the BASE_DIR to the file's directory
		local rel_path="${file_dir#$BASE_DIR/}"

		# Replace all slashes '/' in the relative path with '='
		local prefix="${rel_path//\//=}"

		# Construct the final new filename and destination path
		local new_name="${prefix}=${base_name}"
		local dest_file="$BASE_DIR/$new_name"

		# Safe move: Check if the target file already exists
		if [ -e "$dest_file" ]; then
			echo "[SKIPPED]  '$base_name' (Target '$new_name' already exists)"
			((skipped_count++))
		else
			mv "$file" "$dest_file"
			echo "[RENAMED]  $rel_path/$base_name -> $new_name"
			((renamed_count++))
		fi
	done < <(find "$BASE_DIR" -mindepth 2 -type f -print0)

	# 2. Clean up empty subdirectories
	echo "--------------------------------"
	echo "Cleaning up empty subdirectories..."

	# Track how many directories are deleted
	local deleted_dirs_count=0
	while IFS= read -r -d '' empty_dir; do
		if rm -rf "$empty_dir" 2>/dev/null; then
			((deleted_dirs_count++))
		fi
	done < <(find "$BASE_DIR" -mindepth 1 -type d -empty -print0)

	# Clean summary report at the end
	echo "--------------------------------"
	echo "Done! Summary: Flattened $renamed_count files, skipped $skipped_count files, and deleted $deleted_dirs_count empty directories."
}

# Remove invalid characters in files (except for =)
clean_filename_chars() {
	# Default to the current directory if no argument is provided
	local TARGET_DIR="${1:-.}"

	# Ensure the provided path is a valid directory
	if [ ! -d "$TARGET_DIR" ]; then
		echo "Error: '$TARGET_DIR' is not a valid directory." >&2
		return 1
	fi

	echo "Cleaning filename characters recursively in: $TARGET_DIR"
	echo "------------------------------------------------"

	# Counters for the final round-up report
	local renamed_count=0
	local skipped_count=0
	local no_change_count=0

	# -depth ensures we rename files/folders from the inside out
	# -type f ensures we only rename files
	while IFS= read -r -d '' item; do
		# Skip the root target directory itself
		if [ "$item" = "$TARGET_DIR" ]; then
			continue
		fi

		local dir=$(dirname "$item")
		local base=$(basename "$item")

		# Strip any character that is NOT: a-z, A-Z, 0-9, _, =, ., or -
		# Spaces are stripped now too!
		local clean_base=$(echo -n "$base" | sed 's/[^a-zA-Z0-9_=.-]//g')

		# Check if changes are needed
		if [ "$base" != "$clean_base" ]; then
			local new_item="$dir/$clean_base"

			if [ -e "$new_item" ]; then
				echo "[SKIPPED]   '$base' -> '$clean_base' (Target already exists)"
				((skipped_count++))
			else
				mv "$item" "$new_item"
				echo "[RENAMED]   '$base' -> '$clean_base'"
				((renamed_count++))
			fi
		else
			echo "[NO CHANGE] '$base'"
			((no_change_count++))
		fi
	done < <(find "$TARGET_DIR" -depth -type f -print0)

	# Clean summary report at the end
	echo "------------------------------------------------"
	echo "Done! Summary: Renamed $renamed_count files, skipped $skipped_count files, and left $no_change_count files unchanged."
}

# Rename files in a very specific way
special_rename() {
	# Default to the current directory if no argument is provided
	local TARGET_DIR="${1:-.}"

	# Ensure the provided path is a valid directory
	if [ ! -d "$TARGET_DIR" ]; then
		echo "Error: '$TARGET_DIR' is not a valid directory." >&2
		return 1
	fi

	echo "Sequencing files in: $TARGET_DIR"
	echo "--------------------------------"

	# Declare an associative array to track independent counters for each prefix group
	declare -A counters

	local renamed_count=0
	local skipped_count=0
	local no_change_count=0

	# Process files inside the target directory that contain at least one '='
	# We use process substitution '< <(...)' at the end to avoid the subshell loop trap
	while IFS= read -r -d '' file; do
		local dir=$(dirname "$file")
		local base=$(basename "$file")

		# Extract the extension and convert to lowercase for matching
		local extension="${base##*.}"
		local ext_lower
		ext_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

		# Get everything to the left of the LAST '=', including the '='
		local prefix="${base%=[^=]*}="

		# Determine the target category string based on the extension
		local category="file"
		case "$ext_lower" in
		pdf | doc | docx | odt | rtf | txt | tex | epub)
			category="document"
			;;
		png | jpg | jpeg | gif | bmp | svg | webp | tiff)
			category="image"
			;;
		mp4 | mkv | avi | mov | wmv | flv | webm)
			category="video"
			;;
		mp3 | wav | flac | m4a | ogg | wma)
			category="audio"
			;;
		*)
			category="file"
			;;
		esac

		# Initialize the counter for this unique prefix group if it doesn't exist
		if [ -z "${counters[$prefix]}" ]; then
			counters[$prefix]=0
		fi

		# Format the counter to 4 digits (e.g., 0000, 0001)
		local current_count=$(printf "%04d" "${counters[$prefix]}")

		# Construct the final name: everything up to the last '=' + category + counter + extension
		local new_base="${prefix}${category}${current_count}.${extension}"
		local new_file="$dir/$new_base"

		# Execute rename and log metrics
		if [ "$base" != "$new_base" ]; then
			if [ -e "$new_file" ]; then
				echo "[SKIPPED]  '$base' -> '$new_base' (Target already exists)"
				((skipped_count++))
			else
				mv "$file" "$new_file"
				echo "[RENAMED]  '$base' -> '$new_base'"
				((renamed_count++))
			fi
		else
			echo "[NO CHANGE] '$base'"
			((no_change_count++))
		fi

		# Increment counter for this specific prefix group
		((counters[$prefix]++))
	done < <(find "$TARGET_DIR" -maxdepth 1 -type f -name "*=*" -print0)

	# Clean summary report
	echo "--------------------------------"
	echo "Done! Summary: Renamed $renamed_count files, skipped $skipped_count files, and left $no_change_count files unchanged."
}
gather_files_by_ext() {
	# 1. Validate that all 3 parameters are passed
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
		echo "Error: Missing arguments." >&2
		echo "Usage: gather_files_by_ext <source_dir> <extension> <dest_dir>" >&2
		return 1
	fi

	local SRC_DIR="$1"
	local EXT="$2"
	local DEST_DIR="$3"

	# 2. Validate source directory existence
	if [ ! -d "$SRC_DIR" ]; then
		echo "Error: Source path '$SRC_DIR' is not a valid directory." >&2
		return 1
	fi

	# Strip a leading dot from the extension if the user typed ".jpg" instead of "jpg"
	EXT="${EXT#.}"

	echo "Gathering all '*.$EXT' files from '$SRC_DIR' into '$DEST_DIR'..."
	echo "------------------------------------------------"

	# Initialize metric counters
	local scanned_dirs=0
	local scanned_subdirs=0
	local moved_files=0
	local skipped_files=0

	# 3. Handle destination directory creation/validation safely inside the loop logic
	# We do a lazy creation right before moving the first file, or explicitly here:
	if [ ! -d "$DEST_DIR" ]; then
		if mkdir -p "$DEST_DIR" 2>/dev/null; then
			echo "[INFO] Created destination directory: '$DEST_DIR'"
		else
			echo "Error: Failed to create destination directory '$DEST_DIR'." >&2
			return 1
		fi
	fi

	# Convert paths to absolute to prevent path-matching confusion during recursion
	local ABS_SRC=$(cd "$SRC_DIR" && pwd)
	local ABS_DEST=$(cd "$DEST_DIR" && pwd)

	# Count source directories first
	# Total directories minus 1 (the root itself) gives us the subdirectories count
	local total_dirs=$(find "$ABS_SRC" -type d | wc -l)
	if [ "$total_dirs" -gt 0 ]; then
		scanned_dirs=1
		scanned_subdirs=$((total_dirs - 1))
	fi

	# Loop through all files matching the target extension recursively
	while IFS= read -r -d '' file; do
		local base_name=$(basename "$file")
		local target_dest="$ABS_DEST/$base_name"

		# Prevent a file from moving into itself if destination is inside source
		if [ "$file" = "$target_dest" ]; then
			echo "[SKIPPED]  '$base_name' (File is already at the destination)"
			((skipped_files++))
			continue
		fi

		# Execute safe move
		if [ -e "$target_dest" ]; then
			echo "[SKIPPED]  '$base_name' (Target already exists in destination folder)"
			((skipped_files++))
		else
			mv "$file" "$target_dest"
			echo "[MOVED]    '$file' -> '$target_dest'"
			((moved_files++))
		fi

	done < <(find "$ABS_SRC" -type f -name "*.$EXT" -print0)

	# Clean summary report
	echo "------------------------------------------------"
	echo "Done! Summary:"
	echo "  - Scanned Root Dir: $scanned_dirs"
	echo "  - Scanned Sub-Dirs: $scanned_subdirs"
	echo "  - Moved Files:      $moved_files"
	if [ "$skipped_files" -gt 0 ]; then
		echo "  - Skipped Files:    $skipped_files"
	fi
}
