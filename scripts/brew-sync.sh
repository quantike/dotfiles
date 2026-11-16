#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"

echo "Checking Brewfile dependencies..."

# Check if all dependencies are installed
if ! brew bundle check --file "$BREWFILE" --quiet; then
    echo "Missing dependencies found. Installing..."
    brew bundle install --file "$BREWFILE"
    echo "All dependencies installed"
else
    echo "All dependencies up to date"
fi

# Update Brewfile with any new packages
echo "Updating Brewfile..."
brew bundle dump --force --file "$BREWFILE" --describe
echo "Brewfile updated"