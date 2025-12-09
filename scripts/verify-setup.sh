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
