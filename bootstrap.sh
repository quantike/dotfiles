#!/bin/bash
set -euo pipefail

echo "Setting up your Mac "

# Check for Oh My Zsh and install it if we don't have it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "→ Installing Oh My Zsh…"
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
else
	echo "→ ~/.oh-my-zsh already exists, skipping Oh My Zsh install."
fi

# Check for Homebrew and install it if we don't have it
if ! command -v brew >/dev/null 2>&1; then
	echo "→ Installing Homebrew…"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# On Apple Silicon, brew typically ends up in /opt/homebrew/bin/brew
	# Make sure the shellenv is in ~/.zprofile so future shells load it.
	echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>"$HOME/.zprofile"
	eval "$($(brew --prefix)/bin/brew shellenv)"
else
	echo "→ Homebrew already installed, skipping."
fi

# Determine where brew is installed, then export PATH so we can call brew
if [ -x "/opt/homebrew/bin/brew" ]; then
	BREW_BIN="/opt/homebrew/bin/brew"
elif [ -x "/usr/local/bin/brew" ]; then
	BREW_BIN="/usr/local/bin/brew"
else
	echo "‼️ Error: Homebrew binary not found after install."
	exit 1
fi

# Make sure future interactive shells load brew’s environment too
echo "→ Adding Homebrew to ~/.zprofile"
echo "eval \"\$($BREW_BIN shellenv)\"" >>"$HOME/.zprofile"

# Export into the current session so 'brew' works in the rest of this script
eval "$($BREW_BIN shellenv)"

echo "→ Homebrew is at: $BREW_BIN"
echo "→ Testing: $(which brew)"

# Symlinks the .zshrc to the .dotfiles
DOTFILES_ZSH="$HOME/.dotfiles/.zshrc"
TARGET_ZSH="$HOME/.zshrc"

if [ -e "$TARGET_ZSH" ] && [ ! -L "$TARGET_ZSH" ]; then
	echo "→ Backing up existing ~/.zshrc to ~/.zshrc.backup"
	mv "$TARGET_ZSH" "$HOME/.zshrc.backup"
fi

echo "→ Creating symlink: $TARGET_ZSH → $DOTFILES_ZSH"
ln -fs "$DOTFILES_ZSH" "$TARGET_ZSH"

# Symlink ZSH custom files into $ZSH_CUSTOM
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
for f in "$HOME/.dotfiles/zsh/"*.zsh; do
	target="$ZSH_CUSTOM/$(basename "$f")"
	echo "→ Creating symlink: $target → $f"
	ln -fs "$f" "$target"
done

# Update Homebrew recipes
echo "→ Updating Homebrew…"
brew update

# Install all our dependencies with bundle (See Brewfile)
BREWFILE="$(cd "$(dirname "$0")" && pwd)/Brewfile"
if [ -f "$BREWFILE" ]; then
	echo "→ Running Brewfile: $BREWFILE"
	brew bundle --file "$BREWFILE"
else
	echo "⚠️  Warning: No Brewfile found at $BREWFILE. Skipping brew bundle."
fi

# Create a projects directories
echo "→ Ensuring ~/Developer exists…"
mkdir -p "$HOME/Developer"

# Install some of the manual things here
#
# Atuin
if ! command -v atuin >/dev/null 2>&1; then
	echo "→ Installing Atuin (ZSH history replacement)…"
	curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
	echo "→ Atuin already installed, skipping."
fi

# uv
if ! command -v uv >/dev/null 2>&1; then
	echo "→ Installing uv (https://astral.sh/uv)…"
	curl -LsSf https://astral.sh/uv/install.sh | sh
else
	echo "→ uv already installed, skipping."
fi

# Run this last to source ZSH changes and reload the shell
echo "→ Sourcing ~/.zshrc"
# We use `exec "$SHELL"` at the end so that the rest of the script’s environment
# isn’t inadvertently changed in the parent shell. But if you really want to
# source here:
source "$HOME/.zshrc"

echo "✅  Bootstrap complete!"
