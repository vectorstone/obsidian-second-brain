#!/usr/bin/env bash
set -euo pipefail

# Install local wrapper commands for Codex so users can run:
#   obsidian-init
#   obsidian-daily
#   x-read
# etc.
# These wrappers delegate to scripts/run-command.sh.

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$HOME/.codex/bin"
mkdir -p "$BIN_DIR"

for file in "$SKILL_DIR/commands/"*.md; do
  name="$(basename "$file" .md)"
  wrapper="$BIN_DIR/$name"
  cat > "$wrapper" <<EOF
#!/usr/bin/env bash
exec "$SKILL_DIR/scripts/run-command.sh" "$name" "\$@"
EOF
  chmod +x "$wrapper"
done

echo "Installed command wrappers to $BIN_DIR"
echo "Add this to your shell rc if needed:"
echo "  export PATH=\"$BIN_DIR:\$PATH\""
echo
printf 'Commands installed:\n'
for file in "$SKILL_DIR/commands/"*.md; do
  basename "$file" .md
 done | sed 's/^/  - /'
