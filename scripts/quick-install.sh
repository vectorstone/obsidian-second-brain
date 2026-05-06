#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/eugeniughelbur/obsidian-second-brain"
TARGET_AGENT="${TARGET_AGENT:-codex}"
DEFAULT_BASE="$HOME/.codex/skills"
if [[ "$TARGET_AGENT" == "claude" ]]; then
  DEFAULT_BASE="$HOME/.claude/skills"
fi
SKILL_DIR="${SKILL_DIR:-$DEFAULT_BASE/obsidian-second-brain}"

red()    { printf '[0;31m%s[0m
' "$1"; }
green()  { printf '[0;32m%s[0m
' "$1"; }
yellow() { printf '[0;33m%s[0m
' "$1"; }

if ! command -v git &>/dev/null; then
  red "Error: git not found. Install git and retry."
  exit 1
fi

if [[ -d "$SKILL_DIR/.git" ]]; then
  yellow "Repo already at $SKILL_DIR — pulling latest..."
  git -C "$SKILL_DIR" pull --ff-only
else
  if [[ -e "$SKILL_DIR" ]]; then
    red "Error: $SKILL_DIR exists and is not a git checkout. Move it aside first."
    exit 1
  fi
  mkdir -p "$(dirname "$SKILL_DIR")"
  git clone "$REPO_URL" "$SKILL_DIR"
fi

green "Skill installed at $SKILL_DIR"

VAULT="${OBSIDIAN_VAULT_PATH:-}"
if [[ -z "$VAULT" ]]; then
  if [[ ! -t 0 ]]; then
    yellow "Vault path required. Re-run with OBSIDIAN_VAULT_PATH set, or run setup.sh directly:"
    echo "  bash $SKILL_DIR/scripts/setup.sh \"/path/to/your/vault\""
    exit 0
  fi
  printf "Path to your Obsidian vault: "
  read -r VAULT
fi

bash "$SKILL_DIR/scripts/setup.sh" "$VAULT" --target "$TARGET_AGENT"
