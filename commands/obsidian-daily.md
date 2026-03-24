---
description: Create or update today's daily note, pre-filled from conversation context
---

Use the obsidian-second-brain skill. Execute `/obsidian-daily`:

1. Read `_CLAUDE.md` first if it exists in the vault root
2. Check if `Daily/YYYY-MM-DD.md` exists for today
3. If not: read `Templates/Daily Note.md`, fill in date fields, create the file
4. Scan the current conversation for anything relevant to today: tasks in progress, people mentioned, decisions made, what's being worked on
5. Pre-fill or update the note's sections with that context
6. If the note already exists, inject new content into the right sections rather than overwriting

Return the path of the daily note when done.
