#!/bin/sh

# Setup ZSH as default shell
if ! grep -q "root.*/bin/zsh" /etc/passwd
then
  chsh -s /bin/zsh root
fi

# git config
ln -sf $(pwd)/home/.gitconfig $HOME/.gitconfig
