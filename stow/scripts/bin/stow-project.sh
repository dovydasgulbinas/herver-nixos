#!/usr/bin/env bash
PROJECT='Sanitex'

pushd $HOME/Documents/Work
stow --verbose --target=$HOME "$PROJECT"
popd
