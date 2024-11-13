#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

echo "Starting Homebrew installation script..."

# **Step 1: Install Xcode Command Line Tools if not already installed**
if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    # Wait until the tools are installed
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    echo "Xcode Command Line Tools installed."
else
    echo "Xcode Command Line Tools are already installed."
fi

# **Step 2: Install Homebrew**
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# **Step 3: Detect the current user**
CURRENT_USER=$(whoami)
echo "Current user: $CURRENT_USER"

# **Step 4: Detect the user's shell**
CURRENT_SHELL=$(basename "$SHELL")
echo "Current shell: $CURRENT_SHELL"

# **Step 5: Determine the appropriate shell profile file**
if [ "$CURRENT_SHELL" == "zsh" ]; then
    PROFILE_FILE="$HOME/.zshrc"
elif [ "$CURRENT_SHELL" == "bash" ]; then
    # macOS Catalina and later uses Zsh by default, but check for Bash profiles
    if [ -f "$HOME/.bash_profile" ]; then
        PROFILE_FILE="$HOME/.bash_profile"
    else
        PROFILE_FILE="$HOME/.bashrc"
    fi
else
    echo "Unsupported shell: $CURRENT_SHELL"
    echo "Please add Homebrew to your PATH manually."
    exit 1
fi
echo "Using profile file: $PROFILE_FILE"

# **Step 6: Determine Homebrew's installation path**
if command_exists brew; then
    BREW_PREFIX=$(brew --prefix)
else
    echo "Homebrew installation failed or 'brew' command not found."
    exit 1
fi
echo "Homebrew prefix: $BREW_PREFIX"

# **Step 7: Initialize Homebrew environment variables for the current session**
eval "$($BREW_PREFIX/bin/brew shellenv)"

# **Step 8: Add Homebrew to the user's PATH in the shell profile**
if ! grep -qs 'eval.*brew shellenv' "$PROFILE_FILE"; then
    echo "Adding Homebrew to PATH in $PROFILE_FILE..."
    echo '# Set PATH, MANPATH, etc., for Homebrew.' >> "$PROFILE_FILE"
    echo 'eval "$('"$BREW_PREFIX"'/bin/brew shellenv)"' >> "$PROFILE_FILE"
    echo "Homebrew path added to $PROFILE_FILE."
else
    echo "Homebrew path already present in $PROFILE_FILE."
fi

echo "Homebrew installation and PATH setup completed."
echo "Please restart your terminal or run 'source $PROFILE_FILE' to apply the changes."
source $PROFILE_FILE
