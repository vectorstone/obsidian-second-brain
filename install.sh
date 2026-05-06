#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_AGENT="${TARGET_AGENT:-codex}"
CODEX_SKILLS_DIR="$HOME/.codex/skills"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_COMMANDS_DIR="$CLAUDE_DIR/commands"
CLAUDE_SKILLS_DIR="$CLAUDE_DIR/skills"
CONFIG_DIR="$HOME/.config/obsidian-second-brain"
ENV_FILE="$CONFIG_DIR/.env"

install_codex() {
  mkdir -p "$CODEX_SKILLS_DIR"
  local skill_link="$CODEX_SKILLS_DIR/obsidian-second-brain"
  if [[ -e "$skill_link" ]]; then
    echo "Codex skill already present at $skill_link"
  else
    ln -s "$SKILL_DIR" "$skill_link"
    echo "Codex skill linked at $skill_link"
  fi
}

install_claude() {
  mkdir -p "$CLAUDE_COMMANDS_DIR" "$CLAUDE_SKILLS_DIR"
  echo "Installing Claude slash commands..."
  for file in "$SKILL_DIR/commands/"*.md; do
    name=$(basename "$file")
    dest="$CLAUDE_COMMANDS_DIR/$name"
    if [[ -f "$dest" ]]; then
      echo "  skipping $name (already exists)"
    else
      cp "$file" "$dest"
      echo "  installed $name"
    fi
  done
  local skill_link="$CLAUDE_SKILLS_DIR/obsidian-second-brain"
  if [[ -e "$skill_link" ]]; then
    echo "Claude skill already present at $skill_link"
  else
    ln -s "$SKILL_DIR" "$skill_link"
    echo "Claude skill linked at $skill_link"
  fi
}

echo "Installing obsidian-second-brain for target: $TARGET_AGENT"
case "$TARGET_AGENT" in
  codex) install_codex ;;
  claude) install_claude ;;
  both) install_codex; install_claude ;;
  *) echo "Unknown TARGET_AGENT=$TARGET_AGENT (expected codex|claude|both)"; exit 1 ;;
esac

echo
echo "Research toolkit (optional): /x-read, /x-pulse, /research, /research-deep, /youtube"
echo "These commands need API keys for Grok (xAI) and Perplexity. YouTube key is optional."
echo
read -r -p "Set up research toolkit now? [y/N] " setup_research
setup_research=${setup_research:-N}

if [[ "$setup_research" =~ ^[Yy]$ ]]; then
  if ! command -v uv >/dev/null 2>&1; then
    echo "  ⚠️  'uv' not found. Install with: brew install uv"
    echo "     Then re-run this installer to finish research toolkit setup."
  else
    echo "  Installing Python deps via uv..."
    (cd "$SKILL_DIR" && uv sync --quiet)
    echo "  Python deps ready."
  fi

  mkdir -p "$CONFIG_DIR"
  if [[ -f "$ENV_FILE" ]]; then
    echo "  $ENV_FILE already exists — leaving it untouched."
  else
    cp "$SKILL_DIR/.env.example" "$ENV_FILE"
    chmod 600 "$ENV_FILE"
    echo "  Created $ENV_FILE (permissions 600)."
  fi

  echo
  echo "  Now paste your API keys into: $ENV_FILE"
  echo "    XAI_API_KEY=          (https://console.x.ai)"
  echo "    PERPLEXITY_API_KEY=   (https://perplexity.ai/settings/api)"
  echo "    YOUTUBE_API_KEY=      (https://console.cloud.google.com — optional)"
  echo
  read -r -p "  Press Enter to open the file in your default editor (or Ctrl+C to skip)... " _
  ${EDITOR:-open} "$ENV_FILE"
fi

echo
echo "Done."
if [[ "$TARGET_AGENT" == "codex" || "$TARGET_AGENT" == "both" ]]; then
  echo "Next steps for Codex:"
  echo "  1. Run: bash ~/.codex/skills/obsidian-second-brain/scripts/setup.sh \"/path/to/your/vault\""
  echo "  2. Open Codex in that vault and ask for /obsidian-init or 'use obsidian-second-brain to initialize this vault'"
fi
if [[ "$TARGET_AGENT" == "claude" || "$TARGET_AGENT" == "both" ]]; then
  echo "Next steps for Claude:"
  echo "  1. Run /obsidian-init to generate your vault's AGENTS.md and _CLAUDE.md"
fi
