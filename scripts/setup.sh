#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config/obsidian-second-brain"
STATE_ENV="$CONFIG_DIR/config.env"
HOOK_SCRIPT="$SKILL_DIR/hooks/obsidian-bg-agent.sh"
TARGET="codex"

if [[ "${2:-}" == "--target" ]]; then
  TARGET="${3:-codex}"
elif [[ -n "${2:-}" ]]; then
  TARGET="$2"
fi

green()  { printf '[0;32m%s[0m
' "$1"; }
yellow() { printf '[0;33m%s[0m
' "$1"; }
red()    { printf '[0;31m%s[0m
' "$1"; }
step()   { printf '
[1m%s[0m
' "$1"; }

VAULT="${1:-}"
if [[ -z "$VAULT" ]]; then
  red "Error: vault path required."
  echo "Usage: bash scripts/setup.sh \"/path/to/your/vault\" [--target codex|claude|both]"
  exit 1
fi
VAULT="$(eval echo "$VAULT")"
if [[ ! -d "$VAULT" ]]; then
  red "Error: vault directory not found: $VAULT"
  exit 1
fi

mkdir -p "$CONFIG_DIR"

echo
echo "obsidian-second-brain setup"
echo "==========================="
echo "Vault:  $VAULT"
echo "Skill:  $SKILL_DIR"
echo "Target: $TARGET"

echo
step "1. Making hook script executable..."
chmod +x "$HOOK_SCRIPT"
green "   Done — $HOOK_SCRIPT"

step "2. Writing shared config..."
cat > "$STATE_ENV" <<EOF
OBSIDIAN_VAULT_PATH=$VAULT
OBSIDIAN_SECOND_BRAIN_HOME=$SKILL_DIR
EOF
chmod 600 "$STATE_ENV"
green "   Wrote $STATE_ENV"

if [[ "$TARGET" == "codex" || "$TARGET" == "both" ]]; then
  step "3. Optional MCP server for Codex..."
  echo "   The obsidian-vault MCP server gives Codex faster vault access."
  read -r -p "   Configure MCP server for Codex now? [y/N] " REPLY
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if command -v codex &>/dev/null; then
      codex mcp add obsidian-vault -- npx -y mcp-obsidian "$VAULT" || true
      green "   Codex MCP command attempted"
    else
      yellow "   codex CLI not found — skipping MCP setup"
      echo "   Run manually: codex mcp add obsidian-vault -- npx -y mcp-obsidian \"$VAULT\""
    fi
  else
    echo "   Skipped. Run later: codex mcp add obsidian-vault -- npx -y mcp-obsidian \"$VAULT\""
  fi

  step "4. Background automation note..."
  yellow "   Codex does not expose a Claude-style PostCompact hook here."
  echo "   The helper script remains available at: $HOOK_SCRIPT"
  echo "   It can run via codex exec when called from external automation."
fi

if [[ "$TARGET" == "claude" || "$TARGET" == "both" ]]; then
  step "5. Optional MCP server for Claude..."
  read -r -p "   Configure MCP server for Claude Code? [y/N] " REPLY
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    if command -v claude &>/dev/null; then
      claude mcp add obsidian-vault -s user -- npx -y mcp-obsidian "$VAULT" || true
      green "   Claude MCP command attempted"
    else
      yellow "   claude CLI not found — skipping Claude MCP setup"
    fi
  fi
fi

echo
echo "==========================="
green "Setup complete."
echo "Next step: open Codex in your vault directory and run /obsidian-init (or ask to initialize the vault with obsidian-second-brain)."
echo "This will generate AGENTS.md for Codex and a matching _CLAUDE.md for Claude compatibility."
echo "Health check: python $SKILL_DIR/scripts/vault_health.py --path \"$VAULT\""
