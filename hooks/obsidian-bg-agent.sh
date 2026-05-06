#!/usr/bin/env bash
# Optional vault propagation helper.
# Claude can wire this to PostCompact. Codex can run it from external automation.

CONFIG_FILE="$HOME/.config/obsidian-second-brain/config.env"
if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
fi

VAULT="${OBSIDIAN_VAULT_PATH:-}"
[[ -z "$VAULT" ]] && exit 0

INPUT=$(cat)
TRANSCRIPT=$(printf '%s' "$INPUT" | jq -r '.transcript_path // ""' 2>/dev/null || true)
SUMMARY=""
if [[ -n "$TRANSCRIPT" && -f "$TRANSCRIPT" ]]; then
  SUMMARY=$(jq -rc 'select(.isCompactSummary == true) | .message.content // "" | @base64' "$TRANSCRIPT" 2>/dev/null | tail -n 1 | base64 -d 2>/dev/null || true)
fi
[[ -z "$SUMMARY" ]] && SUMMARY="$INPUT"
[[ -z "$SUMMARY" ]] && exit 0

TODAY=$(date +%Y-%m-%d)
PROMPT_FILE=$(mktemp /tmp/obsidian-bg-XXXXXX.txt)
cat > "$PROMPT_FILE" <<HEADER
You are an autonomous Obsidian vault agent. Propagate everything worth preserving from the summary to the vault. Run silently.

VAULT: $VAULT
TODAY: $TODAY

SESSION SUMMARY:
HEADER
printf '%s

' "$SUMMARY" >> "$PROMPT_FILE"
cat >> "$PROMPT_FILE" <<'INSTRUCTIONS'
INSTRUCTIONS:
1. Read AGENTS.md at the vault root first if it exists. If not, read _CLAUDE.md.
2. Identify all vault-worthy items in the summary: decisions, tasks, people, projects, dev work, ideas, learnings.
3. Search before creating. Never duplicate notes.
4. Propagate updates to the daily note, boards, and linked notes.
5. If nothing is vault-worthy, exit without changes.
6. Use filesystem tools only. No questions. No user-facing output.
INSTRUCTIONS
PROMPT=$(cat "$PROMPT_FILE")
rm -f "$PROMPT_FILE"

mkdir -p /tmp
if command -v claude >/dev/null 2>&1; then
  (
    cd "$VAULT" && claude --dangerously-skip-permissions -p "$PROMPT" >> /tmp/obsidian-bg-agent.log 2>&1
  ) &
elif command -v codex >/dev/null 2>&1; then
  (
    cd "$VAULT" && codex exec --skip-git-repo-check --dangerously-bypass-approvals-and-sandbox "$PROMPT" >> /tmp/obsidian-bg-agent.log 2>&1
  ) &
fi

exit 0
