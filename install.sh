#!/usr/bin/env bash

################################################################################
# install
#
# This script symlinks dotfiles into place in the home and config directories
################################################################################

dotfiles_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n[DOTFILES] ${fmt}\\n" "$@"
}

dotfiles_backup() {
  if ! command -v gcp >/dev/null || ! command -v gdate >/dev/null; then
    dotfiles_echo "GNU cp and date commands are required. Please install via Homebrew coreutils: brew install coreutils"
    exit 1
  elif [ -d "$1" ]; then
    mv -v "$1" "${1}_bak_$(gdate +"%Y%m%d%3N")"
  else
    gcp -f --backup=numbered "$1" "$1"
  fi
}

set -e # Terminate script if anything exits with a non-zero value

if [ -z "$DOTFILES" ]; then
  export DOTFILES="${HOME}/dotfiles"
fi

if [ -z "$HOST_NAME" ]; then
  HOST_NAME=$(scutil --get HostName)
  export HOST_NAME
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
  if [ ! -d "${HOME}/.config" ]; then
    mkdir "${HOME}/.config"
  fi
  export XDG_CONFIG_HOME="${HOME}/.config"
fi

FISH_DIR="${XDG_CONFIG_HOME}/fish"

if [ ! -d "$FISH_DIR" ]; then
  mkdir "$FISH_DIR"
fi

# Ensure Yarn is available in PATH for when Neovim runs plugin installation.
# https://github.com/yarnpkg/website/blob/96485d6901f1545a72f413e8df6a6851dece4d75/install.sh#L81
dotfiles_echo "Adding Yarn to PATH..."
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Also make sure we have Node, needed by Yarn.
dotfiles_echo "Adding asdf (Node/Ruby) to PATH..."
export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

dotfiles_echo "Checking PATH..."
echo "$PATH"

dotfiles_echo "Do we have Yarn? --> $(command -v yarn)"
dotfiles_echo "Do we have Node? --> $(command -v node)"

home_files=(
"asdfrc"
"default-gems"
"default-npm-packages"
"gemrc"
"gitconfig"
"gitignore_global"
"gitmessage"
"gitsh_completions"
"hushlogin"
"npmrc"
"rubocop.yml"
"tmux.conf"
"tool-versions"
"zshrc"
)

config_dirs=(
"nvim"
"pry"
"ranger"
)

config_files=(
"alacritty.yml"
"starship.toml"
)

fish_dirs=(
"completions"
"functions"
)

fish_files=(
"config.fish"
"abbreviations.fish"
)

dotfiles_echo "Installing dotfiles..."

dotfiles_echo "-> Linking basic dotfiles..."
for item in "${home_files[@]}"; do
  if [ -e "${HOME}/.${item}" ]; then
    dotfiles_echo ".${item} exists."
    if [ -L "${HOME}/.${item}" ]; then
      dotfiles_echo "Symbolic link detected. Removing..."
      rm -v "${HOME}/.${item}"
    else
      dotfiles_echo "Backing up..."
      dotfiles_backup "${HOME}/.${item}"
    fi
  fi
  dotfiles_echo "-> Linking ${DOTFILES}/${item} to ${HOME}/.${item}..."
  ln -nfs "${DOTFILES}/${item}" "${HOME}/.${item}"
done

dotfiles_echo "-> Linking Brewfile..."
if [ -e "${HOME}/Brewfile" ]; then
  dotfiles_echo "Brewfile exists."
  if [ -L "${HOME}/Brewfile" ]; then
    dotfiles_echo "Symbolic link detected. Removing..."
    rm -v "${HOME}/Brewfile"
  else
    dotfiles_echo "Backing up..."
    dotfiles_backup "${HOME}/Brewfile"
  fi
fi
dotfiles_echo "-> Linking ${DOTFILES}/Brewfile to ${HOME}/Brewfile..."
ln -nfs "${DOTFILES}/Brewfile" "${HOME}/Brewfile"

dotfiles_echo "-> Linking config directories..."
for item in "${config_dirs[@]}"; do
  if [ -d "${XDG_CONFIG_HOME}/${item}" ]; then
    dotfiles_echo "Directory ${item} exists."
    if [ -L "${XDG_CONFIG_HOME}/${item}" ]; then
      dotfiles_echo "Symbolic link detected. Removing..."
      rm -v "${XDG_CONFIG_HOME}/${item}"
    else
      dotfiles_echo "Backing up..."
      dotfiles_backup "${XDG_CONFIG_HOME}/${item}"
    fi
  fi
  dotfiles_echo "-> Linking ${DOTFILES}/${item} to ${XDG_CONFIG_HOME}/${item}..."
  ln -nfs "${DOTFILES}/${item}" "${XDG_CONFIG_HOME}/${item}"
done

dotfiles_echo "-> Linking config files..."
for item in "${config_files[@]}"; do
  if [ -e "${XDG_CONFIG_HOME}/${item}" ]; then
    dotfiles_echo "${item} exists."
    if [ -L "${XDG_CONFIG_HOME}/${item}" ]; then
      dotfiles_echo "Symbolic link detected. Removing..."
      rm -v "${XDG_CONFIG_HOME}/${item}"
    else
      dotfiles_echo "Backing up..."
      dotfiles_backup "${XDG_CONFIG_HOME}/${item}"
    fi
  fi
  dotfiles_echo "-> Linking ${DOTFILES}/machines/${HOST_NAME}/${item} to ${XDG_CONFIG_HOME}/${item}..."
  ln -nfs "${DOTFILES}/machines/${HOST_NAME}/${item}" "${XDG_CONFIG_HOME}/$item"
done

dotfiles_echo "Dotfiles installation complete!"

dotfiles_echo "Post-install recommendations:"
dotfiles_echo "- Complete Brew Bundle installation with 'brew bundle install'"
dotfiles_echo "- After launching Neovim, run :checkhealth and resolve any errors/warnings."
