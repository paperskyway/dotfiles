#!/bin/bash
rm ~/.gitconfig
rm ~/.inputrc
rm ~/.zshrc
rm ~/.bash_profile
rm ~/.hyper.js
rm ~/.vimrc
rm ~/.config/nvim/init.vim

ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/bash_profile ~/.bash_profile
ln -s ~/dotfiles/hyper.js ~/.hyper.js
ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/hyper_plugins/ ~/.hyper_plugins/
git clone https://github.com/robbyrussell/oh-my-zsh.git
