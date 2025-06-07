# 🎯 DotProj - Project-Specific Dotfiles Manager

**DotProj** is a powerful command-line tool that helps you manage project-specific dotfiles with Git versioning. Keep your development environment configurations organized, versioned, and synchronized across different machines and projects.

## 📋 Summary

DotProj addresses the challenge of managing various configuration and other project-specific files across different projects. Instead of manually transferring files like `.cursor`, `.vscode`, `.eslintrc`, `.env.local`, or any other files you wish to keep safe and organized, DotProj:

- **Centralizes** your configuration files (including dotfiles and other project files) in a structured storage system
- **Symlinks** files to your projects for real-time synchronization  
- **Versions** everything with Git for backup and team collaboration
- **Syncs** configurations across machines and team members
- **Organizes** project-specific settings separately from global ones

**Perfect for**: Web developers juggling multiple projects, DevOps teams sharing configurations, or anyone who wants consistent development environments without manual file management.

**One-liner**: `curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/install.sh | bash`

## 📚 Table of Contents

- [✨ Features](#-features)
- [🚀 Quick Start](#-quick-start)
  - [Installation](#installation)
  - [Basic Usage](#basic-usage)
  - [Alternative: Load from Remote Repository](#alternative-load-from-remote-repository)
- [📖 Commands Reference](#-commands-reference)
- [💡 Use Cases](#-use-cases)
- [🗂️ File Structure](#️-file-structure)
- [🔧 Configuration](#-configuration)
- [🔗 How Symlinks Work](#-how-symlinks-work)
- [🛡️ Safety Features](#️-safety-features)
- [🌐 Remote Repository Setup](#-remote-repository-setup)
- [🔍 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## ✨ Features

- 📁 **Project-Specific Management**: Track different dotfiles for each project
- 🔄 **Git Integration**: Full version control and sync dotfiles across machines (requires Git)
- 🎨 **Interactive Setup**: User-friendly prompts for selecting dotfiles to track
- 🔧 **Flexible Configuration**: Support for any file type (.env, .vscode, .eslintrc, etc.)
- 🔗 **Symlink Management**: Real-time sync between project and storage via symlinks
- 💾 **Backup Safety**: Automatic backups when applying dotfiles
- 🌐 **Remote Sync**: Push/pull dotfiles to/from remote Git repositories
- 📊 **Status Tracking**: Monitor which files are tracked and their current state

## 🚀 Quick Start

### Prerequisites

**DotProj requires Git to be installed on your system** for version control and synchronization features.

**Install Git:**
- **Ubuntu/Debian**: `sudo apt update && sudo apt install git`
- **CentOS/RHEL**: `sudo yum install git`
- **Fedora**: `sudo dnf install git`
- **macOS**: `brew install git` (or install Xcode Command Line Tools)
- **Arch Linux**: `sudo pacman -S git`

**Configure Git (if not already done):**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Installation

#### Option 1: Installation Script (Recommended)
```bash
# One command to install everything
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/install.sh | bash

# Then restart your terminal or source your shell config
source ~/.bashrc  # or ~/.zshrc
```
*Note: This downloads the install script which then fetches the master dotproj script from the repository.*

#### Option 2: Manual Download and Setup
```bash
# Download, setup, and install manually
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o dotproj
chmod +x dotproj
./dotproj setup

# The script is now permanently installed at ~/.dotproj/dotproj
# Restart your terminal
source ~/.bashrc  # or ~/.zshrc
```

#### Option 3: Direct to PATH
```bash
# Install directly to your local bin (no setup needed)
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o ~/.local/bin/dotproj && chmod +x ~/.local/bin/dotproj

# Or system-wide install (requires sudo)
sudo curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o /usr/local/bin/dotproj && sudo chmod +x /usr/local/bin/dotproj
```

### Basic Usage

1. **Initialize a new project:**
   ```bash
   dotproj init my-project
   ```
   
2. **Select dotfiles to track** (interactive prompt will guide you):
   - `.env.local, .vscode, .eslintrc.json`
   - Or any other configuration files you need

3. **Apply dotfiles to your project (creates symlinks):**
   ```bash
   dotproj apply my-project
   ```

4. **Edit dotfiles normally** - changes are automatically saved via symlinks:
   ```bash
   # Edit any tracked file directly in your project
   # Changes are immediately reflected in storage
   ```

5. **Check symlink integrity (optional):**
   ```bash
   dotproj save my-project
   ```

6. **Sync with Git repository:**
   ```bash
   dotproj sync my-project
   ```

### Alternative: Load from Remote Repository

If you have an existing dotproj repository, you can load it directly:

1. **Initialize from remote repository:**
   ```bash
   dotproj remote my-project https://github.com/username/my-dotfiles.git
   ```

2. **Apply the dotfiles to your project (creates symlinks):**
   ```bash
   dotproj apply my-project
   ```

3. **Edit files normally and sync changes:**
   ```bash
   # Edit tracked files directly - changes auto-saved via symlinks
   dotproj sync my-project  # Commit and push changes
   ```

## 📖 Commands Reference

### Setup and Initialization
```bash
dotproj setup                    # Install DotProj and add to PATH
dotproj init <project>           # Initialize a new project (interactive)
dotproj remote <project> [url]   # Initialize from a remote dotproj repository
```

### File Management
```bash
dotproj add <project>            # Add more dotfiles to existing project
dotproj apply <project>          # Create symlinks from project to storage
dotproj save <project>           # Check symlink integrity (changes auto-saved)
```

### Project Management
```bash
dotproj list                     # List all initialized projects
dotproj status <project>         # Show tracked files and project status
dotproj remove <project>         # Remove project and all its dotfiles
```

### Git Operations
```bash
dotproj sync <project>           # Commit and sync with remote repository
```

### Help
```bash
dotproj --help                   # Show general help
dotproj <command> --help         # Show command-specific help
```

## 💡 Use Cases

### Web Development Project
```bash
# Initialize project for a React app
dotproj init my-react-app

# Track common web dev dotfiles
# When prompted, enter: .env.local, .vscode, .eslintrc.json, .prettierrc

# Later, apply these settings to a new machine (creates symlinks)
dotproj apply my-react-app
```

### DevOps Configuration
```bash
# Initialize project for infrastructure
dotproj init devops-project

# Track configuration files
# When prompted, enter: .env, docker-compose.override.yml, .terraform

# Sync across team members
dotproj sync devops-project
```

### Personal Development Environment
```bash
# Track shell and editor configurations
dotproj init personal-setup

# When prompted, enter: .bashrc, .zshrc, .vimrc, .gitconfig
```

### Remote Repository Setup
```bash
# Initialize from an existing dotproj repository
dotproj remote my-project https://github.com/username/my-dotfiles.git

# Or let dotproj prompt for the repository URL
dotproj remote my-project

# Apply the remote configuration to your project (creates symlinks)
dotproj apply my-project
```

## 🗂️ File Structure

DotProj organizes your files in a clean structure:

```
~/.dotproj/
├── config                      # Project configuration
└── dotproj                     # Installed script (executable)

~/dotfiles/projects/
├── my-project/
│   ├── .git/                   # Git repository
│   └── dotfiles/               # Tracked dotfiles
│       ├── .env.local
│       ├── .vscode/
│       │   └── settings.json
│       └── .eslintrc.json
└── another-project/
    └── dotfiles/
        └── ...
```

## 🔧 Configuration

### Project Configuration
Each project stores its configuration in `~/.dotproj/config`:
```
project-name:path:/path/to/project
project-name:git:https://github.com/user/project-dotfiles.git
project-name:dotfiles:/home/user/dotfiles/projects/project-name
```

### Git Integration
- Each project gets its own Git repository
- Uses project-specific branches: `dotproj-<project-name>`
- Supports remote repositories for team synchronization
- Automatic conflict detection and resolution guidance

## 🔗 How Symlinks Work

DotProj uses **symlinks** to connect your project files to centralized storage:

```
Project Directory                Storage Directory
├── .env → ~/dotfiles/.../env    ├── .env (actual file)
├── .vscode/ → ~/dotfiles/...    ├── .vscode/ (actual files)
└── config.json → ~/dotfiles... └── config.json (actual file)
```

### Key Benefits:
- **Real-time sync**: Edit files in your project, changes immediately saved to storage
- **No manual save**: Skip the `dotproj save` step - symlinks handle it automatically
- **Safety**: Deleting project files only removes symlinks, your data stays safe
- **Recovery**: `dotproj apply` recreates missing symlinks instantly

### File Operations:
| Action | Result | Storage Impact |
|--------|--------|----------------|
| Edit project file | ✅ Content updated | ✅ Immediately reflected |
| Delete project file | ❌ Symlink removed | ✅ Storage file preserved |
| Delete storage file | ❌ Broken symlink | ❌ Data lost permanently |

## 🛡️ Safety Features

- **Symlink Safety**: Deleting project files only removes symlinks, storage remains safe
- **Automatic Backups**: Existing files are backed up before being replaced (backups are not committed to Git)
- **Real-time Sync**: Changes in project files immediately reflect in storage
- **Integrity Checks**: Monitor and repair broken symlinks
- **Conflict Detection**: Git merge conflicts are detected and reported
- **Validation**: Checks for file existence and project validity

## 🌐 Remote Repository Setup

### Load from Existing Repository
The `remote` command allows you to initialize a project from an existing dotproj repository:

```bash
# Initialize from a remote repository
dotproj remote my-project https://github.com/username/my-dotfiles.git

# This will:
# 1. Clone the remote repository
# 2. Validate it's a proper dotproj structure
# 3. Set up the project locally
# 4. Configure all settings automatically
```

### Repository Structure
For a repository to be compatible with `dotproj remote`, it should have this structure:
```
your-dotfiles-repo/
├── dotfiles/           # Required: Contains all the dotfiles
│   ├── .env.local
│   ├── .vscode/
│   │   └── settings.json
│   ├── .eslintrc.json
│   └── other-config-files
├── .git/              # Git repository data
└── other-files        # Optional: README, docs, etc.
```

### GitHub/GitLab Integration
```bash
# During init, provide your repository URL:
# https://github.com/username/project-dotfiles.git
# git@github.com:username/project-dotfiles.git

# Or configure later in ~/.dotproj/config
```

## 🔍 Troubleshooting

### Common Issues

**Git not installed:**
```bash
# If you see "Git is required but not installed"
# Install Git first, then run dotproj again

# Ubuntu/Debian
sudo apt update && sudo apt install git

# CentOS/RHEL
sudo yum install git

# Fedora
sudo dnf install git

# macOS
brew install git

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Command not found after setup:**
```bash
# Restart terminal or manually source your shell config
source ~/.bashrc  # or ~/.zshrc

# Verify installation
which dotproj  # Should show: /home/user/.dotproj/dotproj
```

**Git sync failures:**
```bash
# Check your repository URL and permissions
dotproj status <project>
# Verify Git credentials and repository access
```

**File conflicts during apply:**
```bash
# Check backup files created automatically in the backups directory
ls -la backups/
# Review differences and restore if needed
```

### Getting Help
```bash
dotproj --help                  # General help
dotproj <command> --help        # Command-specific help
dotproj status <project>        # Debug project state
```

## 🤝 Contributing

DotProj is designed to be simple and extensible. Feel free to:
- Report issues and suggest improvements
- Add support for new file types
- Enhance Git integration features
- Improve user experience

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2024 Andre Jr (andrecrjr)

The MIT License allows you to:
- ✅ Use the software for any purpose
- ✅ Modify and distribute the software
- ✅ Include it in commercial projects
- ✅ Sublicense the software

**Requirements**: Include the original copyright notice and license in any copy or substantial portion of the software.

---

**Happy coding with organized dotfiles! 🎉**

> **Tip**: Use `dotproj list` to see all your projects and `dotproj status <project>` to check what's being tracked.
