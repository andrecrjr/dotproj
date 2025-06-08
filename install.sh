#!/bin/bash

echo "🎯 Installing DotProj - Project-Specific Dotfiles Manager..."
echo "════════════════════════════════════════════════════════════════"

# Check system requirements
echo "🔍 Checking system requirements..."

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git is required but not installed."
    echo ""
    echo "📦 Please install Git first:"
    echo "  • Ubuntu/Debian: sudo apt update && sudo apt install git"
    echo "  • CentOS/RHEL:   sudo yum install git"
    echo "  • Fedora:        sudo dnf install git"
    echo "  • macOS:         brew install git (or install Xcode Command Line Tools)"
    echo "  • Arch Linux:    sudo pacman -S git"
    echo ""
    echo "After installing Git, run this installer again."
    exit 1
fi

# Check if curl is available
if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl is required but not installed."
    echo ""
    echo "📦 Please install curl first:"
    echo "  • Ubuntu/Debian: sudo apt update && sudo apt install curl"
    echo "  • CentOS/RHEL:   sudo yum install curl"
    echo "  • Fedora:        sudo dnf install curl"
    echo "  • macOS:         curl is usually pre-installed"
    echo "  • Arch Linux:    sudo pacman -S curl"
    echo ""
    exit 1
fi

echo "✅ Git version: $(git --version)"
echo "✅ curl is available"
echo ""

# Download the dotproj script and VERSION file
echo "📥 Downloading dotproj script..."
if ! curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/feature/git-full-integration/dotproj -o dotproj; then
    echo "❌ Failed to download dotproj script"
    exit 1
fi

echo "📥 Downloading version information..."
if ! curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/feature/git-full-integration/VERSION -o VERSION; then
    echo "⚠️  Failed to download VERSION file, using fallback version"
fi

# Make it executable
chmod +x dotproj

# Run setup to install permanently
echo "🔧 Running setup..."
if ! ./dotproj setup; then
    echo "❌ Setup failed"
    rm -f dotproj
    exit 1
fi

# Clean up the temporary downloaded files (the script is now installed in ~/.dotproj/)
rm -f dotproj VERSION

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
echo "  2. Run 'dotproj version' to verify installation"
echo "  3. Run 'dotproj --help' to see available commands"
echo "  4. Initialize your first project: dotproj init my-project"
echo ""
echo "🏠 DotProj is installed at: ~/.dotproj/dotproj"
echo ""
echo "💡 If you encounter any Git-related issues, make sure Git is properly configured:"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"your.email@example.com\""