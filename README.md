# 🎯 DotProj - Project-Specific Configuration Manager

**DotProj** is a developer-centric CLI tool designed to manage project-specific configuration files with Git versioning. It helps keep your development environment settings organized, versioned, and synchronized across multiple machines and projects.


## Prerequisites:
* **Git** must be installed and configured:
    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"
    ```
* **Curl** must be installed.

--- 

**Quick Install for Linux and macOS**:
```bash
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/install.sh | bash
```

## 📋 What It Solves

Eliminates the hassle of manually copying configuration files like:
- **Environment files**: `.env`, `.env.local`, `.env.development`
- **Editor configurations**: `.vscode`, `.cursor`
- **Linting & formatting**: `.eslintrc.json`, `.prettierrc`, `.editorconfig`
- **Build & deployment**: `docker-compose.override.yml`, `Dockerfile.dev`

**Key Features**:
- **Centralizes** configurations in organized storage
- **Symlinks** files for real-time synchronization
- **Smart backups** - one backup per file, no clutter
- **Git versioning** for team collaboration
- **Cross-machine sync** via remote repositories (create a private repo)


## 🔒 Security & Privacy

**⚠️ CRITICAL: Use PRIVATE repositories for sensitive files!**

- **Environment files**: `.env`, `.env.local`, `.env.production` → **PRIVATE REPO ONLY**
- **API keys & secrets**: Any file with passwords, tokens, keys → **PRIVATE REPO ONLY**
- **Team configs**: Shared sensitive settings → **PRIVATE TEAM REPO**

**Repository Security Checklist**:
- ✅ Create private repository before `dotproj init`
- ✅ Verify repository visibility is "Private" 
- ✅ Only invite trusted team members
- ✅ Never commit actual secrets to public repos

## 🚀 Essential Workflows

### 🔧 Basic Individual Flow

**Create new project**:
```bash
# 0. 🔒 IMPORTANT: Create a PRIVATE repository first!
#    For projects with sensitive files (.env, API keys, secrets):
#    → GitHub: Create private repo (avoid adding README)
#    → GitLab: Create private repo 
#    → Example: https://github.com/username/my-project-config.git

# 1. Initialize project (prompts for files, creates symlinks automatically)
dotproj init my-project

# 2. Select files when prompted: .env.local, .vscode, .cursor, etc.
#    → Files are copied to storage and symlinked back to project
#    ⚠️  SECURITY: Only use PRIVATE repos for .env files with secrets!

# 3. Work normally - changes auto-saved via symlinks

# 4. Sync changes to Git (when ready, never forget)
dotproj sync my-project
```

**Add more files later**:
```bash
# Add new files to existing project
dotproj add my-project        # Interactive selection + creates symlinks
dotproj sync my-project       # Commit changes
```

### 👥 Team Shared Flow

**Team member 1 - Create and share**:
```bash
# 1. 🔒 Create PRIVATE repository first (for sensitive team configs)
#    → GitHub/GitLab: Create private repo for team
#    → Example: https://github.com/team/project-config.git

# 2. Initialize project with Git repo
dotproj init team-project
# → Enter PRIVATE Git repo URL when prompted

# 3. Select team files: .env.example, .vscode, .cursor, etc.
#    ⚠️  SECURITY: Ensure repo is PRIVATE for sensitive files!

# 4. Share with team
dotproj sync team-project     # Pushes to remote repo
```

**Team member 2+ - Load and use**:
```bash
# 1. Go to your project directory
cd /path/to/your-project

# 2. Load team's configurations (clones repo + auto-applies symlinks)
dotproj remote team-project
# → Enter repo URL when prompted: https://github.com/team/project-config.git
# → Automatically creates symlinks in current project directory

# 3. Work and sync changes
# Edit files normally...
dotproj sync team-project     # Commits and pushes your changes
```

## 📖 Commands

```bash
# Essential Commands
dotproj init <project>           # Create new project (includes file selection + symlinks)
dotproj remote <project>         # Clone remote repo + auto-apply symlinks to current dir
dotproj add <project>            # Add more files + create symlinks
dotproj apply <project>          # Create symlinks from stored files (manual re-apply)
dotproj sync <project>           # Commit and push/pull changes

# Management
dotproj list                     # Show all projects
dotproj status <project>         # Show tracked files
dotproj save <project>           # Check symlink integrity

