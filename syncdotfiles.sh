#!/bin/bash
mv ~/.gitconfig ~/.gitconfig-old
mv ~/.inputrc ~/.inputrc-old
mv ~/.zshrc ~/.zshrc-old
mv ~/.bash_profile ~/.bash_profile-old
mv ~/.hyper.js ~/.hyper.js-old
mv ~/vimrc ~/vimrc-old

ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.inputrc ~/.inputrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.bash_profile ~/.bash_profile
ln -s ~/dotfiles/.hyper.js ~/.hyper.js
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.hyper_plugins/ ~/.hyper_plugins/
git clone https://github.com/robbyrussell/oh-my-zsh.git
