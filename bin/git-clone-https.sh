#!/bin/bash
# Usage: ./clone_all_repos.sh <github-username> <destination-dir>
# Clones all the repos (up to 1000) from one github user, or organization
# Into a specific dir, using HTTPS

USER=${1:?Please provide a GitHub username}
DEST=${2:?Please provide a destination directory}

mkdir -p "$DEST"

# Fetch all repository HTTPS URLs of the user
repos=$(gh repo list "$USER" --limit 1000 --json name,url -q '.[].url')

if [ -z "$repos" ]; then
    echo "No repositories found for user: $USER"
    exit 1
fi

echo "Cloning repositories of $USER into $DEST"

# Loop through URLs and clone
for repo_url in $repos; do
    git clone "$repo_url" "$DEST/$(basename "$repo_url" .git)"
done
