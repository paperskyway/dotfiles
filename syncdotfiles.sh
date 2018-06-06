#!/bin/bash
rm ~/.gitconfig
rm ~/.inputrc
rm ~/.zshrc
rm ~/.vimrc
rm ~/.bash_profile

ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/bash_profile ~/.bash_profile
git clone https://github.com/robbyrussell/oh-my-zsh.git
