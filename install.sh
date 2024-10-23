#!/bin/sh
install() {
    cat .zshrc > $HOME/.zshrc
    cat .vimrc > $HOME/.vimrc
}
install
