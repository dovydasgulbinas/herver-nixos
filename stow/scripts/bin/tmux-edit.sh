#!/usr/bin/env bash

set -e

pushd ~/.config/tmux

$EDITOR ~/.config/tmux

tmux source-file ~/.config/tmux/tmux.conf
