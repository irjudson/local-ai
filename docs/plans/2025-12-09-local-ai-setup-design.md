# Local AI Setup Design

**What it is:** Docker-based Ollama + Open WebUI stack with model profiles

**Why it matters:** Gives your company private, offline AI for code/chat/experiments without cloud dependencies

**Bottom line:** Running in 5 minutes, easy to share and customize

## Requirements Summary

**Target users:** Developers (mostly) with standard 16GB RAM laptops, no dedicated GPUs

**Use cases:** Code assistance, general chat, experimentation, future video generation (advanced topic)

**Performance strategy:** Tier-based approach with fast models for daily work, quality models when it matters

**Deployment approach:** Simple initial setup with clear documentation

## Architecture

### Core Stack
- **Ollama**: Model runtime, API on port 11434
- **Open WebUI**: Chat interface, browser UI on port 3000
- **Docker network**: Bridge network connecting services
- **Data persistence**: All data in `./data` directory (git-ignored)

### Project Structure
```
local-ai/
├── docker-compose.yml          # Container orchestration
├── .env.example                # Configuration template
├── .env                         # User config (git-ignored)
├── .gitignore                   # Exclude data/models
├── README.md                    # Quick start
├── docs/
│   ├── plans/                  # Design documents
│   ├── setup-guide.md          # Detailed setup
│   ├── model-selection.md      # Profile explanations
│   ├── troubleshooting.md      # Common issues
│   └── profiles.md             # Custom profile creation
├── profiles/
│   ├── fast.json               # Quick models (3B-7B)
│   ├── balanced.json           # Best trade-off (7B-8B)
│   ├── quality.json            # Better results (14B-16B)
│   └── all-rounders.json       # One model for everything
├── scripts/
│   └── install-profile.sh      # Helper script to install profiles
└── data/                        # Git-ignored
    ├── ollama/                 # Downloaded models
    └── open-webui/             # Conversations, settings
```

## Docker Configuration

### docker-compose.yml Structure
- **Ollama service**:
  - Image: `ollama/ollama:latest`
  - Port: 11434
  - Volume: `./data/ollama:/root/.ollama`
  - Restart: `unless-stopped`

- **Open WebUI service**:
  - Image: `ghcr.io/open-webui/open-webui:main`
  - Port: 3000
  - Volume: `./data/open-webui:/app/backend/data`
  - Environment: `OLLAMA_BASE_URL=http://ollama:11434`
  - Restart: `unless-stopped`

### .env Configuration
- Port mappings (customizable)
- Container versions
- Optional memory limits for 16GB machines (commented by default)

### Why Bind Mounts
Users can see, backup, and version control their data. No hidden Docker volumes.

## Model Profiles

### Initial Profiles

**fast.json** - Quick daily tasks:
- `llama3.2:3b` - Fast chat
- `phi3:mini` - Fast code assistance
- CPU-friendly, sub-second responses

**balanced.json** - Best trade-off:
- `qwen2.5-coder:7b` - Code generation
- `llama3.1:8b` - General chat
- Recommended default

**quality.json** - Important work:
- `qwen2.5:14b` - Better reasoning
- `deepseek-coder-v2:16b` - Complex code
- Slower but higher quality

**all-rounders.json** - Single model:
- `qwen2.5-coder:14b` - Code and chat
- Simplest option

### Profile Format
```json
{
  "name": "balanced",
  "description": "Best performance/quality trade-off",
  "models": [
    {"name": "qwen2.5-coder:7b", "tag": "latest"},
    {"name": "llama3.1:8b", "tag": "latest"}
  ]
}
```

## Helper Scripts

### install-profile.sh
**Purpose:** Install model sets with one command

**Usage:** `./scripts/install-profile.sh balanced`

**Actions:**
1. Read profile JSON file
2. Pull each model via `docker exec ollama ollama pull <model>`
3. Show progress for each model
4. Verify models loaded
5. List installed models

