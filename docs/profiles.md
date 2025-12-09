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
