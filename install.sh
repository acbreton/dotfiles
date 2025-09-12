#!/bin/bash
set -e

create_dotfile_symlinks() {
    echo "Linking dotfiles to home directory..."

    for file in .??*; do
        [ -e "$file" ] || continue
        [ "$file" = ".git" ] && continue

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

install_pipx_and_python_tools() {
    # Install pipx if missing
    if ! command -v pipx >/dev/null 2>&1; then
        echo "Installing pipx..."

        if command -v brew >/dev/null 2>&1; then
            brew install pipx
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --needed python-pipx
        elif command -v apt >/dev/null 2>&1; then
            sudo apt update
            sudo apt install -y python3-pip
            python3 -m pip install --user pipx
            python3 -m pipx ensurepath
        else
            echo "Please install pipx manually: https://pipxproject.github.io/install/"
            exit 1
        fi
    fi

    export PATH="$HOME/.local/bin:$PATH"

    echo "Installing pylint and black with pipx..."
    pipx install --force pylint
    pipx install --force black
}

get_os_type() {
    if [ "$(uname)" = "Darwin" ]; then
        echo "darwin"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                echo "ubuntu"
                ;;
            arch)
                echo "arch"
                ;;
            *)
                echo "linux"
                ;;
        esac
    else
        echo "unknown"
    fi
}

install_deps() {
    os_type=$(get_os_type)
    case "$os_type" in
        darwin)
            echo "Installing dependencies via Homebrew..."
            command -v brew >/dev/null || {
                echo "Homebrew not found. Installing..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            }
            brew install neovim zsh curl python3 node stylua

            echo "Installing formatters and linters..."
            npm install -g prettier eslint
            install_pipx_and_python_tools
            ;;
        ubuntu)
            echo "Ubuntu/Debian detected — installing via apt..."
            sudo apt update
            sudo apt install -y neovim zsh curl python3 python3-pip python3-pipx nodejs npm
            echo "Installing formatters and linters..."
            npm install -g prettier eslint
            install_pipx_and_python_tools
            echo "Please install stylua manually if needed: https://github.com/JohnnyMorganz/StyLua#installation"
            ;;
        arch)
            echo "Arch Linux detected — installing via pacman..."
            sudo pacman -S --needed neovim zsh curl python python-pipx nodejs npm stylua
            echo "Installing formatters and linters..."
            npm install -g prettier eslint
            install_pipx_and_python_tools
            ;;
        linux)
            echo "Generic Linux detected — please update install logic if needed."
            # You can choose to default to apt or pacman, or print a message.
            ;;
        *)
            echo "Unsupported OS: $os_type"
            exit 1
            ;;
    esac
}

print_post_install_info() {
    echo
    echo "Setup complete!"
    echo "If you see errors about missing formatters/linters, install them manually:"
    echo "  npm install -g prettier eslint"
    echo "  pipx install pylint black"
    echo "  stylua: https://github.com/JohnnyMorganz/StyLua#installation"
    echo
    echo "Run :checkhealth in Neovim for diagnostics."
}

install_deps
create_dotfile_symlinks
setup_nvim_config
set_zsh_default
print_post_install_info
