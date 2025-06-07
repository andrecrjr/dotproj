# 🎯 DotProj - Project-Specific Dotfiles Manager

**DotProj** is a powerful command-line tool that helps you manage project-specific dotfiles with Git versioning. Keep your development environment configurations organized, versioned, and synchronized across different machines and projects.

## ✨ Features

- 📁 **Project-Specific Management**: Track different dotfiles for each project
- 🔄 **Git Integration**: Version control and sync dotfiles across machines
- 🎨 **Interactive Setup**: User-friendly prompts for selecting dotfiles to track
- 🔧 **Flexible Configuration**: Support for any file type (.env, .vscode, .eslintrc, etc.)
- 💾 **Backup Safety**: Automatic backups when applying dotfiles
- 🌐 **Remote Sync**: Push/pull dotfiles to/from remote Git repositories
- 📊 **Status Tracking**: Monitor which files are tracked and their current state

## 🚀 Quick Start

### Installation

#### Option 1: Installation Script (Recommended)
```bash
# One command to install everything
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/install.sh | bash

# Then restart your terminal or source your shell config
source ~/.bashrc  # or ~/.zshrc
```
*Note: This downloads the install script which then fetches the master dotproj script from the repository.*

#### Option 2: One-Line Install
```bash
# Download, install, and cleanup in one command (most reliable)
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/dotproj -o dotproj && chmod +x dotproj && ./dotproj setup && rm dotproj

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

3. **Apply dotfiles to your project:**
   ```bash
   dotproj apply my-project
   ```

4. **Save changes after modifying dotfiles:**
   ```bash
   dotproj save my-project
   ```

5. **Sync with Git repository:**
   ```bash
   dotproj sync my-project
   ```

## 📖 Commands Reference

### Setup and Initialization
```bash
dotproj setup                    # Install DotProj and add to PATH
dotproj init <project>           # Initialize a new project
```

### File Management
```bash
dotproj add <project>            # Add more dotfiles to existing project
dotproj apply <project>          # Apply stored dotfiles to project directory
dotproj save <project>           # Save modified dotfiles from project to storage
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

# Later, apply these settings to a new machine
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

## 🗂️ File Structure

DotProj organizes your files in a clean structure:

```
~/.dotproj/
├── config                      # Project configuration
└── dotproj.sh                  # Installed script

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

## 🛡️ Safety Features

- **Automatic Backups**: Existing files are backed up before being overwritten
- **Dry Run Status**: Check what files are tracked before applying changes
- **Conflict Detection**: Git merge conflicts are detected and reported
- **Validation**: Checks for file existence and project validity

## 🌐 Remote Repository Setup

### GitHub/GitLab Integration
```bash
# During init, provide your repository URL:
# https://github.com/username/project-dotfiles.git
# git@github.com:username/project-dotfiles.git

# Or configure later in ~/.dotproj/config
```

### Team Collaboration
```bash
# Team member A sets up dotfiles
dotproj init shared-project
# Configures Git repo: https://github.com/team/shared-dotfiles.git

# Team member B syncs the same dotfiles
dotproj init shared-project
# Uses same Git repo URL
dotproj sync shared-project  # Pulls existing configuration
```

## 🔍 Troubleshooting

### Common Issues

**Command not found after setup:**
```bash
# Restart terminal or manually source your shell config
source ~/.bashrc  # or ~/.zshrc
```

**Git sync failures:**
```bash
# Check your repository URL and permissions
dotproj status <project>
# Verify Git credentials and repository access
```

**File conflicts during apply:**
```bash
# Check backup files created automatically
ls -la *.backup.*
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

This project is open source. Feel free to use, modify, and distribute according to your needs.

---

**Happy coding with organized dotfiles! 🎉**

> **Tip**: Use `dotproj list` to see all your projects and `dotproj status <project>` to check what's being tracked.
