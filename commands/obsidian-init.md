---
description: Scan your vault and generate a _CLAUDE.md operating manual
---

Use the obsidian-second-brain skill. Execute `/obsidian-init`:

1. Call `list_files_in_vault()` to map the full vault structure
2. Spawn parallel subagents to discover vault context simultaneously:
   - **Dashboard agent**: read `Home.md` or equivalent dashboard
   - **Templates agent**: read all files in `Templates/`
   - **Boards agent**: read all files in `Boards/`
   - **Samples agent**: read one existing note per major folder to capture naming conventions and frontmatter patterns
3. Merge all agent results into a complete picture of the vault
4. Generate a complete `_CLAUDE.md` using the template in `~/.claude/skills/obsidian-second-brain/references/claude-md-template.md`, filled with real values from the vault
5. Write it to `_CLAUDE.md` at the vault root via `append_content("_CLAUDE.md", content)`
6. Confirm what was written and tell the user to restart their Claude session so the new file takes effect

If `_CLAUDE.md` already exists: show a diff of what would change and ask before overwriting.
