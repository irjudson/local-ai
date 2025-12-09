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
