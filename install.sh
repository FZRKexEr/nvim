#!/bin/bash

set -e

REPO_URL="https://raw.githubusercontent.com/FZRKexEr/nvim/main"
NVIM_DIR="$HOME/.config/nvim"

echo "🚀 Ultra Neovim Installer"
echo ""

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    echo "❌ Error: Neovim not found!"
    echo "   Please install Neovim 0.11+ first:"
    echo "   brew install neovim"
    exit 1
fi

# Check Neovim version
NVIM_VERSION=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
REQUIRED_VERSION="0.11"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NVIM_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "⚠️  Warning: Neovim version $NVIM_VERSION detected."
    echo "   This config requires Neovim $REQUIRED_VERSION+."
    echo "   Please upgrade: brew upgrade neovim"
    exit 1
fi

echo "✅ Neovim $NVIM_VERSION detected"
echo ""

# Create config directory
mkdir -p "$NVIM_DIR"

# Backup existing config
if [ -f "$NVIM_DIR/init.lua" ]; then
    BACKUP_FILE="$NVIM_DIR/init.lua.bak.$(date +%Y%m%d_%H%M%S)"
    echo "📦 Backing up existing init.lua to $BACKUP_FILE"
    mv "$NVIM_DIR/init.lua" "$BACKUP_FILE"
fi

# Download init.lua
echo "📥 Downloading init.lua..."
if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_URL/init.lua" -o "$NVIM_DIR/init.lua"
elif command -v wget &> /dev/null; then
    wget -q "$REPO_URL/init.lua" -O "$NVIM_DIR/init.lua"
else
    echo "❌ Error: Neither curl nor wget found!"
    exit 1
fi

# Verify download
if [ ! -f "$NVIM_DIR/init.lua" ]; then
    echo "❌ Error: Failed to download init.lua"
    exit 1
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Start Neovim: nvim"
echo "   2. Run :checkhealth to verify everything is working"
echo "   3. Check the README for keybindings and features"
echo ""
echo "🍺 Optional dependencies for better experience:"
echo "   brew install ripgrep fd"
echo ""
