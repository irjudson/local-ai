# Local AI Setup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build Docker-based local AI stack with Ollama + Open WebUI, model profiles, and helper scripts

**Architecture:** Two-container Docker Compose stack (Ollama runtime + Open WebUI frontend) with shared network and bind-mounted data directory. Model profiles (JSON) define recommended model sets. Shell script automates profile installation.

**Tech Stack:** Docker Compose, Ollama, Open WebUI, Bash, JSON

---

## Task 1: Create .gitignore

**Files:**
- Create: `.gitignore`

**Step 1: Write .gitignore content**

Create `.gitignore` with:

```gitignore
# Environment
.env

# Data directory (models and conversations)
data/

# macOS
.DS_Store

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
```

**Step 2: Verify file exists**

Run: `cat .gitignore`
Expected: File contents displayed

**Step 3: Commit**

```bash
git add .gitignore
git commit -m "feat: add .gitignore for data and environment files"
```

---

## Task 2: Create docker-compose.yml

**Files:**
- Create: `docker-compose.yml`

**Step 1: Write docker-compose.yml**

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  ollama:
    image: ollama/ollama:latest
    container_name: local-ai-ollama
    ports:
      - "${OLLAMA_PORT:-11434}:11434"
    volumes:
      - ./data/ollama:/root/.ollama
    restart: unless-stopped
    networks:
      - local-ai-network

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: local-ai-webui
    ports:
      - "${WEBUI_PORT:-3000}:8080"
    volumes:
      - ./data/open-webui:/app/backend/data
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    restart: unless-stopped
    depends_on:
      - ollama
    networks:
      - local-ai-network

networks:
  local-ai-network:
    driver: bridge
```

**Step 2: Validate YAML syntax**

Run: `docker compose config`
Expected: Parsed configuration displayed without errors

**Step 3: Commit**

```bash
git add docker-compose.yml
git commit -m "feat: add docker-compose configuration for Ollama and Open WebUI"
```

---

## Task 3: Create .env.example

**Files:**
- Create: `.env.example`

**Step 1: Write .env.example**

Create `.env.example`:

```bash
# Port Configuration
WEBUI_PORT=3000
OLLAMA_PORT=11434

# Optional: Resource Limits (uncomment for 16GB machines)
# Uncomment these lines if you want to limit memory usage:
# COMPOSE_PROFILES=resource-limited
# OLLAMA_MEM_LIMIT=8g
# WEBUI_MEM_LIMIT=2g

