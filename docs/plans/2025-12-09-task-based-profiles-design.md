# Task-Based Model Profiles Design

**What it is:** 9 specialized model profiles optimized for specific tasks

**Why it matters:** Different tasks need different model strengths - code generation needs precision, brainstorming needs creativity, architecture needs reasoning

**Bottom line:** Install task-specific profiles to get optimal models for your work

## Overview

This design extends the existing general profiles (fast, balanced, quality, all-rounders) with task-specific profiles that optimize for particular workflows. Each profile contains both fast and quality model variants, allowing users to choose speed vs. depth based on their immediate needs.

## Design Principles

1. **Task-focused naming** - Users think "I'm doing X task" not "I need Y-sized model"
2. **Tiered variants** - Each profile includes fast (7-14B) and quality (32B+) models
3. **Single install** - One command installs both variants, user chooses in UI
4. **Auto-updates** - All models use `"tag": "latest"` for automatic updates
5. **Clear purpose** - Each model variant explains when to use it

## Hardware Context

**Target hardware:** M4 Pro laptop with sufficient unified memory to run 32B models comfortably

**Cloud availability:** Heavy models (70B+) can be run on cloud resources when needed

**Performance expectations:**
- 7-8B models: 2-5 seconds per response
- 14B models: 5-10 seconds per response
- 32B models: 10-20 seconds per response
- 70B models: 20-40 seconds per response

## Profile Specifications

### 1. Programming Profile

**File:** `profiles/programming.json`

**Purpose:** Code generation, debugging, refactoring across 92+ programming languages

**Models:**
- **Fast:** `qwen2.5-coder:7b` (~5GB)
  - Quick code generation and completion
  - Rapid debugging iterations
  - Code explanations

- **Quality:** `qwen2.5-coder:32b` (~18GB)
  - Production-ready code generation
  - Complex refactoring
  - Multi-file context understanding
  - GPT-4o competitive performance

**Use cases:**
- Daily coding tasks
- Code reviews
- Bug fixing
- API integration
- Algorithm implementation

**Total size:** ~23GB

---

### 2. Systems-Architecture Profile

**File:** `profiles/systems-architecture.json`

**Purpose:** Distributed systems design, scaling patterns, performance analysis, deadlock resolution

**Models:**
- **Fast:** `phi4-reasoning:14b` (~8GB)
  - Quick trade-off analysis
  - Architectural pattern suggestions
  - Performance bottleneck identification

- **Quality:** `deepseek-r1:32b` (~18GB)
  - Deep reasoning about distributed systems
  - CAP theorem and consistency analysis
  - Complex deadlock scenarios
  - Scaling strategy design

**Use cases:**
- System design interviews
- Architecture reviews
- Performance optimization
- Distributed consensus design
- Failure mode analysis
- Capacity planning

**Total size:** ~26GB

**Note:** This is fundamentally different from programming profile - focuses on strategic/architectural thinking rather than code generation.

---

### 3. Research Profile

**File:** `profiles/research.json`

**Purpose:** General research, paper analysis, information synthesis

**Models:**
- **Fast:** `llama3.3:8b` (~5GB)
  - Quick literature reviews
  - Rapid paper summaries
  - Concept explanations

- **Quality:** `llama3.3:70b` (~40GB)
  - Deep paper analysis
  - Cross-reference synthesis
  - 128K context for multiple documents
  - Complex research questions

**Use cases:**
- Academic research
- Literature reviews
- Technical investigation
- Concept learning
- Research paper writing

**Total size:** ~45GB

**Note:** Quality variant (70B) may require cloud resources or extended processing time.

---

### 4. Writing Profile

**File:** `profiles/writing.json`

**Purpose:** Technical documentation, creative writing, content editing

**Models:**
- **Fast:** `llama3.3:8b` (~5GB)
  - Quick drafts and outlines
  - Blog posts
  - Documentation updates

- **Quality:** `llama3.3:70b` (~40GB)
  - Long-form technical docs
  - Nuanced tone and style
  - Complex narrative structures
  - Deep editing and refinement

**Use cases:**
- Technical documentation
- Blog posts and articles
- Creative writing
- Content editing
- Style consistency

**Total size:** ~45GB

---

### 5. Data-Work Profile

**File:** `profiles/data-work.json`

