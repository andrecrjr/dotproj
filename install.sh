#!/bin/bash
echo "Installing DotProj..."
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o dotproj
chmod +x dotproj
./dotproj setup
rm dotproj
echo "Installation complete! Please restart your terminal or run: source ~/.bashrc"