**Example:**
```bash
./scripts/install-profile.sh fast
# Installs llama3.2:3b and phi3:mini
```

**Future enhancements:**
- Update script to manage container updates
- Backup/restore scripts for data directory
- Health check script for containers

## Documentation Structure

### README.md (Quick Start)
- **Axiom**: What/Why/Bottom line
- Quick start commands (5 lines)
- Profile selection
- Links to detailed docs
- **Goal**: User understands in 30 seconds

### docs/setup-guide.md
- Prerequisites checklist
- Step-by-step with verification
- First model pull walkthrough
- Screenshots where helpful

### docs/model-selection.md
- Profile explanations
- Use case recommendations
- Size vs performance trade-offs
- Creating custom profiles

### docs/troubleshooting.md
- Port conflicts
- Memory issues
- Slow model downloads
- Docker Desktop problems
- Model loading failures

### docs/profiles.md
- Profile JSON format
- Creating team profiles
- Sharing profiles via git
- Advanced: Multi-model workflows

## Git & Sharing Strategy

### Version Controlled
✅ docker-compose.yml, .env.example
✅ All documentation
✅ Profile JSON files
✅ Helper scripts
✅ .gitignore

### Git-Ignored
❌ `data/` directory (models are huge, conversations private)
❌ `.env` (user customizations)

### Company-Wide Sharing
1. Clone repo
2. Copy `.env.example` to `.env`
3. Run `docker compose up -d`
4. Install profile: `./scripts/install-profile.sh balanced`
5. Open http://localhost:3000

### Custom Profiles
Teams can commit custom profiles to repo for company-specific use cases.

## Implementation Phases

### Phase 1 (Initial)
- Docker stack setup (docker-compose.yml, .env.example)
- Basic profiles (fast, balanced, quality, all-rounders)
- Profile installer script
- Core documentation (README, setup guide, model selection)
- .gitignore configuration

### Phase 2 (Enhancement)
- Update/backup helper scripts
- Additional profiles based on team feedback
- Performance tuning documentation
- Troubleshooting guide expansion

### Phase 3 (Advanced)
- Video generation profiles (for users with GPUs)
- Model benchmarking documentation
- Integration guides (IDE extensions, API usage)
- Multi-machine setup guides

## Technical Considerations

### 16GB RAM Constraints
- Fast profile: Safe for all users
- Balanced profile: Works well
- Quality profile: May need memory limits or swap
- Document optional `mem_limit` in docker-compose

### Model Download Sizes
- 3B models: ~2GB
- 7-8B models: ~4-5GB
- 14-16B models: ~8-10GB
- Users need 20-50GB free disk space

### Performance Expectations
- **Fast profile**: 1-3 seconds per response
- **Balanced profile**: 3-7 seconds per response
- **Quality profile**: 7-15+ seconds per response

### Video Generation (Future)
Document as advanced topic requiring:
- 32GB+ RAM
- Dedicated GPU (RTX 3090/4090 or M2/M3 Max)
- Separate profile: `profiles/video.json`

## Success Criteria

**Setup success:**
- New user running AI chat in under 10 minutes
- Documentation scannable in 30 seconds
- Minimal manual commands (copy .env, run docker compose, install profile)

**Extensibility success:**
- Teams creating custom profiles
- Helper scripts easy to understand and modify
- Setup portable across machines

**User experience success:**
- Fast models feel instant
- Quality models worth the wait
- Clear profile recommendations

## Open Questions (Resolved)
- ✅ Video generation: Phase 3 advanced topic
- ✅ Profile system: Include from day one
- ✅ Documentation format: Multi-format with smart-brevity
- ✅ Automation scope: Progressive (setup → profiles → management)

## Next Steps
1. Initialize git repository
2. Create docker-compose.yml and .env.example
3. Write initial profiles (fast, balanced, quality, all-rounders)
4. Create install-profile.sh helper script
5. Write .gitignore
6. Write documentation (README, setup guide, model selection)
7. Test on clean 16GB machine
8. Share with team for feedback