**Purpose:** Data analysis, SQL queries, data transformations, insights extraction

**Models:**
- **Fast:** `qwen2.5-coder:7b` (~5GB)
  - Quick SQL queries
  - Data transformation scripts
  - Basic analysis

- **Quality:** `deepseek-r1:32b` (~18GB)
  - Complex analytical queries
  - Statistical reasoning
  - Data pipeline design
  - Pattern identification

**Use cases:**
- SQL query writing
- Data cleaning and transformation
- Exploratory data analysis
- Report generation
- Analytics workflows

**Total size:** ~23GB

---

### 6. Skills-Building Profile

**File:** `profiles/skills-building.json`

**Purpose:** Creating reliable Claude/ChatGPT skills, prompt engineering, testing workflows

**Models:**
- **Fast:** `qwen2.5:14b` (~8GB)
  - Quick prompt iterations
  - Skill drafting
  - Basic testing

- **Quality:** `deepseek-r1:32b` (~18GB)
  - Ensuring reliability
  - Edge case analysis
  - Workflow validation
  - Rigorous skill testing

**Use cases:**
- AI skill development
- Prompt engineering
- Workflow design
- Testing and validation
- Process documentation

**Total size:** ~26GB

**Note:** Quality tier ensures skills work as designed and handle edge cases reliably.

---

### 7. Brainstorming Profile

**File:** `profiles/brainstorming.json`

**Purpose:** Creative ideation, exploring alternatives, divergent thinking

**Models:**
- **Fast:** `dolphin-llama3:8b` (~5GB)
  - Uncensored creative exploration
  - Rapid idea generation
  - Open-ended brainstorming

- **Quality:** `llama3.3:70b` (~40GB)
  - Deep creative reasoning
  - Alternative exploration with analysis
  - Strategic ideation

**Use cases:**
- Product ideation
- Creative problem solving
- Design thinking
- Exploring alternatives
- Strategic planning

**Total size:** ~45GB

**Note:** Dolphin model is uncensored for unrestricted creative exploration.

---

### 8. Document-Intelligence Profile

**File:** `profiles/document-intelligence.json`

**Purpose:** Deep document analysis, long-context synthesis, cross-referencing

**Models:**
- **Fast:** `granite3.1:8b` (~5GB)
  - 128K context window
  - Quick document summaries
  - Efficient long-text processing

- **Quality:** `llama3.3:70b` (~40GB)
  - 128K context for multiple documents
  - Deep synthesis and insights
  - Cross-document reasoning

**Use cases:**
- Multi-document analysis
- Contract review
- Research synthesis
- Long-form content understanding
- Knowledge extraction

**Total size:** ~45GB

**Note:** Both models have 128K context windows for handling extensive documents.

---

### 9. Business-Research Profile

**File:** `profiles/business-research.json`

**Purpose:** Competitive analysis, market positioning, strategic synthesis

**Models:**
- **Fast:** `llama3.3:8b` (~5GB)
  - Quick market overviews
  - Competitive landscape summaries
  - Basic positioning analysis

- **Quality:** `llama3.3:70b` (~40GB)
  - Deep strategic analysis
  - Multi-factor synthesis
  - Long-context market trends
  - Complex positioning strategies

**Use cases:**
- Competitive analysis
- Market research
- Strategic planning
- Positioning and messaging
- Business case development
- Investment analysis

**Total size:** ~45GB

---

## Model Selection Rationale

### Programming Models
**Qwen2.5-Coder series** chosen for:
- Support for 92+ programming languages
- GPT-4o competitive performance (32B variant)
- Strong multi-file context understanding
- Production-ready code generation

### Reasoning Models
**DeepSeek-R1 and Phi-4-reasoning** chosen for:
- GPT-4 level reasoning capabilities
- Excellent for complex problem solving
- Trade-off analysis and strategic thinking
- Systems architecture and design

### Long-Context Models
**Llama 3.3 and Granite** chosen for:
- 128K context windows
- Document synthesis capabilities
- Balanced reasoning + creativity
- Strong instruction following

### Creative Models
**Dolphin-Llama3** chosen for:
- Uncensored for open exploration
- Strong creative capabilities
- Brainstorming without restrictions

## Storage Requirements

**Minimum profiles (fast variants only):** ~50GB
- Programming, systems-architecture, skills-building, data-work, brainstorming (fast variants)

