#!/bin/sh
install() {
    cat .zshrc > $HOME/.zshrc
    cat .vimrc > $HOME/.vimrc
}
install

# make directly highlighting readable - needs to be after zshrc line
# https://josh-ops.com/posts/github-codespaces-powerlevel10k/
echo "" >> ~/.zshrc
echo "# remove ls and directory completion highlight color" >> ~/.zshrc
echo "_ls_colors=':ow=01;33'" >> ~/.zshrc
echo 'zstyle ":completion:*:default" list-colors "${(s.:.)_ls_colors}"' >> ~/.zshrc
echo 'LS_COLORS+=$_ls_colors' >> ~/.zshrc

# setup vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c PluginInstall -c qall
