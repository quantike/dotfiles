# dotfiles

Ike's dotfiles.

## Getting started

```sh
# clone to ~/.dotfiles repo
git clone https://github.com/quantike/dotfiles ~/.dotfiles
```

Then run the bootstrap script, which will need to be run more than once because I suck at bash.

```sh
sh bootstrap.sh
```

> Keep an eye out for input prompts

## Setting up Neovim

```sh
sh bootstrap-nvim.sh
```

Then when you first run `nvim` it should bootstrap lazy.nvim install and set up everything.

## Developing

I use `prek` so be sure to install it first. Then use `prek install` to use the pre-commit hooks.

