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
    ln -sfn "$(pwd)/nvim" "$HOME/.config/nvim"
}

set_zsh_default() {
    if uname -s | grep -q "_NT-"; then
        echo "⚠️  Windows Git Bash detected — skipping shell change."
        echo "Zsh is not available on Windows Git Bash; .bashrc will be used."
        return
    fi

    ZSH_PATH=$(which zsh)
    echo "Detected zsh at: $ZSH_PATH"

    if [ -n "$CODESPACES" ]; then
        echo "⚠️  Running inside GitHub Codespaces — skipping chsh and /etc/shells edits."
        echo "Adding 'exec zsh' to ~/.bashrc to launch zsh automatically."
        grep -q 'exec zsh' ~/.bashrc 2>/dev/null || echo 'exec zsh' >> ~/.bashrc
        return
    fi

    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        echo "Adding $ZSH_PATH to /etc/shells"
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi

    echo "Setting Zsh as default shell..."
    chsh -s "$ZSH_PATH" || echo "⚠️ chsh failed — please set zsh manually"
}

install_pipx_and_python_tools() {
    # Set pipx to use user directories
    export PIPX_HOME="$HOME/.local/pipx"
    export PIPX_BIN_DIR="$HOME/.local/bin"
    export PATH="$PIPX_BIN_DIR:$PATH"

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

    echo "Installing pylint and black with pipx..."
    pipx install --force pylint
    pipx install --force black
}

get_os_type() {
    if uname -s | grep -q "_NT-"; then
        echo "windows"
    elif [ "$(uname)" = "Darwin" ]; then
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
            sudo apt install -y neovim zsh curl python3 python3-pip nodejs npm
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
        windows)
            echo "Windows Git Bash detected — limited install support."
            echo "Please ensure the following are installed manually:"
            echo "  - Neovim: https://github.com/neovim/neovim/wiki/Installing-Neovim#windows"
            echo "  - Node.js: https://nodejs.org/"
            echo "  - Python: https://www.python.org/downloads/windows/"
            if command -v npm >/dev/null 2>&1; then
                echo "Installing formatters and linters via npm..."
                npm install -g prettier eslint
            fi
            if command -v pip >/dev/null 2>&1 || command -v pip3 >/dev/null 2>&1; then
                echo "Installing Python tools..."
                pip install --user pylint black 2>/dev/null || pip3 install --user pylint black
            fi
            ;;
        linux)
            echo "Generic Linux detected — please update install logic if needed."
            ;;
        *)
            echo "Unsupported OS: $os_type"
            exit 1
            ;;
    esac
}

print_post_install_info() {
    echo
    echo "✅ Setup complete!"
    echo
    echo "If you see errors about missing formatters/linters, install them manually:"
    echo "  npm install -g prettier eslint"
    echo "  pipx install pylint black"
    echo "  stylua: https://github.com/JohnnyMorganz/StyLua#installation"
    echo
    echo "Run :checkhealth in Neovim for diagnostics."
    echo

    if [ -n "$CODESPACES" ]; then
        echo "🛠 You are in GitHub Codespaces — zsh will launch via .bashrc."
        echo "To check you're using zsh, run: echo \$0"
    fi
}

if [ -z "$CODESPACES" ]; then
    install_deps

    if ! uname -s | grep -q "_NT-"; then
        setup_nvim_config
    else
        # On Windows, nvim config goes to ~/AppData/Local/nvim
        NVIM_WIN_DIR="$APPDATA/../Local/nvim"
        if [ -n "$LOCALAPPDATA" ]; then
            NVIM_WIN_DIR="$LOCALAPPDATA/nvim"
        fi
        echo "Linking Neovim config to $NVIM_WIN_DIR..."
        mkdir -p "$(dirname "$NVIM_WIN_DIR")"
        ln -sfn "$(pwd)/nvim" "$NVIM_WIN_DIR"
    fi

    # Use SSH for GitHub URLs on local machines
    git config --global url."git@github.com:".insteadOf "https://github.com/"
fi

create_dotfile_symlinks
set_zsh_default
print_post_install_info
