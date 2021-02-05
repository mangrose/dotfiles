# ~/.zshrc
. $HOME/dotfiles/zsh/profiler.start

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.yarn/bin:$PATH:/Users/mange/.dotnet/tools
export EDITOR="vim"
export BUNDLER_EDITOR=$EDITOR
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export SOURCE_ANNOTATION_DIRECTORIES="spec"
export DISABLE_AUTO_TITLE=true
export _Z_OWNER=$USER
export ZSH_DISABLE_COMPFIX=true
export RUBY_CONFIGURE_OPTS="--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export DOTFILES="$HOME/dotfiles"
HOST_NAME=$(scutil --get HostName)
export HOST_NAME

. $DOTFILES/zsh/oh-my-zsh
. $DOTFILES/zsh/opts
. $DOTFILES/zsh/aliases
. $DOTFILES/zsh/prompt
. $DOTFILES/zsh/functions
. $DOTFILES/zsh/z.sh
. $DOTFILES/zsh/ranger.sh

cdpath=($HOME/code $DOTFILES $HOME/Developer $HOME/Sites $HOME/Dropbox $HOME)

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

# asdf
#. $HOME/.asdf/asdf.sh
#. $HOME/.asdf/completions/asdf.bash

# Use vi mode
bindkey -v
bindkey -e

# Vi mode settings
# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
#bindkey "^[OA" up-line-or-beginning-search
#bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Easier, more vim-like editor opening
bindkey -M vicmd v edit-command-line

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# Travis CI
[ -f ~/.travis/travis.sh ] && . ~/.travis/travis.sh

# Include local settings
[[ -f ~/.zshrc.local ]] && . ~/.zshrc.local

. $HOME/dotfiles/zsh/profiler.stop

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Tulo environment
. $HOME/dotfiles/tulo/loadenv