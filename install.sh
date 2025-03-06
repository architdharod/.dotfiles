#!/bin/bash
set -e

# Function to install GNU Stow on macOS using Homebrew
install_stow_macos() {
    echo "Detected macOS."
    echo "Installing GNU Stow with Homebrew..."
    brew install stow
    echo "Installing ripgrep for nvim"
    brew install ripgrep
}

# Function to install GNU Stow on Debian/Ubuntu-based systems
install_stow_debian() {
    echo "Detected Debian/Ubuntu-based Linux."
    sudo apt-get update
    sudo apt-get install -y stow
    echo "Installing ripgrep for nvim"
    sudo apt-get install -y ripgrep
}

# Function to install GNU Stow on Red Hat-based systems (if needed)
install_stow_redhat() {
    echo "Detected Red Hat-based Linux."
    sudo yum install -y stow
    echo "Installing ripgrep for nvim"
    sudo yum install -y ripgrep
}

# Detect operating system and install GNU Stow accordingly
OS_TYPE=$(uname)
if [ "$OS_TYPE" = "Darwin" ]; then
    install_stow_macos
elif [ "$OS_TYPE" = "Linux" ]; then
    if [ -f /etc/debian_version ]; then
        install_stow_debian
    elif [ -f /etc/redhat-release ]; then
        install_stow_redhat
    else
        echo "Linux distribution not specifically supported. Please install GNU Stow manually."
        exit 1
    fi
else
    echo "Unsupported OS: $OS_TYPE"
    exit 1
fi

stow -v nvim

FILE=~/.tmux.conf
if [ -f "$FILE" ]; then
  echo "Removing existing .tmux.conf"
  rm ~/.tmux.conf
fi

echo "Stowing .tmux.conf"
stow -v tmux

echo "Dotfiles successfully stowed!"
