---
description: Show or update a kanban board — flags overdue items, updates from conversation
---

Use the obsidian-second-brain skill. Execute `/obsidian-board $ARGUMENTS`:

The optional argument is a board name. Handle typos and partial matches.

1. Read `_CLAUDE.md` first if it exists in the vault root
2. If a board name is given, search `Boards/` for it (fuzzy match)
3. If no name given, list available boards and ask which one
4. Read and display the current board state: columns, item counts, overdue items (past `@{date}`)
5. Ask if the user wants to make updates — if yes, infer changes from conversation context
6. Move completed items to ✅ Done with strikethrough, add new items in the right column
7. Flag any items that are overdue or have been in the same column for more than a week