**Full installation (all 9 profiles, both variants):** ~270GB
- Not recommended - install profiles as needed

**Recommended approach:**
- Start with 3-4 profiles you use most
- Install fast variants first
- Add quality variants for deep work
- ~80-100GB for typical usage

## Implementation Considerations

### Profile JSON Structure
```json
{
  "name": "profile-name",
  "description": "Brief description",
  "models": [
    {
      "name": "model-name:size",
      "tag": "latest",
      "purpose": "Fast iteration - description",
      "tier": "fast"
    },
    {
      "name": "model-name:size",
      "tag": "latest",
      "purpose": "Deep work - description",
      "tier": "quality"
    }
  ],
  "recommended_for": [
    "Use case 1",
    "Use case 2"
  ],
  "size_estimate": "~XX GB total"
}
```

### Installation Script Changes
Current `install-profile.sh` already supports multiple models per profile - no changes needed.

### Documentation Updates
1. **README.md** - Add new profiles to quick start section
2. **docs/model-selection.md** - Add task-based profile guide
3. **docs/profiles.md** - Add examples of task-based profiles

### Relationship to Existing Profiles

**Keep existing profiles:**
- `fast.json` - Quick general-purpose work
- `balanced.json` - Default for new users
- `quality.json` - General deep work
- `all-rounders.json` - Single-model simplicity

**New profiles complement existing:**
- General profiles = good starting point
- Task profiles = optimize for specific work
- Users can have both installed

## Usage Workflow

**Example 1: Programming work**
```bash
# Install programming profile
./scripts/install-profile.sh programming

# Use qwen2.5-coder:7b for quick iterations
# Switch to qwen2.5-coder:32b for complex refactoring
```

**Example 2: Research session**
```bash
# Install research profile
./scripts/install-profile.sh research

# Use llama3.3:8b for quick paper summaries
# Switch to llama3.3:70b for deep synthesis (may use cloud)
```

**Example 3: Multi-task day**
```bash
# Install multiple profiles
./scripts/install-profile.sh programming
./scripts/install-profile.sh brainstorming
./scripts/install-profile.sh business-research

# Switch models in UI based on current task
```

## Future Enhancements

### Video Production Profile (Phase 3)
**Deferred until:**
- Video generation models mature in Ollama ecosystem
- Better local video generation capabilities
- Integration patterns stabilize

**Planned structure:**
- Script development models (text-based)
- Visual concept models (vision-based)
- Production planning models
- Integration with external video tools

### Model Performance Tracking
- Add benchmarking documentation
- Performance comparison for hardware
- Real-world speed measurements

### Profile Recommendations
- CLI tool to suggest profiles based on task description
- Usage analytics to recommend profiles
- Auto-install most-used profiles

## Success Criteria

**User experience:**
- User installs task-specific profile in one command
- Clear guidance on fast vs. quality model selection
- Models perform well for intended tasks

**Technical:**
- All profiles use latest tags for auto-updates
- Models run efficiently on M4 Pro hardware
- Quality variants provide meaningful improvement over fast

**Documentation:**
- Clear task-to-profile mapping
- Usage examples for each profile
- Size and performance expectations documented

## Open Questions

None - design is complete and ready for implementation.

## Next Steps

1. Create 9 profile JSON files in `profiles/` directory
2. Update README.md with new profiles
3. Update docs/model-selection.md with task-based guidance
4. Add task-based examples to docs/profiles.md
5. Test profile installation
6. Verify model performance on sample tasks
7. Commit and tag as v1.1.0

## References

- [Top 10 Best Ollama Models for Developers in 2025](https://collabnix.com/best-ollama-models-for-developers-complete-2025-guide-with-code-examples/)
- [Best Ollama Models 2025: Complete Performance Guide](https://collabnix.com/best-ollama-models-in-2025-complete-performance-comparison/)
- [Best Ollama Models for Creative Writing & RP](https://www.arsturn.com/blog/a-guide-to-the-best-ollama-models-for-creative-writing-and-rp)
- [Ollama Models List 2025: 100+ Models Compared](https://skywork.ai/blog/llm/ollama-models-list-2025-100-models-compared/)
- [Phi-4 Reasoning Model](https://ollama.com/library/phi4-reasoning)
