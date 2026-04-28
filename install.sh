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
    sudo apt-get install -y stow ripgrep \
        i3 polybar rofi dunst picom feh flameshot \
        kitty pamixer pavucontrol \
        fonts-jetbrains-mono \
        network-manager imagemagick
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

echo "Stowing tmux"
stow -v tmux

echo "Stowing i3 stack"
for pkg in i3 polybar rofi dunst picom kitty; do
    stow -v "$pkg"
done

echo "Stowing claude-skills"
# Pre-create ~/.config/opencode so stow descends into it and only symlinks
# skills/ — other files (bun.lock, package.json, ...) must stay as-is.
mkdir -p ~/.config/opencode
if [ -e ~/.config/opencode/skills ] && [ ! -L ~/.config/opencode/skills ]; then
    echo "Skipping: ~/.config/opencode/skills exists as a real directory."
    echo "  Move or remove it, then re-run, to stow claude-skills."
else
    stow -v claude-skills
fi

# Mirror skills into ~/.claude/skills so Claude Code picks them up.
mkdir -p ~/.claude
if [ -d ~/.claude/skills ] && [ ! -L ~/.claude/skills ]; then
    echo "Skipping: ~/.claude/skills exists as a real directory."
    echo "  Move or remove it to link it to ~/.config/opencode/skills."
else
    ln -sfn ~/.config/opencode/skills ~/.claude/skills
fi

# Install JetBrainsMono Nerd Font if not present
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    echo "Installing JetBrainsMono Nerd Font..."
    mkdir -p ~/.local/share/fonts
    tmp=$(mktemp -d)
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" \
        -o "$tmp/JetBrainsMono.tar.xz"
    tar -xf "$tmp/JetBrainsMono.tar.xz" -C ~/.local/share/fonts
    fc-cache -fv
    rm -rf "$tmp"
fi

chmod +x ~/.config/polybar/launch.sh

# Solid dark wallpaper fallback — replace ~/.config/i3/wallpaper.jpg with your own
if [ ! -f ~/.config/i3/wallpaper.jpg ] && command -v convert &>/dev/null; then
    convert -size 1920x1080 xc:#1a1b26 ~/.config/i3/wallpaper.jpg
fi

echo "Dotfiles successfully stowed!"
