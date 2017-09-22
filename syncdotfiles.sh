#!/bin/bash
rm ~/.gitconfig
rm ~/.inputrc
rm ~/.zshrc
rm ~/.bash_profile
rm ~/.config/nvim/init.vim

ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/bash_profile ~/.bash_profile
mkdir -p ~/.config/nvim/
ln -s ~/dotfiles/vimrc ~/.config/nvim/init.vim
git clone https://github.com/robbyrussell/oh-my-zsh.git
