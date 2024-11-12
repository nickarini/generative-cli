#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect package manager
if command_exists apt-get; then
    PKG_MANAGER="apt-get"
    UPDATE_CMD="sudo apt-get update -y"
    INSTALL_CMD="sudo apt-get install -y"
    echo "Package manager found: apt-get"
elif command_exists dnf; then
    PKG_MANAGER="dnf"
    UPDATE_CMD="sudo dnf makecache -y"
    INSTALL_CMD="sudo dnf install -y"
elif command_exists yum; then
    PKG_MANAGER="yum"
    UPDATE_CMD="sudo yum makecache -y"
    INSTALL_CMD="sudo yum install -y"
else
    echo "No supported package manager found (apt-get, dnf, yum)."
    exit 1
fi

# Install Git if not installed
if ! command_exists git; then
    echo "Git not found. Installing Git..."
    $UPDATE_CMD
    $INSTALL_CMD git
    if ! command_exists git; then
        echo "Error: Git installation failed."
        exit 1
    fi
else
    echo "Git is already installed."
fi

# Install Python 3 if not installed
if ! command_exists python3; then
    echo "Python 3 not found. Installing Python 3..."
    $UPDATE_CMD
    $INSTALL_CMD python3
    if ! command_exists python3; then
        echo "Error: Python 3 installation failed."
        exit 1
    fi
else
    echo "Python 3 is already installed."
fi

# Install pip3 if not installed
if ! command_exists pip3; then
    echo "pip3 not found. Installing pip3..."
    $UPDATE_CMD
    $INSTALL_CMD python3-pip
    if ! command_exists pip3; then
        echo "Error: pip3 installation failed."
        exit 1
    fi
else
    echo "pip3 is already installed."
fi

# Upgrade pip
python3 -m pip install --upgrade --user pip

# Install Poetry if not installed
if ! command_exists poetry; then
    echo "Poetry not found. Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
    if ! command_exists poetry; then
        echo "Error: Poetry installation failed."
        exit 1
    fi
else
    echo "Poetry is already installed."
fi

# Install Pipx if not installed
if ! command_exists pipx; then
    echo "Pipx not found. Installing Pipx..."
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    export PATH="$HOME/.local/bin:$PATH"
    if ! command_exists pipx; then
        echo "Error: Pipx installation failed."
        exit 1
    fi
else
    echo "Pipx is already installed."
fi

# Detect user's default shell
USER_SHELL=$(basename "$SHELL")

# Add $HOME/.local/bin to PATH if not present
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    SHELL_RC=""
    case "$USER_SHELL" in
        bash)
            SHELL_RC="$HOME/.bashrc"
            ;;
        zsh)
            SHELL_RC="$HOME/.zshrc"
            ;;
        fish)
            SHELL_RC="$HOME/.config/fish/config.fish"
            ;;
        *)
            echo "Your shell ($USER_SHELL) is not directly supported by this script."
            echo "Please manually add the following line to your shell's configuration file:"
            echo 'export PATH="$HOME/.local/bin:$PATH"'
            ;;
    esac

    if [[ -n "$SHELL_RC" ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
        echo "Added $HOME/.local/bin to PATH in $SHELL_RC"
    fi
else
    echo "$HOME/.local/bin is already in your PATH."
fi

echo "All required tools are installed successfully."
