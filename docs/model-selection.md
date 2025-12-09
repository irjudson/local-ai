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
- Default choice for most users

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
