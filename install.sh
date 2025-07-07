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

# GitHub URLs
GITHUB_SCRIPT_URL="https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj"
GITHUB_VERSION_URL="https://raw.githubusercontent.com/andrecrjr/dotproj/master/VERSION"

# Check if DotProj is already installed
DOTPROJ_DIR="$HOME/.dotproj"
DOTPROJ_SCRIPT="$DOTPROJ_DIR/dotproj"

# Create temporary directory for downloads
TEMP_DIR=$(mktemp -d)
trap "rm -rf '$TEMP_DIR'" EXIT

if [ -f "$DOTPROJ_SCRIPT" ]; then
    echo "🔄 DotProj already installed, updating..."
    
    # Get current version for comparison
    CURRENT_VERSION=""
    if [ -f "$DOTPROJ_DIR/VERSION" ]; then
        CURRENT_VERSION=$(cat "$DOTPROJ_DIR/VERSION" 2>/dev/null | tr -d '[:space:]')
    fi
    
    # Download to temporary directory first
    echo "📥 Downloading latest version..."
    if ! curl -fsSL "$GITHUB_SCRIPT_URL" -o "$TEMP_DIR/dotproj"; then
        echo "❌ Failed to download dotproj script from GitHub"
        echo "   URL: $GITHUB_SCRIPT_URL"
        echo ""
        echo "Please check:"
        echo "  • Internet connection"
        echo "  • GitHub accessibility"
        echo "  • Repository exists and is accessible"
        exit 1
    fi
    
    if ! curl -fsSL "$GITHUB_VERSION_URL" -o "$TEMP_DIR/VERSION"; then
        echo "⚠️  Failed to download VERSION file, but script downloaded successfully"
    fi
    
    # Check if we actually got a new version
    NEW_VERSION=""
    if [ -f "$TEMP_DIR/VERSION" ]; then
        NEW_VERSION=$(cat "$TEMP_DIR/VERSION" 2>/dev/null | tr -d '[:space:]')
    fi
    
    # Show version information
    if [ -n "$CURRENT_VERSION" ] && [ -n "$NEW_VERSION" ]; then
        echo "  Current version: $CURRENT_VERSION"
        echo "  New version: $NEW_VERSION"
        
        if [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
            echo "  ℹ️  You already have the latest version!"
        fi
    fi
    
    # Create backup of current installation
    echo "📦 Creating backup of current version..."
    mkdir -p "$DOTPROJ_DIR/backup"
    if [ -f "$DOTPROJ_SCRIPT" ]; then
        cp "$DOTPROJ_SCRIPT" "$DOTPROJ_DIR/backup/dotproj.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    if [ -f "$DOTPROJ_DIR/VERSION" ]; then
        cp "$DOTPROJ_DIR/VERSION" "$DOTPROJ_DIR/backup/VERSION.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Install the new version
    echo "🔧 Installing updated version..."
    cp "$TEMP_DIR/dotproj" "$DOTPROJ_SCRIPT"
    chmod +x "$DOTPROJ_SCRIPT"
    
    if [ -f "$TEMP_DIR/VERSION" ]; then
        cp "$TEMP_DIR/VERSION" "$DOTPROJ_DIR/VERSION"
    fi
    
    echo ""
    echo "🎉 DotProj updated successfully!"
    
    # Verify the installation
    if [ -x "$DOTPROJ_SCRIPT" ]; then
        echo "✅ Installation verified: $DOTPROJ_SCRIPT is executable"
    else
        echo "❌ Installation verification failed: $DOTPROJ_SCRIPT is not executable"
        exit 1
    fi
    
else
    echo "🆕 Installing DotProj for the first time..."
    
    # Download to temporary directory
    echo "📥 Downloading dotproj script..."
    if ! curl -fsSL "$GITHUB_SCRIPT_URL" -o "$TEMP_DIR/dotproj"; then
        echo "❌ Failed to download dotproj script from GitHub"
        echo "   URL: $GITHUB_SCRIPT_URL"
        exit 1
    fi

    echo "📥 Downloading version information..."
    if ! curl -fsSL "$GITHUB_VERSION_URL" -o "$TEMP_DIR/VERSION"; then
        echo "⚠️  Failed to download VERSION file, using fallback version"
    fi

    # Make it executable
    chmod +x "$TEMP_DIR/dotproj"

    # Copy to current directory and run setup
    cp "$TEMP_DIR/dotproj" "./dotproj"
    if [ -f "$TEMP_DIR/VERSION" ]; then
        cp "$TEMP_DIR/VERSION" "./VERSION"
    fi

    # Run setup to install permanently
    echo "🔧 Running setup..."
    if ! ./dotproj setup; then
        echo "❌ Setup failed"
        rm -f ./dotproj ./VERSION
        exit 1
    fi

    # Clean up the temporary files from current directory
    rm -f ./dotproj ./VERSION
    
    echo ""
    echo "🎉 Installation complete!"
fi

# Verify final installation
if [ -f "$DOTPROJ_SCRIPT" ] && [ -x "$DOTPROJ_SCRIPT" ]; then
    FINAL_VERSION=""
    if [ -f "$DOTPROJ_DIR/VERSION" ]; then
        FINAL_VERSION=$(cat "$DOTPROJ_DIR/VERSION" 2>/dev/null | tr -d '[:space:]')
    fi
    
    echo ""
    echo "📋 Installation Summary:"
    echo "  Location: $DOTPROJ_SCRIPT"
    echo "  Executable: ✅"
    if [ -n "$FINAL_VERSION" ]; then
        echo "  Version: $FINAL_VERSION"
    fi
else
    echo ""
    echo "❌ Installation verification failed!"
    echo "  Expected location: $DOTPROJ_SCRIPT"
    echo "  File exists: $([ -f "$DOTPROJ_SCRIPT" ] && echo "✅" || echo "❌")"
    echo "  Executable: $([ -x "$DOTPROJ_SCRIPT" ] && echo "✅" || echo "❌")"
    exit 1
fi

echo ""
echo "📋 Next Steps:"
if command -v dotproj >/dev/null 2>&1; then
    echo "  ✅ dotproj is available in PATH"
    echo "  1. Run 'dotproj version' to verify installation"
    echo "  2. Run 'dotproj --help' to see available commands"
    echo "  3. Initialize your first project: dotproj init my-project"
else
    echo "  ⚠️  dotproj not yet in PATH - restart your terminal or run:"
    echo "     source ~/.bashrc    # (or ~/.zshrc if using zsh)"
    echo "  1. Run 'dotproj version' to verify installation"
    echo "  2. Run 'dotproj --help' to see available commands"
    echo "  3. Initialize your first project: dotproj init my-project"
fi

echo ""
echo "💡 Troubleshooting:"
echo "  • If 'dotproj' command not found, restart your terminal"
echo "  • For Git issues, configure: git config --global user.name \"Your Name\""
echo "  • For Git issues, configure: git config --global user.email \"your@email.com\""
echo "  • Manual location: ~/.dotproj/dotproj"