# Setup
dotproj setup                    # Install dotproj
```



## 💡 Use Cases

**React/Next.js**:
```bash
dotproj init my-nextjs-app
# Track: .env.local, .vscode, .cursorrules
```

**Full-Stack**:
```bash
dotproj init fullstack-project  
# Track: .env, .env.local, .vscode, docker-compose.override.yml, .cursorrules
```

**AI/ML with Cursor**:
```bash
dotproj init ai-project
# Track: .cursorrules, .cursor/, .env, .vscode, requirements-dev.txt
```

## 🔗 How It Works

**Symlinks connect project files to centralized storage**:
```
Project Directory                Storage Directory
├── .env → ~/.dotproj/.../env    ├── .env (actual file)
├── .vscode/ → ~/.dotproj/...    ├── .vscode/ (actual files)
├── .cursor/ → ~/.dotproj/...    ├── .cursor/ (actual files)
```

**Benefits**:
- Edit files in project → changes immediately saved to storage
- Delete project files → only removes symlinks, data stays safe
- `dotproj apply` recreates missing symlinks instantly


## 🛡️ Safety & Backup System

- **Smart backups**: One backup per file (e.g., `backups/.env_local.backup`)
- **No clutter**: Backups update in place, no timestamped accumulation
- **Symlink safety**: Deleting project files only removes symlinks
- **Git versioning**: Full history and conflict detection
- **Easy restoration**: Predictable backup names

## 🗂️ File Structure

```
~/.dotproj/
├── config                      # Project configuration
├── dotproj                     # Installed script
└── projects/                   # Project storage
    ├── my-project/
    │   ├── .git/               # Git repository
    │   ├── dotfiles/           # Tracked files (if using dotfiles/ structure)
    │   ├── backups/            # Single backup per file
    │   └── [config files]      # Direct config files (for remote repos)
```

## 🔍 Troubleshooting

**Git not installed**:
```bash
# Ubuntu/Debian: sudo apt install git
# CentOS/RHEL: sudo yum install git  
# Fedora: sudo dnf install git
# macOS: brew install git
```

**Command not found**:
```bash
source ~/.bashrc  # or ~/.zshrc
which dotproj     # Should show: ~/.dotproj/dotproj
```

**Backup/restore files**:
```bash
ls -la backups/   # View backups
cp backups/.env_local.backup .env.local  # Restore if needed
```

**Fix broken symlinks**:
```bash
dotproj save <project>    # Check integrity
dotproj apply <project>   # Fix broken links
```

> **Tip**: Use `dotproj list` to see all projects and `dotproj status <project>` to check tracked files for a specific project.

## 🔄 Updates & Versioning

DotProj follows [Semantic Versioning](https://semver.org/) and provides multiple ways to stay up to date.

### Check Current Version
```bash
dotproj version                  # Shows version + checks for updates
```

### Update DotProj

**Method 1: Built-in update command (Recommended)**
```bash
dotproj update                   # Check and install updates
dotproj update --check           # Only check for updates
dotproj update --force           # Force reinstall latest version
```

**Method 2: Direct update script**
```bash
# One-liner update
bash <(curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/update.sh)

# Download and run
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/update.sh -o update.sh
chmod +x update.sh
./update.sh
```

**Method 3: Reinstall from scratch**
```bash
# Fresh installation (overwrites existing)
bash <(curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/install.sh)
```

### Update Features

- **🔍 Automatic version checking**: `dotproj version` shows available updates
- **📦 Safe updates**: Automatic backup of current version before updating
- **🔄 Rollback support**: Failed updates automatically rollback to previous version
- **📋 Changelog display**: Shows recent changes during update process
- **✅ Verification**: Post-update verification ensures installation success

### Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and changes.

### Release Schedule

- **Patch releases** (1.0.x): Bug fixes, security updates
- **Minor releases** (1.x.0): New features, improvements
- **Major releases** (x.0.0): Breaking changes, major overhauls

### Staying Updated

**Recommended**: Run `dotproj version` periodically to check for updates, or enable notifications in your shell profile:

```bash
# Add to ~/.bashrc or ~/.zshrc for update reminders
alias dotproj-check='dotproj update --check'
```

## 📄 License

MIT License - Copyright (c) 2024 Andre Jr (andrecrjr)
