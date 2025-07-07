# Changelog

All notable changes to DotProj will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- (Add new features here for next release)

### Changed
- (Add changes here for next release)

### Fixed
- (Add bug fixes here for next release)

## [1.2.2] - 2025-07-07

### Added
- (Add new features here for next release)

### Changed
- (Add changes here for next release)

### Fixed
- (Add bug fixes here for next release)

## [1.2.1] - 2025-07-07

### Added
- (Add new features here for next release)

### Changed
- (Add changes here for next release)

### Fixed
- (Add bug fixes here for next release)

## [1.2.0] - 2025-07-07

### Added
- (Add new features here for next release)

### Changed
- (Add changes here for next release)

### Fixed
- (Add bug fixes here for next release)

## [1.1.0] - 2025-07-06

### Added 
- Improvements for only and multi projects
- Dotproj status now says that you should commit/push your project after edits

## [1.0.0] - 2025-06-08

### Added
- Git-like commands to update your remote repository
- Update system with `update.sh` script
- Version management with `VERSION` file
- Automatic backup creation during updates
- Changelog tracking for version history
- Enhanced version command with update checking
- Initial release of DotProj
- Project-specific dotfiles management
- Git integration for version control
- Symlink-based file management
- Remote repository support
- Cross-platform support (Linux, macOS, Windows WSL)
- Automatic backup system for existing files
- Security warnings for sensitive files
- Interactive dotfile selection
- Project-specific Git branches

### Features
- **Project Management**: Initialize and manage multiple project configurations
- **Git Integration**: Full Git support with remote synchronization
- **Symlink Management**: Automatic symlink creation and integrity checking
- **Backup System**: Automatic backup of existing files before linking
- **Security**: Built-in warnings for sensitive files and private repository recommendations
- **Cross-Platform**: Works on Linux, macOS, and Windows WSL
- **Interactive Setup**: User-friendly prompts for configuration

---

## Version Numbering

DotProj follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backwards compatible manner  
- **PATCH** version when you make backwards compatible bug fixes

## Update Instructions

To update DotProj to the latest version:

```bash
# Check for updates
bash <(curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/update.sh) --check

# Install updates
bash <(curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/update.sh)

# Force reinstall latest version
bash <(curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/update.sh) --force
```

Or if you have DotProj installed locally:

```bash
# Download and run update script
curl -fsSL https://raw.githubusercontent.com/andrecrjr/dotproj/master/update.sh -o update.sh
chmod +x update.sh
./update.sh
``` 
