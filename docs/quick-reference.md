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
4. Ask colleagues
5. Open GitHub issue
