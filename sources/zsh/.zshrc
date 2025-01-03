#!/usr/bin/env bash

HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.zsh_aliases" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.zsh_aliases"
fi

if [ -f "$HOME/.zsh_functions" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.zsh_functions"
fi

if [ -f "$HOME/.zsh_dev" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.zsh_dev"
fi

if [ -f "$HOME/.zsh_work" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.zsh_work"
fi

if [ -f "$HOME/.env" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.env"
fi
