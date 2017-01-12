#!/bin/bash
mv ~/.gitconfig ~/.gitconfig-old
mv ~/.inputrc ~/.inputrc-old
mv ~/.zshrc ~/.zshrc-old
mv ~/.bash_profile ~/.bash_profile-old
mv ~/.hyper.js ~/.hyper.js-old
mv ~/vimrc ~/vimrc-old
mv ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User-old 

ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.inputrc ~/.inputrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.bash_profile ~/.bash_profile
ln -s ~/dotfiles/.hyper.js ~/.hyper.js
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.hyper_plugins/ ~/.hyper_plugins/
ln -s ~/dotfiles/sublimepreferences/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
git clone https://github.com/robbyrussell/oh-my-zsh.git
