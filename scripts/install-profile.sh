#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PROFILES_DIR="$PROJECT_DIR/profiles"

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to check if Ollama container is running
check_ollama() {
    if ! docker ps | grep -q "local-ai-ollama"; then
        print_error "Ollama container is not running"
        print_info "Start it with: docker compose up -d"
        exit 1
    fi
    print_success "Ollama container is running"
}

# Function to list available profiles
list_profiles() {
    echo ""
    print_info "Available profiles:"
    for profile in "$PROFILES_DIR"/*.json; do
        if [ -f "$profile" ]; then
            name=$(basename "$profile" .json)
            description=$(python3 -c "import json, sys; print(json.load(open('$profile'))['description'])" 2>/dev/null || echo "")
            echo "  • $name - $description"
        fi
    done
    echo ""
}

# Function to install models from profile
install_profile() {
    local profile_name=$1
    local profile_file="$PROFILES_DIR/${profile_name}.json"

    if [ ! -f "$profile_file" ]; then
        print_error "Profile '$profile_name' not found at $profile_file"
        list_profiles
        exit 1
    fi

    print_info "Installing profile: $profile_name"

    # Parse profile and extract models
    local models=$(python3 -c "
import json
with open('$profile_file') as f:
    profile = json.load(f)
    for model in profile['models']:
        # Only append tag if model name doesn't already include a version
        name = model['name']
        if ':' not in name:
            name = f\"{name}:{model.get('tag', 'latest')}\"
        print(f\"{name} {model.get('purpose', '')}\")
" 2>/dev/null)

    if [ -z "$models" ]; then
        print_error "Failed to parse profile"
        exit 1
    fi

    echo ""
    print_info "Models to install:"
    echo "$models" | while read -r line; do
        model_name=$(echo "$line" | cut -d' ' -f1)
        purpose=$(echo "$line" | cut -d' ' -f2-)
        echo "  • $model_name - $purpose"
    done
    echo ""

    # Install each model
    echo "$models" | while read -r line; do
        model_name=$(echo "$line" | cut -d' ' -f1)
        # Remove :latest suffix if present for display
        display_name=$(echo "$model_name" | sed 's/:latest$//')

        print_info "Pulling $display_name..."
        if docker exec local-ai-ollama ollama pull "$model_name"; then
            print_success "Installed $display_name"
        else
            print_error "Failed to install $display_name"
        fi
        echo ""
    done

    print_success "Profile '$profile_name' installation complete!"
    echo ""
    print_info "Verify installed models:"
    docker exec local-ai-ollama ollama list
}

# Main script
main() {
    if [ $# -eq 0 ]; then
        print_error "Usage: $0 <profile-name>"
        list_profiles
        exit 1
    fi

    local profile_name=$1

    print_info "Local AI Profile Installer"
    echo ""

    check_ollama
    install_profile "$profile_name"

    echo ""
    print_success "All done! Open WebUI is ready at http://localhost:3000"
}

main "$@"
