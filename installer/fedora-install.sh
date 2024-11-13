#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo dnf update -y

# Install Git
echo "Installing Git..."
sudo dnf install -y git

# Install Python and pip
echo "Installing Python and pip..."
sudo dnf install -y python3 python3-pip

# Install common Python development tools
echo "Installing Python development tools..."
sudo dnf install -y python3-devel

# Install pipx
echo "Installing pipx..."
  sudo dnf install -y pipx
  pipx ensurepath

# Add pipx to PATH immediately for this session
export PATH="$HOME/.local/bin:$PATH"

# Install Poetry using pipx
echo "Installing Poetry..."
pipx install poetry

# Add Python aliases to .bashrc
echo "Adding Python aliases..."
echo 'alias python=python3' >> ~/.bashrc
echo 'alias pip=pip3' >> ~/.bashrc

# Add PATH updates to .bashrc if not already present
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Reload .bashrc
source ~/.bashrc

# Verify installations
echo "Verifying installations..."
git --version
python3 --version
pip3 --version
poetry --version
pipx --version

echo "Installation complete! The following tools are now installed:"
echo "- Git"
echo "- Python 3"
echo "- pip"
echo "- pipx"
echo "- Poetry"
echo "Note: 'python' command is now aliased to python3"

