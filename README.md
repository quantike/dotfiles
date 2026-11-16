# dotfiles

Ike's dotfiles.

## Getting started

```sh
# clone to ~/.dotfiles repo
git clone https://github.com/quantike/dotfiles ~/.dotfiles
```

The remote uses the SSH host alias `github-quantike`, so add it to `~/.ssh/config` first:

```
Host github-quantike
    HostName github.com
    User git
    IdentityFile ~/.ssh/<your-key>
```

Then run the bootstrap script, which will need to be run more than once because I suck at bash.

```sh
sh bootstrap.sh
```

> Keep an eye out for input prompts. The script asks for a git identity
> (`work` or `personal`) and symlinks `~/.gitconfig.identity` to the matching
> `gitconfig-*` file. Preselect it for unattended runs with
> `DOTFILES_IDENTITY=work sh bootstrap.sh`.

The bootstrap script symlinks `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig`, the
files in `zsh/`, and every tracked config in `CONFIG_DIRS` (atuin, bottom,
direnv, ghostty, htop, k9s, neofetch, nvim, thefuck, opencode) into `~/.config`.

## Setting up Neovim

`bootstrap.sh` already symlinks `~/.config/nvim` into this repo. When you first
run `nvim` it should bootstrap lazy.nvim install and set up everything.

## Syncing changes back

After installing or removing tools, refresh the Brewfile and commit it:

```sh
sh scripts/brew-sync.sh
```

## Developing

I use `prek` so be sure to install it first. Then use `prek install` to use the pre-commit hooks.
