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
