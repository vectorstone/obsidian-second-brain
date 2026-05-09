#!/usr/bin/env bash
set -euo pipefail

# Run an obsidian-second-brain command through Codex using command markdown files.
# Supports invocations like:
#   run-command.sh /obsidian-init
#   run-command.sh $obsidian-init
#   run-command.sh obsidian-init
#   run-command.sh /research "topic here"
#
# Environment:
#   OBSIDIAN_SECOND_BRAIN_HOME  optional skill root override
#   OBSIDIAN_VAULT_PATH         optional vault path override
#   CODEX_BIN                   optional codex binary override

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="${OBSIDIAN_SECOND_BRAIN_HOME:-$(cd "$SELF_DIR/.." && pwd)}"
CODEX_BIN="${CODEX_BIN:-codex}"
CONFIG_FILE="$HOME/.config/obsidian-second-brain/config.env"

if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
fi

usage() {
  cat <<EOF
Usage:
  $(basename "$0") <command> [args...]

Examples:
  $(basename "$0") /obsidian-init
  $(basename "$0") '\$obsidian-daily'
  $(basename "$0") research "state of MCP servers"
  OBSIDIAN_VAULT_PATH=~/vault $(basename "$0") /obsidian-health
EOF
}

[[ $# -ge 1 ]] || { usage >&2; exit 2; }

RAW_CMD="$1"
shift || true
ARGS=("$@")

CMD="${RAW_CMD#/}"
CMD="${CMD#\$}"
CMD="${CMD%.md}"

COMMAND_FILE="$SKILL_DIR/commands/$CMD.md"
if [[ ! -f "$COMMAND_FILE" ]]; then
  echo "Unknown command: $RAW_CMD" >&2
  echo "Expected command file: $COMMAND_FILE" >&2
  exit 1
fi

VAULT="${OBSIDIAN_VAULT_PATH:-${OBSIDIAN_VAULT_PATH:-}}"
if [[ -z "$VAULT" ]]; then
  # Default to current directory if it looks like a vault, else keep cwd.
  VAULT="$PWD"
fi
VAULT="$(eval echo "$VAULT")"
if [[ ! -d "$VAULT" ]]; then
  echo "Vault directory not found: $VAULT" >&2
  exit 1
fi

if ! command -v "$CODEX_BIN" >/dev/null 2>&1; then
  echo "codex CLI not found (looked for: $CODEX_BIN)" >&2
  exit 1
fi

COMMAND_BODY="$(cat "$COMMAND_FILE")"
PROMPT_FILE="$(mktemp /tmp/obsidian-cmd-XXXXXX.md)"
cat > "$PROMPT_FILE" <<EOF
You are executing an installed obsidian-second-brain command inside a Codex session.

Command name: /$CMD
Skill root: $SKILL_DIR
Vault root: $VAULT
Current working directory: $VAULT

Important:
- Treat this exactly like the user invoked /$CMD in a slash-command-capable client.
- Read AGENTS.md at the vault root first if it exists. Otherwise read _CLAUDE.md.
- Follow the command spec below exactly.
- If the command references ~/.codex/skills/obsidian-second-brain, use $SKILL_DIR instead.
- If the user supplied arguments, incorporate them naturally.

User-supplied arguments:
EOF
if [[ ${#ARGS[@]} -eq 0 ]]; then
  printf '(none)\n\n' >> "$PROMPT_FILE"
else
  printf '%s\n\n' "${ARGS[*]}" >> "$PROMPT_FILE"
fi
cat >> "$PROMPT_FILE" <<'EOF'
Command spec:
EOF
printf '%s
' "$COMMAND_BODY" >> "$PROMPT_FILE"

echo "[obsidian-second-brain] Running /$CMD in $VAULT" >&2
exec "$CODEX_BIN" exec --skip-git-repo-check --cd "$VAULT" "$PROMPT_FILE"
