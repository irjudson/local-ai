# Local AI Setup

[![Docker](https://img.shields.io/badge/Docker-Required-blue)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

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

## License

MIT - Use freely for company or personal projects
