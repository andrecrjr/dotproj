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

# Check if DotProj is already installed
DOTPROJ_DIR="$HOME/.dotproj"
DOTPROJ_SCRIPT="$DOTPROJ_DIR/dotproj"

if [ -f "$DOTPROJ_SCRIPT" ]; then
    echo "🔄 DotProj already installed, updating..."
    
    # Create backup of current version
    if [ -f "$DOTPROJ_SCRIPT" ]; then
        echo "📦 Creating backup of current version..."
        cp "$DOTPROJ_SCRIPT" "$DOTPROJ_SCRIPT.backup"
    fi
    
    # Download directly to the installed location
    echo "📥 Downloading updated dotproj script..."
    if ! curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o "$DOTPROJ_SCRIPT"; then
        echo "❌ Failed to download dotproj script"
        # Restore backup if download failed
        if [ -f "$DOTPROJ_SCRIPT.backup" ]; then
            echo "🔄 Restoring backup..."
            mv "$DOTPROJ_SCRIPT.backup" "$DOTPROJ_SCRIPT"
        fi
        exit 1
    fi
    
    # Download VERSION file
    echo "📥 Downloading version information..."
    if ! curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/VERSION -o "$DOTPROJ_DIR/VERSION"; then
        echo "⚠️  Failed to download VERSION file, keeping existing version"
    fi
    
    # Make it executable
    chmod +x "$DOTPROJ_SCRIPT"
    
    # Remove backup if update was successful
    rm -f "$DOTPROJ_SCRIPT.backup"
    
    echo ""
    echo "🎉 DotProj updated successfully!"
    
else
    echo "🆕 Installing DotProj for the first time..."
    
    # Download the dotproj script and VERSION file to current directory
    echo "📥 Downloading dotproj script..."
    if ! curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o dotproj; then
        echo "❌ Failed to download dotproj script"
        exit 1
    fi

    echo "📥 Downloading version information..."
    if ! curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/VERSION -o VERSION; then
        echo "⚠️  Failed to download VERSION file, using fallback version"
    fi

    # Make it executable
    chmod +x dotproj

    # Run setup to install permanently
    echo "🔧 Running setup..."
    if ! ./dotproj setup; then
        echo "❌ Setup failed"
        rm -f dotproj VERSION
        exit 1
    fi

    # Clean up the temporary downloaded files (the script is now installed in ~/.dotproj/)
    rm -f dotproj VERSION
    
    echo ""
    echo "🎉 Installation complete!"
fi

echo ""
echo "📋 Next steps:"
if [ -f "$DOTPROJ_SCRIPT" ]; then
    # Show current version
    if [ -f "$DOTPROJ_DIR/VERSION" ]; then
        echo "  Current version: $(cat "$DOTPROJ_DIR/VERSION")"
    fi
    echo "  1. Run 'dotproj version' to verify installation"
    echo "  2. Run 'dotproj --help' to see available commands"
    echo "  3. Initialize your first project: dotproj init my-project"
else
    echo "  1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
    echo "  2. Run 'dotproj version' to verify installation"
    echo "  3. Run 'dotproj --help' to see available commands"
    echo "  4. Initialize your first project: dotproj init my-project"
fi
echo ""
echo "🏠 DotProj is installed at: ~/.dotproj/dotproj"
echo ""
echo "💡 If you encounter any Git-related issues, make sure Git is properly configured:"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"your.email@example.com\""