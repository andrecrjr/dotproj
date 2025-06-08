#!/bin/bash

# DotProj Release Script
# Helps with version management and creating releases

set -e

CURRENT_VERSION=$(cat VERSION 2>/dev/null || echo "1.0.0")
CHANGELOG_FILE="CHANGELOG.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

print_header() {
    echo -e "${BLUE}🚀 DotProj Release Manager${NC}"
    echo "════════════════════════════════════════════════════════════════"
}

validate_version() {
    local version="$1"
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format. Use semantic versioning (e.g., 1.2.3)"
        return 1
    fi
    return 0
}

increment_version() {
    local version="$1"
    local part="$2"
    
    local major minor patch
    IFS='.' read -r major minor patch <<< "$version"
    
    case "$part" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            print_error "Invalid version part. Use: major, minor, or patch"
            return 1
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

update_changelog() {
    local new_version="$1"
    local date=$(date +%Y-%m-%d)
    
    if [ -f "$CHANGELOG_FILE" ]; then
        print_info "Updating changelog for version $new_version..."
        
        # Create a temporary file with the updated changelog
        local temp_file=$(mktemp)
        
        # Read the changelog and update the unreleased section
        awk -v version="$new_version" -v date="$date" '
        /^## \[Unreleased\]/ {
            print $0
            print ""
            print "### Added"
            print "- (Add new features here for next release)"
            print ""
            print "### Changed"
            print "- (Add changes here for next release)"
            print ""
            print "### Fixed"
            print "- (Add bug fixes here for next release)"
            print ""
            print "## [" version "] - " date
            next
        }
        { print }
        ' "$CHANGELOG_FILE" > "$temp_file"
        
        mv "$temp_file" "$CHANGELOG_FILE"
        print_success "Changelog updated"
    else
        print_warning "Changelog file not found, skipping changelog update"
    fi
}

check_git_status() {
    if [ -d ".git" ]; then
        if ! git diff-index --quiet HEAD --; then
            print_warning "You have uncommitted changes. Consider committing them first."
            echo ""
            git status --short
            echo ""
            echo -n "Continue anyway? (y/N): "
            read -r continue_choice
            if [ "$continue_choice" != "y" ] && [ "$continue_choice" != "Y" ]; then
                echo "Release cancelled."
                exit 1
            fi
        fi
    fi
}

create_release() {
    local new_version="$1"
    local auto_commit="${2:-false}"
    
    print_info "Creating release $new_version..."
    
    # Update VERSION file
    echo "$new_version" > VERSION
    print_success "Updated VERSION file to $new_version"
    
    # Update changelog
    update_changelog "$new_version"
    
    if [ -d ".git" ] && [ "$auto_commit" = "true" ]; then
        print_info "Creating Git commit and tag..."
        
        git add VERSION CHANGELOG.md
        git commit -m "Release version $new_version"
        git tag -a "v$new_version" -m "Release version $new_version"
        
        print_success "Created Git commit and tag v$new_version"
        
        echo ""
        print_info "To push the release:"
        echo "  git push origin main"
        echo "  git push origin v$new_version"
        echo ""
        print_info "To create a GitHub release:"
        echo "  gh release create v$new_version --title \"Release $new_version\" --notes-from-tag"
    fi
    
    print_success "Release $new_version created successfully!"
}

show_usage() {
    echo "DotProj Release Script"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  current                    Show current version"
    echo "  bump <major|minor|patch>   Bump version and create release"
    echo "  set <version>              Set specific version and create release"
    echo "  changelog                  Show recent changelog entries"
    echo ""
    echo "Options:"
    echo "  --no-commit               Don't create Git commit and tag"
    echo "  --help                    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 current                # Show current version"
    echo "  $0 bump patch             # Bump patch version (1.0.0 -> 1.0.1)"
    echo "  $0 bump minor             # Bump minor version (1.0.0 -> 1.1.0)"
    echo "  $0 bump major             # Bump major version (1.0.0 -> 2.0.0)"
    echo "  $0 set 1.2.3              # Set version to 1.2.3"
    echo "  $0 set 1.2.3 --no-commit  # Set version without Git operations"
}

main() {
    local command="$1"
    local auto_commit=true
    
    # Parse global options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-commit)
                auto_commit=false
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                break
                ;;
        esac
    done
    
    case "$command" in
        current)
            print_header
            echo "Current version: $CURRENT_VERSION"
            ;;
        bump)
            local part="$2"
            if [ -z "$part" ]; then
                print_error "Version part required (major, minor, or patch)"
                show_usage
                exit 1
            fi
            
            print_header
            echo "Current version: $CURRENT_VERSION"
            
            local new_version
            if ! new_version=$(increment_version "$CURRENT_VERSION" "$part"); then
                exit 1
            fi
            
            echo "New version: $new_version"
            echo ""
            
            check_git_status
            create_release "$new_version" "$auto_commit"
            ;;
        set)
            local new_version="$2"
            if [ -z "$new_version" ]; then
                print_error "Version required"
                show_usage
                exit 1
            fi
            
            if ! validate_version "$new_version"; then
                exit 1
            fi
            
            print_header
            echo "Current version: $CURRENT_VERSION"
            echo "New version: $new_version"
            echo ""
            
            check_git_status
            create_release "$new_version" "$auto_commit"
            ;;
        changelog)
            print_header
            if [ -f "$CHANGELOG_FILE" ]; then
                echo "Recent changelog entries:"
                echo ""
                head -50 "$CHANGELOG_FILE"
            else
                print_error "Changelog file not found"
                exit 1
            fi
            ;;
        "")
            print_error "Command required"
            show_usage
            exit 1
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

main "$@" 