# Note: After editing, copy this file to .env:
#   cp .env.example .env
```

**Step 2: Verify file exists**

Run: `cat .env.example`
Expected: File contents displayed

**Step 3: Create local .env file**

Run: `cp .env.example .env`
Expected: `.env` file created (will be git-ignored)

**Step 4: Commit**

```bash
git add .env.example
git commit -m "feat: add environment configuration template"
```

---

## Task 4: Create profile directory and fast profile

**Files:**
- Create: `profiles/fast.json`

**Step 1: Create profiles directory**

Run: `mkdir -p profiles`
Expected: Directory created

**Step 2: Write fast profile**

Create `profiles/fast.json`:

```json
{
  "name": "fast",
  "description": "Quick models for daily tasks - CPU-friendly, sub-second responses",
  "models": [
    {
      "name": "llama3.2:3b",
      "tag": "latest",
      "purpose": "Fast general chat"
    },
    {
      "name": "phi3:mini",
      "tag": "latest",
      "purpose": "Fast code assistance"
    }
  ],
  "recommended_for": [
    "Quick questions",
    "Code completion",
    "Daily tasks",
    "16GB RAM machines"
  ],
  "size_estimate": "~4GB total"
}
```

**Step 3: Validate JSON syntax**

Run: `python3 -m json.tool profiles/fast.json`
Expected: Pretty-printed JSON without errors

**Step 4: Commit**

```bash
git add profiles/fast.json
git commit -m "feat: add fast profile with lightweight models"
```

---

## Task 5: Create balanced profile

**Files:**
- Create: `profiles/balanced.json`

**Step 1: Write balanced profile**

Create `profiles/balanced.json`:

```json
{
  "name": "balanced",
  "description": "Best performance/quality trade-off - recommended default",
  "models": [
    {
      "name": "qwen2.5-coder:7b",
      "tag": "latest",
      "purpose": "Code generation and explanation"
    },
    {
      "name": "llama3.1:8b",
      "tag": "latest",
      "purpose": "General chat and reasoning"
    }
  ],
  "recommended_for": [
    "Code development",
    "Technical writing",
    "Problem solving",
    "Most users"
  ],
  "size_estimate": "~9GB total"
}
```

**Step 2: Validate JSON syntax**

Run: `python3 -m json.tool profiles/balanced.json`
Expected: Pretty-printed JSON without errors

**Step 3: Commit**

```bash
git add profiles/balanced.json
git commit -m "feat: add balanced profile with recommended models"
```

---

## Task 6: Create quality profile

**Files:**
- Create: `profiles/quality.json`

**Step 1: Write quality profile**

Create `profiles/quality.json`:

```json
{
  "name": "quality",
  "description": "Higher quality models for important work - slower but better results",
  "models": [
    {
      "name": "qwen2.5:14b",
      "tag": "latest",
      "purpose": "Better reasoning and complex tasks"
    },
    {
      "name": "deepseek-coder-v2:16b",
      "tag": "latest",
      "purpose": "Complex code generation"
    }
  ],
  "recommended_for": [
    "Important code reviews",
    "Complex problem solving",
    "Detailed explanations",
    "When you have time to wait"
  ],
  "size_estimate": "~18GB total",
  "notes": "May require memory limits on 16GB machines"
}
```

**Step 2: Validate JSON syntax**

Run: `python3 -m json.tool profiles/quality.json`
Expected: Pretty-printed JSON without errors

**Step 3: Commit**

```bash
git add profiles/quality.json
git commit -m "feat: add quality profile with larger models"
```

---

## Task 7: Create all-rounders profile

**Files:**
- Create: `profiles/all-rounders.json`

**Step 1: Write all-rounders profile**

Create `profiles/all-rounders.json`:

```json
{
  "name": "all-rounders",
  "description": "Single versatile model for both code and chat",
  "models": [
    {
      "name": "qwen2.5-coder:14b",
      "tag": "latest",
      "purpose": "Code and general chat"
    }
  ],
  "recommended_for": [
    "Simplest setup",
    "One model for everything",
    "Users who want fewer choices"
  ],
  "size_estimate": "~9GB total"
}
```

**Step 2: Validate JSON syntax**

Run: `python3 -m json.tool profiles/all-rounders.json`
Expected: Pretty-printed JSON without errors

**Step 3: Commit**

```bash
git add profiles/all-rounders.json
git commit -m "feat: add all-rounders profile with single versatile model"
```

---

## Task 8: Create install-profile.sh script

**Files:**
- Create: `scripts/install-profile.sh`

**Step 1: Create scripts directory**

Run: `mkdir -p scripts`
Expected: Directory created

**Step 2: Write install-profile.sh script**

Create `scripts/install-profile.sh`:

```bash
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
        print(f\"{model['name']}:{model.get('tag', 'latest')} {model.get('purpose', '')}\")
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
```

**Step 3: Make script executable**

Run: `chmod +x scripts/install-profile.sh`
Expected: Script is now executable

**Step 4: Test script help (dry run)**

Run: `./scripts/install-profile.sh`
Expected: Shows usage message and lists available profiles

**Step 5: Commit**

```bash
git add scripts/install-profile.sh
git commit -m "feat: add profile installation script"
```

---

## Task 9: Create README.md with smart-brevity

**Files:**
- Create: `README.md`

**Step 1: Write README.md**

Create `README.md`:

```markdown
# Local AI Setup

**What it is:** Docker-based Ollama + Open WebUI stack for private, offline AI

**Why it matters:** Run AI models locally without cloud dependencies, data stays private

**Bottom line:** Up and running in 5 minutes

## Quick Start

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Start containers
docker compose up -d

# 3. Install models (choose a profile)
./scripts/install-profile.sh balanced

# 4. Open browser
open http://localhost:3000
```

## Profiles

Choose based on your needs:

- **fast** - Quick responses (3B models, ~4GB)
  - Best for: Daily quick tasks, 16GB RAM machines

- **balanced** - Best trade-off (7-8B models, ~9GB) ⭐ Recommended
  - Best for: Code development, most users

- **quality** - Better results (14-16B models, ~18GB)
  - Best for: Important work, complex problems

- **all-rounders** - Single model (14B, ~9GB)
  - Best for: Simplest setup, one model for everything

## Requirements

- Docker Desktop installed and running
- 16GB RAM minimum
- 20-50GB free disk space (depending on profiles)
- macOS, Linux, or Windows with WSL2

## Documentation

- [Setup Guide](docs/setup-guide.md) - Detailed installation steps
- [Model Selection](docs/model-selection.md) - Profile explanations and custom profiles
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Custom Profiles](docs/profiles.md) - Create team-specific profiles

## Management

**View installed models:**
```bash
docker exec local-ai-ollama ollama list
```

**Stop services:**
```bash
docker compose down
```

**Update containers:**
```bash
docker compose pull
docker compose up -d
```

**Backup conversations:**
```bash
tar -czf backup-$(date +%Y%m%d).tar.gz data/open-webui/
```

## What Gets Version Controlled

✅ Configuration files (docker-compose.yml, .env.example)
✅ Documentation
✅ Profiles
✅ Scripts
❌ Downloaded models (data/ollama)
❌ Conversations (data/open-webui)
❌ Local environment (.env)

## Project Structure

```
local-ai/
├── docker-compose.yml      # Container setup
├── .env.example            # Config template
├── profiles/               # Model profiles
├── scripts/                # Helper scripts
├── docs/                   # Documentation
└── data/                   # Models & conversations (git-ignored)
```

## Contributing

**Add custom profiles:** Create JSON in `profiles/` and submit PR

**Report issues:** Open issue with Docker version, OS, and error output

**Improve docs:** PRs welcome for clarity, accuracy, examples

## License

MIT - Use freely for company or personal projects
```

**Step 2: Verify file renders correctly**

Run: `cat README.md | head -20`
Expected: First 20 lines displayed correctly

**Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add README with quick start and profiles"
```

---

## Task 10: Create setup-guide.md

**Files:**
- Create: `docs/setup-guide.md`

**Step 1: Write setup-guide.md**

Create `docs/setup-guide.md`:

```markdown
# Setup Guide

**Goal:** Get Local AI running in under 10 minutes

**Time:** 5-10 minutes (plus model download time)

**Prerequisites:** Docker Desktop installed and running

---

## Step 1: Verify Docker

Check Docker is running:

```bash
docker --version
docker compose version
```

**Expected output:**
```
Docker version 24.0+
Docker Compose version 2.20+
```

**If not installed:** Download from https://www.docker.com/products/docker-desktop

---

## Step 2: Clone or Create Project

**Option A - Clone from git:**
```bash
git clone <your-repo-url> local-ai
cd local-ai
```

**Option B - Start fresh:**
```bash
mkdir local-ai
cd local-ai
# Copy all files from company repo
```

---

## Step 3: Configure Environment

```bash
cp .env.example .env
```

**Optional:** Edit `.env` to change ports:
```bash
# Default ports work for most users
WEBUI_PORT=3000
OLLAMA_PORT=11434
```

**For 16GB machines with memory pressure:**
Uncomment memory limits in `.env`

---

## Step 4: Start Containers

```bash
docker compose up -d
```

**Expected output:**
```
✔ Container local-ai-ollama  Started
✔ Container local-ai-webui   Started
```

**Verify containers running:**
```bash
docker ps
```

Should show both `local-ai-ollama` and `local-ai-webui` containers.

---

## Step 5: Install Models

Choose a profile and install:

```bash
# For most users (recommended)
./scripts/install-profile.sh balanced

# For quick/light setup
./scripts/install-profile.sh fast

# For best quality
./scripts/install-profile.sh quality

# For simplest setup
./scripts/install-profile.sh all-rounders
```

**Download time:**
- Fast: 2-5 minutes
- Balanced: 5-10 minutes
- Quality: 10-20 minutes
- All-rounders: 5-10 minutes

---

## Step 6: Open Web Interface

Open browser to: http://localhost:3000

**First time setup:**
1. Create an account (local only, no internet required)
2. Select a model from dropdown
3. Start chatting!

---

## Verification

Test your setup:

**1. Check models loaded:**
```bash
docker exec local-ai-ollama ollama list
```

Should show your installed models.

**2. Test Ollama API:**
```bash
curl http://localhost:11434/api/tags
```

Should return JSON with model list.

**3. Test Web UI:**
- Go to http://localhost:3000
- Send message: "Hello, are you working?"
- Should get response

---

## Common Issues

**Container fails to start:**
```bash
# Check logs
docker logs local-ai-ollama
docker logs local-ai-webui

# Restart
docker compose down
docker compose up -d
```

**Port already in use:**
Edit `.env` and change ports:
```bash
WEBUI_PORT=3001
OLLAMA_PORT=11435
```

**Models downloading slowly:**
This is normal. Large models take time:
- 3B model: ~2GB
- 7B model: ~4-5GB
- 14B model: ~8-10GB

**Can't access Web UI:**
- Verify containers running: `docker ps`
- Check port: `curl http://localhost:3000`
- Try: http://127.0.0.1:3000

---

## Next Steps

- [Choose different models](model-selection.md)
- [Create custom profiles](profiles.md)
- [Troubleshooting guide](troubleshooting.md)
```

**Step 2: Verify file exists**

Run: `cat docs/setup-guide.md | head -20`
Expected: First 20 lines displayed

**Step 3: Commit**

```bash
git add docs/setup-guide.md
git commit -m "docs: add detailed setup guide"
```

---

## Task 11: Create model-selection.md

**Files:**
- Create: `docs/model-selection.md`

**Step 1: Write model-selection.md**

Create `docs/model-selection.md`:

```markdown
# Model Selection Guide

**Purpose:** Understand profiles and choose the right models for your needs

---

## Profile Comparison

| Profile | Models | Size | Speed | Quality | Best For |
|---------|--------|------|-------|---------|----------|
| **fast** | 2x (3B) | ~4GB | ⚡⚡⚡ | ⭐⭐ | Quick tasks, low RAM |
| **balanced** ⭐ | 2x (7-8B) | ~9GB | ⚡⚡ | ⭐⭐⭐ | Most users, best trade-off |
| **quality** | 2x (14-16B) | ~18GB | ⚡ | ⭐⭐⭐⭐ | Important work, have time |
| **all-rounders** | 1x (14B) | ~9GB | ⚡⚡ | ⭐⭐⭐ | Simplest setup |

---

## Use Case Recommendations

### Code Development
**Best:** `balanced` or `quality`
- Use qwen2.5-coder or deepseek-coder-v2
- Good at: code generation, explanation, debugging
- Not so good at: general knowledge, creative writing

### General Chat
**Best:** `balanced` or `fast`
- Use llama3.1 or llama3.2
- Good at: conversation, questions, summarization
- Not so good at: complex code, math

### Learning & Experimentation
**Best:** `fast` first, then try others
- Start small, upgrade as needed
- Compare model responses
- Find what works for your use case

### Production Work
**Best:** `quality` or `balanced`
- Worth the wait for better output
- Fewer mistakes to fix later
- Use fast profile for drafts, quality for finals

---

## Detailed Profile Info

### Fast Profile

**Models:**
- `llama3.2:3b` - General chat, quick answers
- `phi3:mini` - Code assistance, technical tasks

**Performance:** 1-3 seconds per response

**RAM usage:** ~2-3GB

**When to use:**
- Quick questions during coding
- Need instant responses
- Running on 16GB RAM machine
- Learning the system

**Limitations:**
- Less accurate on complex problems
- Shorter context window
- May miss nuances

---

### Balanced Profile ⭐ Recommended

**Models:**
- `qwen2.5-coder:7b` - Code generation, debugging
- `llama3.1:8b` - General reasoning, chat

**Performance:** 3-7 seconds per response

**RAM usage:** ~4-6GB

**When to use:**
- Daily development work
- Most tasks
- Good performance + quality balance
- Default choice for teams

**Why recommended:**
- Best trade-off for most users
- Fast enough for development flow
- Good quality output
- Works well on 16GB RAM

---

### Quality Profile

**Models:**
- `qwen2.5:14b` - Complex reasoning, detailed analysis
- `deepseek-coder-v2:16b` - Advanced code tasks

**Performance:** 7-15+ seconds per response

**RAM usage:** ~8-10GB

**When to use:**
- Code reviews
- Important decisions
- Complex problems
- Have time to wait

**Considerations:**
- May need memory limits on 16GB RAM
- Slow on CPU-only machines
- Best with 32GB+ RAM

---

### All-Rounders Profile

**Models:**
- `qwen2.5-coder:14b` - Does both code and chat well

**Performance:** 5-10 seconds per response

**RAM usage:** ~6-8GB

**When to use:**
- Want simplest setup
- Don't want to choose models
- One model for everything
- Limited disk space

**Trade-offs:**
- Single point of failure
- Not specialized for specific tasks
- But very convenient

---

## Installing Multiple Profiles

You can install multiple profiles:

```bash
# Start with fast for testing
./scripts/install-profile.sh fast

# Add balanced for daily work
./scripts/install-profile.sh balanced

# Add quality for important tasks
./scripts/install-profile.sh quality
```

**Disk space needed:** Sum of all profile sizes

**Switching models:** In Web UI, select from dropdown

---

## Custom Profiles

Create your own `profiles/custom.json`:

```json
{
  "name": "custom",
  "description": "My custom model selection",
  "models": [
    {
      "name": "model-name:tag",
      "tag": "latest",
      "purpose": "What this model does"
    }
  ],
  "recommended_for": ["Your use case"],
  "size_estimate": "~XGB total"
}
```

Install: `./scripts/install-profile.sh custom`

---

## Finding More Models

Browse all models: https://ollama.com/library

**Popular additions:**
- `codellama:13b` - Code (alternative to qwen)
- `mistral:7b` - General chat
- `mixtral:8x7b` - High quality (needs 32GB+ RAM)
- `gemma2:9b` - Good balance

**Add to custom profile:**
```json
{
  "name": "mixtral:8x7b",
  "tag": "latest",
  "purpose": "High-quality reasoning"
}
```

---

## Performance Tips

**Speed up responses:**
1. Use smaller models (3B-7B)
2. Close other apps to free RAM
3. Use SSD for data directory
4. Restart Ollama container periodically

**Improve quality:**
1. Use larger models (14B+)
2. Ensure enough RAM available
3. Use quality profile for important work
4. Combine with fast profile for drafts

**Balance disk space:**
1. Remove unused models: `docker exec local-ai-ollama ollama rm model-name`
2. Start with one profile
3. Add others as needed
4. List models: `docker exec local-ai-ollama ollama list`

---

## Next Steps

- [Create custom profiles](profiles.md)
- [Troubleshooting](troubleshooting.md)
- [Setup guide](setup-guide.md)
```

**Step 2: Verify file exists**

Run: `cat docs/model-selection.md | head -30`
Expected: First 30 lines displayed

**Step 3: Commit**

```bash
git add docs/model-selection.md
git commit -m "docs: add model selection guide with profiles comparison"
```

---

## Task 12: Create troubleshooting.md

**Files:**
- Create: `docs/troubleshooting.md`

**Step 1: Write troubleshooting.md**

Create `docs/troubleshooting.md`:

```markdown
# Troubleshooting Guide

**Common issues and solutions for Local AI setup**

---

## Container Issues

### Containers Won't Start

**Symptom:** `docker compose up -d` fails

**Check logs:**
```bash
docker logs local-ai-ollama
docker logs local-ai-webui
```

**Common causes:**

**1. Port already in use**
```bash
# Check what's using port 3000 or 11434
lsof -i :3000
lsof -i :11434

# Solution: Change ports in .env
WEBUI_PORT=3001
OLLAMA_PORT=11435
```

**2. Docker not running**
```bash
# Check Docker status
docker info

# Solution: Start Docker Desktop
```

**3. Permission issues**
```bash
# macOS/Linux: Fix data directory permissions
sudo chown -R $(whoami) data/

# Or remove and recreate
rm -rf data/
docker compose up -d
```

---

### Container Keeps Restarting

**Check status:**
```bash
docker ps -a
```

**If status shows "Restarting":**

**Check memory:**
```bash
docker stats
```

**Solution:** Add memory limits to `.env`:
```bash
OLLAMA_MEM_LIMIT=8g
WEBUI_MEM_LIMIT=2g
```

Then update `docker-compose.yml` to use limits:
```yaml
services:
  ollama:
    mem_limit: ${OLLAMA_MEM_LIMIT:-}
```

**Restart:**
```bash
docker compose down
docker compose up -d
```

---

## Model Download Issues

### Download is Very Slow

**This is normal for large models.**

**Expected times:**
- 3B model (~2GB): 2-5 minutes
- 7B model (~4-5GB): 5-10 minutes
- 14B model (~8-10GB): 10-20 minutes

**Speed depends on:**
- Internet connection
- Ollama registry load
- Docker download location

**Monitor progress:**
```bash
docker logs -f local-ai-ollama
```

---

### Download Fails or Times Out

**Symptom:** "Failed to pull model" error

**Try manual pull:**
```bash
docker exec -it local-ai-ollama ollama pull model-name:tag
```

**If still fails:**
1. Check internet connection
2. Check Docker has enough disk space: `df -h`
3. Restart Ollama: `docker restart local-ai-ollama`
4. Try smaller model first

**Check downloaded models:**
```bash
docker exec local-ai-ollama ollama list
```

---

### Model Takes Too Much Disk Space

**Check usage:**
```bash
du -sh data/ollama
```

**Remove unused models:**
```bash
# List models
docker exec local-ai-ollama ollama list

# Remove specific model
docker exec local-ai-ollama ollama rm model-name:tag

# Example
docker exec local-ai-ollama ollama rm llama3.2:3b
```

---

## Web UI Issues

### Can't Access http://localhost:3000

**Check container status:**
```bash
docker ps | grep webui
```

**If not running:**
```bash
docker logs local-ai-webui
docker compose up -d
```

**Try alternate URLs:**
- http://127.0.0.1:3000
- http://0.0.0.0:3000

**Check port binding:**
```bash
docker port local-ai-webui
```

Should show: `8080/tcp -> 0.0.0.0:3000`

---

### Models Not Appearing in Dropdown

**Check Ollama connection:**

From browser console (F12):
```javascript
fetch('http://localhost:11434/api/tags')
  .then(r => r.json())
  .then(console.log)
```

Should show list of models.

**If empty:**
1. Install a profile: `./scripts/install-profile.sh fast`
2. Verify: `docker exec local-ai-ollama ollama list`
3. Refresh Web UI

**Check WebUI logs:**
```bash
docker logs local-ai-webui | grep -i error
```

---

### Response is Very Slow

**Expected response times:**
- Fast profile (3B): 1-3 seconds
- Balanced profile (7-8B): 3-7 seconds
- Quality profile (14-16B): 7-15+ seconds

**If slower than expected:**

**1. Check CPU usage:**
```bash
docker stats local-ai-ollama
```

Should show high CPU during generation.

**2. Check RAM:**
```bash
docker stats
```

If near limit, switch to smaller models.

**3. Free up resources:**
- Close other applications
- Restart container: `docker restart local-ai-ollama`
- Use fast profile

**4. First response is slower:**
Model loads into memory on first use. Subsequent responses faster.

---

## Performance Issues

### System Becomes Unresponsive

**Symptom:** Computer slows down during model usage

**Causes:**
- Model too large for available RAM
- No memory limits set

**Solutions:**

**1. Add memory limits in docker-compose.yml:**
```yaml
services:
  ollama:
    mem_limit: 8g
  open-webui:
    mem_limit: 2g
```

**2. Use smaller models:**
Switch from quality → balanced → fast

**3. Close other apps:**
Free up RAM before using AI

**4. Check system resources:**
```bash
# macOS
top

# Linux
htop

# Check Docker
docker stats
```

---

### Models Keep Unloading

**Symptom:** First response always slow

**Cause:** Models unload after idle timeout

**This is normal behavior** to free RAM.

**To keep models loaded:**
Send periodic requests, or increase Ollama keep-alive:

```bash
docker exec local-ai-ollama sh -c 'echo "OLLAMA_KEEP_ALIVE=24h" >> /etc/environment'
docker restart local-ai-ollama
```

---

## Installation Script Issues

### install-profile.sh: Permission Denied

**Fix permissions:**
```bash
chmod +x scripts/install-profile.sh
```

---

### install-profile.sh: Profile Not Found

**Check profile exists:**
```bash
ls profiles/
```

**Use exact profile name:**
```bash
# Correct
./scripts/install-profile.sh balanced

# Wrong (no .json)
./scripts/install-profile.sh balanced.json
```

---

### install-profile.sh: Python Error

**Symptom:** JSON parsing fails

**Install Python 3:**
```bash
# macOS
brew install python3

# Ubuntu/Debian
sudo apt-get install python3

# Check version
python3 --version
```

---

## Data Loss Prevention

### Backup Conversations

**Before updates or changes:**
```bash
# Backup Open WebUI data
tar -czf backup-webui-$(date +%Y%m%d).tar.gz data/open-webui/

# Verify backup
tar -tzf backup-webui-*.tar.gz | head
```

**Restore:**
```bash
docker compose down
rm -rf data/open-webui
tar -xzf backup-webui-YYYYMMDD.tar.gz
docker compose up -d
```

---

### Don't Lose Models

**Models are large - don't lose them:**

**Backup model list (lightweight):**
```bash
docker exec local-ai-ollama ollama list > installed-models.txt
```

**Reinstall from list:**
```bash
while read model _; do
  docker exec local-ai-ollama ollama pull "$model"
done < installed-models.txt
```

**Models auto-downloaded on pull, so just save the list.**

---

## Getting Help

**Before asking for help, collect this info:**

```bash
# System info
uname -a
docker --version
docker compose version

# Container status
docker ps -a

# Logs
docker logs local-ai-ollama > ollama.log
docker logs local-ai-webui > webui.log

# Disk space
df -h

# Memory
free -h  # Linux
vm_stat  # macOS
```

**Where to get help:**
- Check this guide first
- Review [setup guide](setup-guide.md)
- Check [model selection guide](model-selection.md)
- Ask team members
- Open GitHub issue with logs

---

## Reset Everything

**Nuclear option - fresh start:**

```bash
# Stop and remove containers
docker compose down

# Remove all data (WARNING: deletes models and conversations)
rm -rf data/

# Remove containers and images
docker rm -f local-ai-ollama local-ai-webui
docker rmi ollama/ollama:latest ghcr.io/open-webui/open-webui:main

# Start fresh
docker compose up -d
./scripts/install-profile.sh balanced
```

**This deletes everything. Backup first if needed.**
```

**Step 2: Verify file exists**

Run: `cat docs/troubleshooting.md | head -30`
Expected: First 30 lines displayed

**Step 3: Commit**

```bash
git add docs/troubleshooting.md
git commit -m "docs: add comprehensive troubleshooting guide"
```

---

## Task 13: Create profiles.md for custom profiles

**Files:**
- Create: `docs/profiles.md`

**Step 1: Write profiles.md**

Create `docs/profiles.md`:

```markdown
# Creating Custom Profiles

**Guide to creating and sharing custom model profiles**

---

## Profile Format

Profiles are JSON files in `profiles/` directory.

**Basic structure:**
```json
{
  "name": "profile-name",
  "description": "What this profile is for",
  "models": [
    {
      "name": "model-name:tag",
      "tag": "latest",
      "purpose": "What this model does"
    }
  ],
  "recommended_for": [
    "Use case 1",
    "Use case 2"
  ],
  "size_estimate": "~XGB total",
  "notes": "Optional additional info"
}
```

---

## Creating a Custom Profile

### Example: Data Science Profile

**Requirement:** Models good at Python, data analysis, and math

**Create `profiles/data-science.json`:**
```json
{
  "name": "data-science",
  "description": "Models optimized for data analysis and scientific computing",
  "models": [
    {
      "name": "codellama:13b",
      "tag": "latest",
      "purpose": "Python code generation with data libraries"
    },
    {
      "name": "llama3.1:8b",
      "tag": "latest",
      "purpose": "Explaining statistical concepts"
    }
  ],
  "recommended_for": [
    "Data analysis",
    "Scientific computing",
    "Statistical modeling",
    "Python development"
  ],
  "size_estimate": "~12GB total",
  "notes": "Works well with pandas, numpy, scipy"
}
```

**Install:**
```bash
./scripts/install-profile.sh data-science
```

---

### Example: Frontend Development Profile

**Create `profiles/frontend.json`:**
```json
{
  "name": "frontend",
  "description": "Models for JavaScript, React, and web development",
  "models": [
    {
      "name": "qwen2.5-coder:7b",
      "tag": "latest",
      "purpose": "JavaScript/TypeScript code"
    },
    {
      "name": "phi3:mini",
      "tag": "latest",
      "purpose": "Quick CSS/HTML help"
    }
  ],
  "recommended_for": [
    "React development",
    "JavaScript coding",
    "Frontend debugging",
    "UI/UX implementation"
  ],
  "size_estimate": "~6GB total"
}
```

---

### Example: Security Review Profile

**Create `profiles/security.json`:**
```json
{
  "name": "security",
  "description": "Models for security review and vulnerability analysis",
  "models": [
    {
      "name": "deepseek-coder-v2:16b",
      "tag": "latest",
      "purpose": "Deep code analysis for vulnerabilities"
    },
    {
      "name": "qwen2.5:14b",
      "tag": "latest",
      "purpose": "Security pattern recognition"
    }
  ],
  "recommended_for": [
    "Security audits",
    "Vulnerability scanning",
    "Code review for security",
    "Threat modeling"
  ],
  "size_estimate": "~18GB total",
  "notes": "Use with caution - always verify findings manually"
}
```

---

## Finding Models

**Browse Ollama library:** https://ollama.com/library

**Popular models:**

**Code:**
- `codellama:7b`, `codellama:13b` - Code generation
- `qwen2.5-coder:7b` - Multilingual coding
- `deepseek-coder-v2:16b` - Advanced code tasks
- `starcoder2:15b` - Code completion

**Chat:**
- `llama3.1:8b` - General reasoning
- `mistral:7b` - Good balance
- `gemma2:9b` - Google's model
- `phi3:mini` - Microsoft's small model

**Specialized:**
- `mixtral:8x7b` - High quality (needs 32GB+ RAM)
- `solar:10.7b` - Efficient reasoning
- `neural-chat:7b` - Conversational

**Testing models:**
```bash
docker exec -it local-ai-ollama ollama run model-name:tag
```

---

## Profile Best Practices

### 1. Start Small

Begin with one model, test it, then add more:
```json
{
  "models": [
    {
      "name": "llama3.2:3b",
      "tag": "latest",
      "purpose": "Testing profile setup"
    }
  ]
}
```

---

### 2. Document Purpose

Be specific about what each model does:

**Bad:**
```json
{
  "purpose": "General use"
}
```

**Good:**
```json
{
  "purpose": "React component generation with TypeScript"
}
```

---

### 3. Estimate Size

Help users plan disk space:
```json
{
  "size_estimate": "~12GB total",
  "notes": "7GB for model A + 5GB for model B"
}
```

---

### 4. Target Specific Use Cases

Don't try to cover everything:

**Bad:** "Profile for all development"

**Good:**
- "Backend API development with Python/Go"
- "Mobile app development with React Native"
- "Data engineering with SQL and Python"

---

### 5. Consider RAM Limits

**For 16GB machines:**
- Max 2x 8B models
- Or 1x 14-16B model
- Or 3-4x 3B models

**Profile should indicate:**
```json
{
  "notes": "Designed for 16GB RAM. May need memory limits."
}
```

---

## Validating Profiles

**Before committing, validate:**

**1. Check JSON syntax:**
```bash
python3 -m json.tool profiles/your-profile.json
```

**2. Test installation:**
```bash
./scripts/install-profile.sh your-profile
```

**3. Verify models load:**
```bash
docker exec local-ai-ollama ollama list
```

**4. Test in Web UI:**
- Select model from dropdown
- Send test message
- Verify response quality

---

## Sharing Profiles

### For Your Team

**1. Add to git:**
```bash
git add profiles/team-profile.json
git commit -m "feat: add team-specific profile for [use case]"
git push
```

**2. Document in team wiki/README:**
```markdown
### Team Profiles

**Backend Development:** `./scripts/install-profile.sh backend`
**Frontend Development:** `./scripts/install-profile.sh frontend`
**Data Science:** `./scripts/install-profile.sh data-science`
```

---

### For Community

**1. Test thoroughly:**
- Works on 16GB RAM
- Models actually good for stated purpose
- Size estimate accurate
- Clear documentation

**2. Create PR with:**
- Profile JSON file
- Update to README listing profile
- Example use case
- Size requirements

**3. Profile naming:**
- Lowercase, hyphen-separated
- Descriptive: `python-data-science` not `profile3`
- Specific: `react-frontend` not `web-dev`

---

## Profile Templates

### Minimal Profile
```json
{
  "name": "minimal",
  "description": "Smallest useful setup",
  "models": [
    {
      "name": "phi3:mini",
      "tag": "latest",
      "purpose": "Everything"
    }
  ],
  "recommended_for": ["Testing", "Low RAM"],
  "size_estimate": "~2GB"
}
```

---

### Multi-Language Development
```json
{
  "name": "polyglot",
  "description": "Multiple programming languages",
  "models": [
    {
      "name": "qwen2.5-coder:7b",
      "tag": "latest",
      "purpose": "Python, JS, Go, Rust"
    },
    {
      "name": "codellama:7b",
      "tag": "latest",
      "purpose": "Alternative for code completion"
    }
  ],
  "recommended_for": [
    "Full-stack development",
    "Polyglot projects",
    "Comparing model outputs"
  ],
  "size_estimate": "~9GB total"
}
```

---

### Specialized Domain
```json
{
  "name": "ml-engineering",
  "description": "Machine learning and model development",
  "models": [
    {
      "name": "deepseek-coder-v2:16b",
      "tag": "latest",
      "purpose": "PyTorch and TensorFlow code"
    }
  ],
  "recommended_for": [
    "ML model development",
    "Training pipeline code",
    "Model architecture design"
  ],
  "size_estimate": "~10GB",
  "notes": "Better with 32GB RAM"
}
```

---

## Troubleshooting Custom Profiles

**Profile not found:**
- Check filename matches `profiles/<name>.json`
- Use profile name, not filename: `install-profile.sh myprofile` not `myprofile.json`

**JSON parse error:**
- Validate: `python3 -m json.tool profiles/profile.json`
- Check for trailing commas, missing quotes
- Use a JSON linter

**Model not found:**
- Check model exists: https://ollama.com/library
- Use correct format: `model-name:tag`
- Try: `docker exec local-ai-ollama ollama pull model-name:tag`

**Profile installs but models poor quality:**
- Test models individually in Web UI
- Check model is appropriate for task
- Try alternatives from Ollama library
- Size doesn't always mean quality

---

## Next Steps

- [Model selection guide](model-selection.md)
- [Troubleshooting](troubleshooting.md)
- [Setup guide](setup-guide.md)
```

**Step 2: Verify file exists**

Run: `cat docs/profiles.md | head -30`
Expected: First 30 lines displayed

**Step 3: Commit**

```bash
git add docs/profiles.md
git commit -m "docs: add guide for creating custom profiles"
```

---

## Task 14: Test Complete Setup

**Files:**
- Test all components work together

**Step 1: Start fresh test**

Run:
```bash
# Clean start
docker compose down
rm -rf data/

# Start containers
docker compose up -d
```

**Expected:** Both containers start successfully

**Step 2: Verify containers running**

Run: `docker ps`

**Expected:** See `local-ai-ollama` and `local-ai-webui` running

**Step 3: Test install script with fast profile**

Run: `./scripts/install-profile.sh fast`

**Expected:**
- Script runs without errors
- Downloads llama3.2:3b and phi3:mini
- Shows success message

**Step 4: Verify models installed**

Run: `docker exec local-ai-ollama ollama list`

**Expected:** Lists installed models

**Step 5: Test Web UI access**

Run: `curl -I http://localhost:3000`

**Expected:** HTTP 200 response

**Step 6: Verify all documentation exists**

Run:
```bash
ls -la README.md
ls -la docs/setup-guide.md
ls -la docs/model-selection.md
ls -la docs/troubleshooting.md
ls -la docs/profiles.md
```

**Expected:** All files exist

**Step 7: Commit test verification**

```bash
git add -A
git commit -m "test: verify complete setup works end-to-end"
```

---

## Task 15: Final Polish and README Update

**Files:**
- Modify: `README.md`

**Step 1: Add badges and additional info to README**

Edit `README.md`, add after first line:

```markdown
# Local AI Setup

[![Docker](https://img.shields.io/badge/Docker-Required-blue)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**What it is:** Docker-based Ollama + Open WebUI stack for private, offline AI
```

**Step 2: Add FAQ section to README**

Add before "## License":

```markdown
## FAQ

**Q: Do I need GPU?**
A: No. Works on CPU. GPU helps but not required.

**Q: Does this send data to cloud?**
A: No. Everything runs locally. Completely offline after model download.

**Q: Can I use this commercially?**
A: Yes. MIT license. Use freely.

**Q: How much disk space?**
A: 20-50GB depending on models. Fast profile ~4GB, Quality ~18GB.

**Q: What if I have 8GB RAM?**
A: Try fast profile. May be slow. 16GB recommended minimum.

**Q: Can I add more models later?**
A: Yes. Run install-profile script again or pull models manually.

**Q: How do I update?**
A: `docker compose pull && docker compose up -d`
```

**Step 3: Verify README is scannable**

Run: `cat README.md | head -50`

**Expected:** Key info visible in first screen

**Step 4: Commit final polish**

```bash
git add README.md
git commit -m "docs: add badges and FAQ to README"
```

---

## Task 16: Create Quick Reference Card

**Files:**
- Create: `docs/quick-reference.md`

**Step 1: Write quick reference**

Create `docs/quick-reference.md`:

```markdown
# Quick Reference

**One-page command reference for common tasks**

---

## Setup

```bash
# Initial setup
cp .env.example .env
docker compose up -d
./scripts/install-profile.sh balanced
open http://localhost:3000
```

---

## Container Management

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Restart
docker compose restart

# Update
docker compose pull
docker compose up -d

# View logs
docker logs local-ai-ollama
docker logs local-ai-webui

# Follow logs
docker logs -f local-ai-ollama
```

---

## Models

```bash
# List installed
docker exec local-ai-ollama ollama list

# Install profile
./scripts/install-profile.sh fast
./scripts/install-profile.sh balanced
./scripts/install-profile.sh quality

# Pull specific model
docker exec local-ai-ollama ollama pull model-name:tag

# Remove model
docker exec local-ai-ollama ollama rm model-name:tag

# Test model
docker exec -it local-ai-ollama ollama run model-name:tag
```

---

## Profiles

**fast** - Quick (3B models, ~4GB)
**balanced** - Recommended (7-8B, ~9GB)
**quality** - Best results (14-16B, ~18GB)
**all-rounders** - Simplest (14B, ~9GB)

---

## Backup

```bash
# Backup conversations
tar -czf backup-$(date +%Y%m%d).tar.gz data/open-webui/

# Backup model list
docker exec local-ai-ollama ollama list > models.txt

# Restore conversations
tar -xzf backup-YYYYMMDD.tar.gz
```

---

## Troubleshooting

```bash
# Check containers
docker ps

# Check ports
docker port local-ai-ollama
docker port local-ai-webui

# Check resources
docker stats

# Restart everything
docker compose down
docker compose up -d

# Nuclear reset (deletes everything)
docker compose down
rm -rf data/
docker compose up -d
```

---

## Disk Space

```bash
# Check usage
du -sh data/

# Check Docker disk usage
docker system df

# Clean unused Docker resources
docker system prune
```

---

## Configuration

**Files:**
- `.env` - Port and resource config
- `docker-compose.yml` - Container setup
- `profiles/*.json` - Model profiles

**Ports:**
- Web UI: http://localhost:3000
- Ollama API: http://localhost:11434

---

## URLs

- **Web UI:** http://localhost:3000
- **API:** http://localhost:11434/api
- **Models:** https://ollama.com/library
- **Docs:** `docs/` directory

---

## Getting Help

1. Check [troubleshooting guide](troubleshooting.md)
2. Review [setup guide](setup-guide.md)
3. Check container logs
4. Ask team
5. Open GitHub issue
```

**Step 2: Commit quick reference**

```bash
git add docs/quick-reference.md
git commit -m "docs: add quick reference card for common commands"
```

---

## Task 17: Add LICENSE File

**Files:**
- Create: `LICENSE`

**Step 1: Create MIT LICENSE**

Create `LICENSE`:

```
MIT License

Copyright (c) 2025 [Your Company Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

**Step 2: Commit LICENSE**

```bash
git add LICENSE
git commit -m "chore: add MIT license"
```

---

## Task 18: Create Final Verification Script

**Files:**
- Create: `scripts/verify-setup.sh`

**Step 1: Write verification script**

Create `scripts/verify-setup.sh`:

```bash
#!/usr/bin/env bash

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Local AI Setup Verification${NC}"
echo ""

# Check Docker
echo -n "Checking Docker... "
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC} Docker not found"
    exit 1
fi

# Check Docker Compose
echo -n "Checking Docker Compose... "
if docker compose version &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC} Docker Compose not found"
    exit 1
fi

# Check containers
echo -n "Checking Ollama container... "
if docker ps | grep -q "local-ai-ollama"; then
    echo -e "${GREEN}✓ Running${NC}"
else
    echo -e "${YELLOW}⚠ Not running${NC}"
fi

echo -n "Checking WebUI container... "
if docker ps | grep -q "local-ai-webui"; then
    echo -e "${GREEN}✓ Running${NC}"
else
    echo -e "${YELLOW}⚠ Not running${NC}"
fi

# Check ports
echo -n "Checking Web UI port (3000)... "
if curl -s http://localhost:3000 > /dev/null; then
    echo -e "${GREEN}✓ Accessible${NC}"
else
    echo -e "${YELLOW}⚠ Not accessible${NC}"
fi

echo -n "Checking Ollama API port (11434)... "
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo -e "${GREEN}✓ Accessible${NC}"
else
    echo -e "${YELLOW}⚠ Not accessible${NC}"
fi

# Check models
echo -n "Checking installed models... "
model_count=$(docker exec local-ai-ollama ollama list 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
if [ "$model_count" -gt 0 ]; then
    echo -e "${GREEN}✓ $model_count models installed${NC}"
    docker exec local-ai-ollama ollama list 2>/dev/null | tail -n +2 | while read -r line; do
        echo "  • $line"
    done
else
    echo -e "${YELLOW}⚠ No models installed${NC}"
    echo "  Run: ./scripts/install-profile.sh balanced"
fi

# Check disk space
echo -n "Checking disk space... "
if [ -d "data" ]; then
    size=$(du -sh data 2>/dev/null | cut -f1)
    echo -e "${GREEN}✓${NC} Using $size"
else
    echo -e "${YELLOW}⚠ No data directory${NC}"
fi

echo ""
echo -e "${GREEN}Verification complete!${NC}"
echo ""
echo "Next steps:"
echo "  • Not running? Start with: docker compose up -d"
echo "  • No models? Install with: ./scripts/install-profile.sh balanced"
echo "  • Access Web UI: http://localhost:3000"
```

**Step 2: Make executable**

Run: `chmod +x scripts/verify-setup.sh`

**Step 3: Test verification script**

Run: `./scripts/verify-setup.sh`

**Expected:** Shows status of all components

**Step 4: Commit verification script**

```bash
git add scripts/verify-setup.sh
git commit -m "feat: add setup verification script"
```

---

## Task 19: Final Documentation Review

**Files:**
- Review all documentation for consistency

**Step 1: Check all docs render correctly**

Run:
```bash
for doc in README.md docs/*.md; do
    echo "=== $doc ==="
    head -5 "$doc"
    echo ""
done
```

**Expected:** All docs have proper headers

**Step 2: Verify all links work**

Check these files reference correct paths:
- README.md links to docs/
- All docs/ files cross-reference correctly

**Step 3: Check for consistent terminology**

Run: `grep -r "Open WebUI" --include="*.md" .`

**Expected:** Consistent naming (not "OpenWebUI", "open-webui", etc.)

**Step 4: Update README if needed**

If any inconsistencies found, fix them.

**Step 5: Final commit**

```bash
git add -A
git commit -m "docs: final review and consistency fixes"
```

---

## Task 20: Tag Release

**Files:**
- Create git tag

**Step 1: Review all commits**

Run: `git log --oneline`

**Expected:** Clean commit history

**Step 2: Create annotated tag**

Run:
```bash
git tag -a v1.0.0 -m "Release v1.0.0 - Initial local AI setup

Features:
- Docker Compose stack with Ollama + Open WebUI
- Four model profiles (fast, balanced, quality, all-rounders)
- Profile installer script
- Comprehensive documentation
- Verification script"
```

**Step 3: View tag**

Run: `git show v1.0.0`

**Expected:** Tag created with message

**Step 4: List all files in repo**

Run: `git ls-tree -r --name-only HEAD`

**Expected:** All project files listed

---

## Completion Checklist

- ✅ `.gitignore` created
- ✅ `docker-compose.yml` created and tested
- ✅ `.env.example` created
- ✅ Four profiles created (fast, balanced, quality, all-rounders)
- ✅ `install-profile.sh` script created and tested
- ✅ `README.md` with smart-brevity principles
- ✅ `docs/setup-guide.md` detailed walkthrough
- ✅ `docs/model-selection.md` profile comparison
- ✅ `docs/troubleshooting.md` comprehensive guide
- ✅ `docs/profiles.md` custom profile creation
- ✅ `docs/quick-reference.md` command cheat sheet
- ✅ `LICENSE` file added
- ✅ `scripts/verify-setup.sh` created
- ✅ All documentation reviewed for consistency
- ✅ End-to-end test completed
- ✅ Release tagged

---

## Post-Implementation

**Share with team:**
1. Push to company GitHub/GitLab
2. Send quick start link
3. Schedule demo/walkthrough
4. Collect feedback for Phase 2

**Monitor usage:**
- Which profiles are popular?
- What issues come up?
- What features are requested?

**Phase 2 planning:**
- Additional profiles based on feedback
- Backup/restore scripts
- Update management scripts
- Performance tuning documentation
