#Syncing Dotfiles

##Usage

```
rm ~/.gitconfig
rm ~/.inputrc
rm ~/.bash_profile
rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
./syncdotfiles.sh
```

##Description

Seed is a folder for linking the home directory "~/" dotfiles with the repo "~/dotfiles/"

In the .gitconfig, make sure to change the name and email to your own.

**Note that if there are any previous dotfiles they may be over written after executing the script.
