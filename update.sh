#!/bin/bash

# DotProj Update Script
# Updates DotProj to the latest version from GitHub

set -e

REPO_URL="https://api.github.com/repos/andrecrjr/dotproj"
RAW_URL="https://raw.githubusercontent.com/andrecrjr/dotproj"
INSTALL_DIR="$HOME/.dotproj"
BACKUP_DIR="$INSTALL_DIR/backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}🔄 DotProj Update Manager${NC}"
    echo "════════════════════════════════════════════════════════════════"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

check_requirements() {
    print_info "Checking system requirements..."
    
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required but not installed."
        echo ""
        echo "📦 Please install curl first:"
        echo "  • Ubuntu/Debian: sudo apt update && sudo apt install curl"
        echo "  • CentOS/RHEL:   sudo yum install curl"
        echo "  • Fedora:        sudo dnf install curl"
        echo "  • macOS:         curl is usually pre-installed"
        echo "  • Arch Linux:    sudo pacman -S curl"
        exit 1
    fi
    
    if ! command -v jq >/dev/null 2>&1; then
        print_warning "jq is not installed. Version comparison will be limited."
        echo "  Consider installing jq for better version handling:"
        echo "  • Ubuntu/Debian: sudo apt install jq"
        echo "  • macOS:         brew install jq"
        echo ""
    fi
    
    print_success "System requirements check passed"
}

get_current_version() {
    if [ -f "$INSTALL_DIR/VERSION" ]; then
        cat "$INSTALL_DIR/VERSION"
    elif [ -f "$INSTALL_DIR/dotproj" ]; then
        # Fallback: extract version from script
        grep "Version:" "$INSTALL_DIR/dotproj" | head -1 | sed 's/.*Version: //' | tr -d '"'
    else
        echo "unknown"
    fi
}

get_latest_version() {
    print_info "Checking for latest version..."
    
    # Try to get latest release from GitHub API
    if command -v jq >/dev/null 2>&1; then
        latest_version=$(curl -s "$REPO_URL/releases/latest" | jq -r '.tag_name // empty' 2>/dev/null)
        if [ -n "$latest_version" ] && [ "$latest_version" != "null" ]; then
            echo "$latest_version"
            return 0
        fi
    fi
    
    # Fallback: get version from master branch
    latest_version=$(curl -s "$RAW_URL/master/VERSION" 2>/dev/null || echo "")
    if [ -n "$latest_version" ]; then
        echo "$latest_version"
        return 0
    fi
    
    print_error "Could not determine latest version"
    return 1
}

