#!/bin/bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.vim/colors/molokai.vim --create-dirs https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim 
rm ~/.gitconfig
rm ~/.inputrc
rm ~/.zshrc
rm ~/.bashrc
rm ~/.vimrc
mkdir -p ~/.config/nvim
rm ~/.config/nvim/init.vim

ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/bashrc ~/.bashrc
ln -s ~/dotfiles/vimrc ~/.vimrc
git clone https://github.com/robbyrussell/oh-my-zsh.git
