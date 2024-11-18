#!/bin/bash

echo "Welcome to the Generative Engineering installer."
cat << EOF
                                       _    _
                                      | |  (_)
  __ _   ___  _ __    ___  _ __  __ _ | |_  _ __   __ ___
 / _' | / _ \| '_ \  / _ \| '__|/ _' || __|| |\ \ / // _ \
| (_| ||  __/| | | ||  __/| |  | (_| || |_ | | \ V /|  __/
 \__, | \___||_| |_| \___||_|   \__,_| \__||_|  \_/  \___|
  __/ |
 |___/

EOF


# Update package lists
echo "Updating package lists..."
sudo apt update

sudo dpkg --configure -a

# Install Git
echo "Installing Git..."
sudo apt install -y git

# Install Python and pip
echo "Installing Python and pip..."
sudo apt install -y python3 python3-pip

# Install common Python development tools
echo "Installing Python development tools..."
sudo apt install -y python3-venv build-essential python3-dev

# Install pipx
echo "Installing pipx..."
sudo apt install -y pipx
pipx ensurepath

# Add pipx to PATH immediately for this session
export PATH="$HOME/.local/bin:$PATH"

# Install Poetry using pipx
echo "Installing Poetry..."
pipx install poetry

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
fi
echo "Using profile file: $PROFILE_FILE"

# Add aliases to rc files
if [ "$CURRENT_SHELL" == "zsh" ]; then
    echo "Adding Python aliases..."
    echo 'alias python=python3' >> ~/.zshrc
    echo 'alias pip=pip3' >> ~/.zshrc
    source ~/.zshrc
elif [ "$CURRENT_SHELL" == "bash" ]; then
    echo "Adding Python aliases..."
    echo 'alias python=python3' >> ~/.bashrc
    echo 'alias pip=pip3' >> ~/.bashrc
    source ~/.bashrc
else
    echo "Unsupported shell: $CURRENT_SHELL"
    echo "Please create aliases manually if required."
fi

# Add PATH updates to .bashrc if not already present
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc


# Verify installations
echo "Verifying installations..."
git --version
python3 --version
pip3 --version
poetry --version
echo "Pipx version:"; pipx --version

echo "Installation complete! The following tools are now installed:"
echo "- Git"
echo "- Python 3"
echo "- pip"
echo "- pipx"
echo "- Poetry"
echo "Note: 'python' command is now aliased to python3"

# Try restarting the shell to force the changes to take effect
if [ "$CURRENT_SHELL" == "zsh" ]; then
    exec zsh -l
elif [ "$CURRENT_SHELL" == "bash" ]; then
    exec bash -l
else
    echo "Please restart your terminal or run 'source $PROFILE_FILE' to apply the changes."
fi



