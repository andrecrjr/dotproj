# 🎯 DotProj - Project-Specific Configuration Manager

**DotProj** is a developer-focused CLI tool that manages project-specific configuration files with Git versioning. Keep your development environment settings organized, versioned, and synchronized across machines and projects.

## 📋 What It Solves

Eliminates the hassle of manually copying configuration files like:
- **Environment files**: `.env`, `.env.local`, `.env.development`
- **Editor configurations**: `.vscode/settings.json`, `.cursorrules`, `.cursor/`
- **Linting & formatting**: `.eslintrc.json`, `.prettierrc`, `.editorconfig`
- **Build & deployment**: `docker-compose.override.yml`, `Dockerfile.dev`

**Key Features**:
- **Centralizes** configurations in organized storage
- **Symlinks** files for real-time synchronization
- **Smart backups** - one backup per file, no clutter
- **Git versioning** for team collaboration
- **Cross-machine sync** via remote repositories

**Install**: `curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/install.sh | bash`

## 🚀 Essential Workflows

**Prerequisites**: Git must be installed and configured
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 🔧 Basic Individual Flow

**Create new project**:
```bash
# 1. Initialize project (prompts for files, creates symlinks automatically)
dotproj init my-project

# 2. Select files when prompted: .env.local, .vscode, .cursorrules, etc.
#    → Files are copied to storage and symlinked back to project

# 3. Work normally - changes auto-saved via symlinks

# 4. Sync changes to Git (when ready)
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
# 1. Create project with Git repo
dotproj init team-project
# → Enter Git repo URL when prompted: https://github.com/team/project-config.git

# 2. Select team files: .env.example, .vscode, .cursorrules, etc.

# 3. Share with team
dotproj sync team-project     # Pushes to remote repo
```

**Team member 2+ - Load and use**:
```bash
# 1. Load from team's repository
dotproj remote team-project https://github.com/team/project-config.git

# 2. Apply to your project
dotproj apply team-project    # Creates symlinks from team's files

# 3. Work and sync changes
# Edit files normally...
dotproj sync team-project     # Commits and pushes your changes
```

## 📖 Commands

```bash
# Essential Commands
dotproj init <project>           # Create new project (includes file selection + symlinks)
dotproj remote <project> <url>   # Load from team repository
dotproj add <project>            # Add more files + create symlinks
dotproj apply <project>          # Create symlinks from stored files (for remote projects)
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
# Track: .env.local, .vscode, .eslintrc.json, .prettierrc, .cursorrules
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
├── .env → ~/dotfiles/.../env    ├── .env (actual file)
├── .vscode/ → ~/dotfiles/...    ├── .vscode/ (actual files)
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
└── dotproj                     # Installed script

~/dotfiles/projects/
├── my-project/
│   ├── .git/                   # Git repository
│   ├── dotfiles/               # Tracked files
│   └── backups/                # Single backup per file
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

## 📄 License

MIT License - Copyright (c) 2024 Andre Jr (andrecrjr)
