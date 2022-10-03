#!/bin/bash

# Create symlinks for all dotfiles in directory
create_symlinks() {
    # Get a list of all files in this directory that start with a dot.
    files=$(find -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename $file)
        echo "Creating symlink to $name in home directory."
        ln -sfv $(pwd)/$name $HOME/$name
    done
}
create_symlinks

# Set ZSH as default prompt
sudo chsh -s "$(which zsh)" "$(whoami)"

