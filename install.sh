#!/bin/bash

echo "🎯 Installing DotProj - Project-Specific Dotfiles Manager..."
echo "════════════════════════════════════════════════════════════════"

# Download the dotproj script
echo "📥 Downloading dotproj script..."
if ! curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o dotproj; then
    echo "❌ Failed to download dotproj script"
    exit 1
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

# Clean up the temporary downloaded file (the script is now installed in ~/.dotproj/)
rm -f dotproj

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
echo "  2. Run 'dotproj --help' to see available commands"
echo "  3. Initialize your first project: dotproj init my-project"
echo ""
echo "🏠 DotProj is installed at: ~/.dotproj/dotproj"