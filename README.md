# 🎯 DotProj - Project-Specific Configuration Manager

**DotProj** is a developer-centric CLI tool designed to manage project-specific configuration files with Git versioning. It helps keep your development environment settings organized, versioned, and synchronized across multiple machines and projects.

*DotProj uses Git commands (`commit`, `push`, `pull`, `clone`) making it intuitive for developers!*

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/install.sh | bash
```

## Prerequisites:
* **Git** must be installed and configured:
    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"
    ```
* **Curl** must be installed.

## 📋 What It Solves

Eliminates the hassle of manually copying configuration files like:
- **Environment files**: `.env`, `.env.local`, `.env.development`
- **Editor configurations**: `.vscode`, `.cursor`
- **Linting & formatting**: `.eslintrc.json`, `.prettierrc`, `.editorconfig`
- **Build & deployment**: `docker-compose.override.yml`, `Dockerfile.dev`

**Key Features**:
- **Git-like workflow** - familiar commands for developers
- **Smart branch selection** - choose configurations from different branches
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

### 🔧 Basic Individual Flow (Git-like)

**Create new project**:
```bash
# 0. 🔒 IMPORTANT: Create a PRIVATE repository first!
#    For projects with sensitive files (.env, API keys, secrets):
#    → GitHub: Create private repo (avoid adding README)
#    → GitLab: Create private repo 
#    → Example: https://github.com/username/my-project-config.git

# 1. Initialize project (prompts for files)
dotproj init my-project

# 2. Select files when prompted: .env.local, .vscode, .cursor, etc.
#    → Files are copied to storage

# 3. Apply files as symlinks to your project
dotproj commit my-project

# 4. Work normally - changes auto-saved via symlinks

# 5. Push changes to Git (when ready)
dotproj push my-project
```

**Add more files later**:
```bash
# Add new files to existing project
dotproj add my-project        # Interactive selection
dotproj commit my-project     # Apply new files as symlinks
dotproj push my-project       # Push changes to remote
```

### 👥 Team Shared Flow (Git-like)

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

# 4. Apply and push to team
dotproj commit team-project   # Apply files as symlinks
dotproj push team-project     # Push to remote repo
```

**Team member 2+ - Clone and use**:
```bash
# 1. Go to your project directory
cd /path/to/your-project

# 2. Clone team's configurations
dotproj clone team-project
# → Enter repo URL: https://github.com/team/project-config.git
# → Choose branch if multiple available (e.g., dotproj-frontend, dotproj-backend)
# → Optionally apply files immediately

# 3. Work and sync changes
# Edit files normally...
dotproj push team-project     # Push your changes
dotproj pull team-project     # Get latest team changes
```

### 🌟 Advanced Multi-Branch Workflow

**Different configurations per environment/role**:
```bash
# Team has multiple configuration branches:
# - dotproj-frontend (React/Next.js configs)
# - dotproj-backend (Node.js/API configs) 
# - dotproj-fullstack (Complete setup)

# Clone and choose specific branch
dotproj clone my-project https://github.com/team/configs.git
# → Shows: 1) dotproj-frontend ⭐ 2) dotproj-backend ⭐ 3) main
# → Select: 1
# → Gets frontend-specific configs (.vscode React settings, .env.local, etc.)

# Switch to different branch later
dotproj pull my-project
# → Choose different branch if needed
# → Updates to new configuration set
```

## 📖 Commands (Git-like Interface)

```bash
# Essential Commands (Git-like)
dotproj init <project>           # Initialize new project (like 'git init')
dotproj clone <project> [url]    # Clone from remote repo (like 'git clone')
dotproj add <project>            # Add more files to track (like 'git add')
dotproj commit <project>         # Apply files as symlinks (like 'git commit')
dotproj status <project>         # Show tracked files and branch (like 'git status')
dotproj push <project>           # Push changes to remote (like 'git push')
dotproj pull <project>           # Pull latest changes from remote (like 'git pull')

# Management
dotproj list                     # Show all projects
dotproj remove <project>         # Remove project completely

