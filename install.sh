#!/bin/bash
set -e

create_dotfile_symlinks() {
    echo "Linking dotfiles to home directory..."

    for file in .??*; do
        [ -e "$file" ] || continue  # Skip if it doesn't exist
        [ "$file" = ".git" ] && continue  # Skip .git directory if present

        name=$(basename "$file")
        echo "Creating symlink: ~/$name -> $(pwd)/$name"
        ln -sfv "$(pwd)/$name" "$HOME/$name"
    done
}

setup_nvim_config() {
    echo "Linking Neovim config..."
    mkdir -p "$HOME/.config"
    ln -sfv "$(pwd)/nvim" "$HOME/.config/nvim"
}

set_zsh_default() {
    if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
        echo "Adding $(which zsh) to /etc/shells"
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi

    echo "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
}

install_deps() {
    case "$OSTYPE" in
        darwin*)
            echo "Installing dependencies via Homebrew..."
            command -v brew >/dev/null || {
                echo "Homebrew not found. Installing..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            }
            brew install neovim zsh curl
            ;;
        linux*)
            if grep -qi microsoft /proc/version; then
                echo "WSL detected — assuming Ubuntu-like system"
                sudo apt update && sudo apt install -y neovim zsh curl
            else
                echo "Linux detected — install your dependencies manually (Arch: pacman -S neovim zsh curl)"
            fi
            ;;
        *)
            echo "Unsupported OS: $OSTYPE"
            exit 1
            ;;
    esac
}

# Run everything
install_deps
create_dotfile_symlinks
setup_nvim_config
set_zsh_default

