#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

echo "Starting Homebrew installation script..."

# **Step 1: Accept Xcode license agreement to prevent prompts**
if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools not found."
    echo "Accepting Xcode license agreement..."
    sudo xcodebuild -license accept
else
    echo "Xcode Command Line Tools are already installed."
fi

# **Step 2: Install Homebrew**
echo "Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# **Step 3: Determine Homebrew's installation path manually**
if [[ -d "/opt/homebrew/bin" ]]; then
    # Apple Silicon Macs (M1/M2)
    BREW_PREFIX="/opt/homebrew"
elif [[ -d "/usr/local/bin" ]]; then
    # Intel Macs
    BREW_PREFIX="/usr/local"
else
    echo "Homebrew installation failed or could not determine the installation path."
    exit 1
fi
echo "Homebrew prefix: $BREW_PREFIX"

# **Step 4: Add Homebrew to PATH for current script execution**
export PATH="$BREW_PREFIX/bin:$PATH"

# **Verify that 'brew' command is now available**
if command_exists brew; then
    echo "'brew' command is now available."
else
    echo "Failed to locate 'brew' command even after adjusting PATH."
    exit 1
fi

# **Step 5: Detect the current user**
CURRENT_USER=$(whoami)
echo "Current user: $CURRENT_USER"

# **Step 6: Detect the user's shell**
CURRENT_SHELL=$(basename "$SHELL")
echo "Current shell: $CURRENT_SHELL"

# **Step 7: Determine the appropriate shell profile file**
if [ "$CURRENT_SHELL" == "zsh" ]; then
    PROFILE_FILE="$HOME/.zshrc"
elif [ "$CURRENT_SHELL" == "bash" ]; then
    # macOS Catalina and later use Zsh by default, but check for Bash profiles
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

# **Step 8: Initialize Homebrew environment variables for the current session**
eval "$($BREW_PREFIX/bin/brew shellenv)"

# **Step 9: Add Homebrew to the user's PATH in the shell profile**
if ! grep -qs 'eval.*brew shellenv' "$PROFILE_FILE"; then
    echo "Adding Homebrew to PATH in $PROFILE_FILE..."
    echo '' >> "$PROFILE_FILE"
    echo '# Set PATH, MANPATH, etc., for Homebrew.' >> "$PROFILE_FILE"
    echo 'eval "$('"$BREW_PREFIX"'/bin/brew shellenv)"' >> "$PROFILE_FILE"
    echo "Homebrew path added to $PROFILE_FILE."
else
    echo "Homebrew path already present in $PROFILE_FILE."
fi

$BREW_PREFIX/bin/brew install python

$BREW_PREFIX/bin/brew install poetry

python3 --version
poetry --version

echo "Homebrew, Python and Poetry installation and PATH setup completed."


source $PROFILE_FILE

# Try restarting the shell to force the changes to take effect
if [ "$CURRENT_SHELL" == "zsh" ]; then
    exec zsh -l
elif [ "$CURRENT_SHELL" == "bash" ]; then
    exec bash -l
else
    echo "Please restart your terminal or run 'source $PROFILE_FILE' to apply the changes."
fi