# Setup
dotproj setup                    # Install dotproj
dotproj version                  # Show version and system information
```

### 🔄 Legacy Commands (Deprecated but supported)
```bash
# Old commands still work with deprecation warnings:
dotproj apply <project>          # → Shows warning, runs 'commit'
dotproj sync <project>           # → Shows warning, runs 'push'  
dotproj remote <project>         # → Shows warning, runs 'clone'
dotproj save <project>           # → Shows warning, runs 'status'
```

## 💡 Use Cases

**React/Next.js Frontend**:
```bash
dotproj init my-nextjs-app
# Track: .env.local, .vscode, .cursorrules
dotproj commit my-nextjs-app
dotproj push my-nextjs-app
```

**Full-Stack with Multiple Configs**:
```bash
# Clone with branch selection
dotproj clone fullstack-project https://github.com/team/configs.git
# Choose: dotproj-fullstack branch
# Gets: .env, .env.local, .vscode, docker-compose.override.yml, .cursorrules

# Or create new with specific setup
dotproj init backend-api  
# Track: .env, .env.local, .vscode, docker-compose.yml
dotproj commit backend-api
dotproj push backend-api
```

**AI/ML with Cursor**:
```bash
dotproj clone ai-project https://github.com/team/ai-configs.git
# Choose: dotproj-ai-python branch  
# Gets: .cursorrules, .cursor/, .env, .vscode, requirements-dev.txt
```

**Team Collaboration**:
```bash
# Frontend developer
dotproj clone team-project https://github.com/company/project-config.git
# Selects: dotproj-frontend branch → React/Next.js specific configs

# Backend developer  
dotproj clone team-project https://github.com/company/project-config.git
# Selects: dotproj-backend branch → Node.js/API specific configs
```

## 🔗 How It Works

**Git-like workflow with symlinks**:
```
Project Directory                Storage Directory
├── .env → ~/.dotproj/.../env    ├── .env (actual file)
├── .vscode/ → ~/.dotproj/...    ├── .vscode/ (actual files)
├── .cursor/ → ~/.dotproj/...    ├── .cursor/ (actual files)
```

**Workflow Steps**:
1. **`init`/`clone`**: Set up project and select files/branch
2. **`commit`**: Create symlinks (like staging and committing changes)
3. **`push`**: Sync changes to remote repository
4. **`pull`**: Get latest changes from team/other machines
5. **`status`**: Check current state and tracked files

**Benefits**:
- **Familiar Git commands** for developers
- **Branch-based configurations** for different setups
- Edit files in project → changes immediately saved to storage
- Delete project files → only removes symlinks, data stays safe
- **Multi-branch support** for different environments/roles

## 🌟 Branch Management

**Smart Branch Selection**:
- **Clone**: Always shows available branches for selection
- **Pull**: Choose different branch if multiple remotes available  
- **Status**: Shows current branch being used
- **Persistent**: Selected branch remembered for future operations

**Branch Types**:
- **DotProj branches** (⭐): `dotproj-*` contain project-specific configs
- **Other branches**: May contain shared or general configurations

**Example Branch Structure**:
```
Repository Branches:
├── main                     # General/shared configs
├── dotproj-frontend ⭐      # React/Vue specific configs  
├── dotproj-backend ⭐       # Node.js/API specific configs
├── dotproj-fullstack ⭐     # Complete development setup
└── dotproj-production ⭐    # Production-ready configs
```

## 🛡️ Safety & Backup System

- **Smart backups**: One backup per file (e.g., `backups/.env_local.backup`)
- **No clutter**: Backups update in place, no timestamped accumulation
- **Symlink safety**: Deleting project files only removes symlinks
- **Git versioning**: Full history and conflict detection
- **Branch persistence**: Selected branch remembered across operations
- **Easy restoration**: Predictable backup names

## 🗂️ File Structure

```
~/.dotproj/
├── config                      # Project configuration
│   └── project:branch:dotproj-frontend  # Stores selected branch
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

**Branch issues**:
```bash
dotproj status <project>      # Check current branch
dotproj pull <project>        # Switch branch if needed
```

**Backup/restore files**:
```bash
ls -la backups/   # View backups
cp backups/.env_local.backup .env.local  # Restore if needed
```

**Fix broken symlinks**:
```bash
dotproj status <project>      # Check integrity
dotproj commit <project>      # Fix broken links
```

> **Tip**: Use `dotproj list` to see all projects and `dotproj status <project>` to check tracked files and current branch for a specific project.



## 📄 License

MIT License - Copyright (c) 2024 Andre Jr (andrecrjr)