version_compare() {
    # Simple version comparison (assumes semantic versioning)
    local v1="$1"
    local v2="$2"
    
    # Remove 'v' prefix if present
    v1=${v1#v}
    v2=${v2#v}
    
    if [ "$v1" = "$v2" ]; then
        return 0  # Equal
    fi
    
    # Use sort -V if available for proper version sorting
    if command -v sort >/dev/null 2>&1 && sort --version-sort /dev/null >/dev/null 2>&1; then
        local sorted=$(printf "%s\n%s" "$v1" "$v2" | sort -V)
        if [ "$(echo "$sorted" | head -1)" = "$v1" ]; then
            return 1  # v1 < v2
        else
            return 2  # v1 > v2
        fi
    else
        # Fallback: simple string comparison
        if [ "$v1" \< "$v2" ]; then
            return 1  # v1 < v2
        else
            return 2  # v1 > v2
        fi
    fi
}

create_backup() {
    local current_version="$1"
    
    print_info "Creating backup of current installation..."
    
    mkdir -p "$BACKUP_DIR"
    local backup_file="$BACKUP_DIR/dotproj-$current_version-$(date +%Y%m%d-%H%M%S).backup"
    
    if [ -f "$INSTALL_DIR/dotproj" ]; then
        cp "$INSTALL_DIR/dotproj" "$backup_file"
        print_success "Backup created: $backup_file"
        echo "$backup_file"
    else
        print_warning "No existing installation found to backup"
        echo ""
    fi
}

download_latest() {
    local version="$1"
    local temp_dir
    temp_dir=$(mktemp -d)
    
    print_info "Downloading DotProj version $version..."
    
    # Download main script
    if ! curl -fsSL "$RAW_URL/master/dotproj" -o "$temp_dir/dotproj"; then
        print_error "Failed to download dotproj script"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Download VERSION file
    if ! curl -fsSL "$RAW_URL/master/VERSION" -o "$temp_dir/VERSION"; then
        print_warning "Failed to download VERSION file, using version from script"
    fi
    
    # Make executable
    chmod +x "$temp_dir/dotproj"
    
    echo "$temp_dir"
}

install_update() {
    local temp_dir="$1"
    local backup_file="$2"
    
    print_info "Installing update..."
    
    # Ensure install directory exists
    mkdir -p "$INSTALL_DIR"
    
    # Install new files
    cp "$temp_dir/dotproj" "$INSTALL_DIR/dotproj"
    if [ -f "$temp_dir/VERSION" ]; then
        cp "$temp_dir/VERSION" "$INSTALL_DIR/VERSION"
    fi
    
    # Clean up temp directory
    rm -rf "$temp_dir"
    
    print_success "Update installed successfully!"
}

rollback() {
    local backup_file="$1"
    
    if [ -n "$backup_file" ] && [ -f "$backup_file" ]; then
        print_info "Rolling back to previous version..."
        cp "$backup_file" "$INSTALL_DIR/dotproj"
        print_success "Rollback completed"
    else
        print_error "No backup file available for rollback"
    fi
}

show_changelog() {
    local from_version="$1"
    local to_version="$2"
    
    print_info "Checking for changelog..."
    
    # Try to fetch and display changelog
    if curl -s "$RAW_URL/master/CHANGELOG.md" >/dev/null 2>&1; then
        echo ""
        echo "📋 Recent Changes:"
        echo "─────────────────"
        curl -s "$RAW_URL/master/CHANGELOG.md" | head -20
        echo ""
    fi
}

main() {
    local force_update=false
    local check_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force|-f)
                force_update=true
                shift
                ;;
            --check|-c)
                check_only=true
                shift
                ;;
            --help|-h)
                echo "DotProj Update Script"
                echo ""
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --check, -c     Check for updates without installing"
                echo "  --force, -f     Force update even if already up to date"
                echo "  --help, -h      Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0              # Check and install updates"
                echo "  $0 --check      # Only check for updates"
                echo "  $0 --force      # Force reinstall latest version"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    print_header
    
    # Check system requirements
    check_requirements
    echo ""
    
    # Get current version
    local current_version
    current_version=$(get_current_version)
    print_info "Current version: $current_version"
    
    # Get latest version
    local latest_version
    if ! latest_version=$(get_latest_version); then
        exit 1
    fi
    print_info "Latest version: $latest_version"
    echo ""
    
    # Compare versions
    if [ "$current_version" = "$latest_version" ] && [ "$force_update" = false ]; then
        print_success "DotProj is already up to date!"
        if [ "$check_only" = true ]; then
            exit 0
        fi
        echo ""
        echo -n "Reinstall anyway? (y/N): "
        read -r reinstall_choice
        if [ "$reinstall_choice" != "y" ] && [ "$reinstall_choice" != "Y" ]; then
            echo "Update cancelled."
            exit 0
        fi
    elif [ "$check_only" = true ]; then
        print_info "Update available: $current_version → $latest_version"
        echo ""
        echo "Run without --check to install the update."
        exit 0
    fi
    
    # Show changelog if available
    show_changelog "$current_version" "$latest_version"
    
    # Confirm update
    if [ "$force_update" = false ]; then
        echo -n "Update DotProj from $current_version to $latest_version? (Y/n): "
        read -r update_choice
        if [ "$update_choice" = "n" ] || [ "$update_choice" = "N" ]; then
            echo "Update cancelled."
            exit 0
        fi
    fi
    
    echo ""
    
    # Create backup
    local backup_file
    backup_file=$(create_backup "$current_version")
    
    # Download latest version
    local temp_dir
    if ! temp_dir=$(download_latest "$latest_version"); then
        print_error "Download failed"
        exit 1
    fi
    
    # Install update
    if ! install_update "$temp_dir" "$backup_file"; then
        print_error "Installation failed"
        rollback "$backup_file"
        exit 1
    fi
    
    echo ""
    print_success "DotProj has been updated to version $latest_version!"
    echo ""
    print_info "Verifying installation..."
    
    # Verify installation
    if [ -f "$INSTALL_DIR/dotproj" ] && "$INSTALL_DIR/dotproj" version >/dev/null 2>&1; then
        print_success "Installation verified successfully"
        echo ""
        echo "🎉 Update complete!"
        echo ""
        echo "💡 What's next:"
        echo "  • Run 'dotproj version' to confirm the new version"
        echo "  • Check 'dotproj --help' for any new commands"
        echo "  • Your existing projects and configurations are preserved"
        
        if [ -n "$backup_file" ]; then
            echo ""
            echo "📦 Backup saved at: $backup_file"
            echo "   (You can safely delete this after confirming everything works)"
        fi
    else
        print_error "Installation verification failed"
        rollback "$backup_file"
        exit 1
    fi
}

# Run main function with all arguments
main "$@" 