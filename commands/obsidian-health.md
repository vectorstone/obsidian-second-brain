---
description: Run a vault health check — grouped by severity, offers to fix safe issues
---

Use the obsidian-second-brain skill. Execute `/obsidian-health`:

1. Read `_CLAUDE.md` first to find the vault path
2. Run: `python ~/.claude/skills/obsidian-second-brain/scripts/vault_health.py --path ~/path/to/vault --json`
   (replace vault path with the one from `_CLAUDE.md`)
3. Parse the JSON output and split findings into categories
4. Spawn parallel subagents to handle each category simultaneously:
   - **Links agent**: verify broken links, attempt to resolve them
   - **Duplicates agent**: confirm duplicates are truly the same concept, not just similar names
   - **Frontmatter agent**: identify notes missing required fields by type
   - **Staleness agent**: check overdue tasks and unfilled template syntax
   - **Orphans agent**: check orphaned notes and empty folders
5. Merge results and group by severity:
   - 🔴 Critical: broken links, unfilled template syntax
   - 🟡 Warning: duplicates, stale tasks, missing frontmatter
   - ⚪ Info: orphaned notes, empty folders
6. For safe fixes (missing frontmatter, obvious duplicates), offer to fix automatically
7. For destructive fixes (archiving, merging), list them and ask for explicit confirmation first
