---
description: Create or update a person note from conversation context
---

Use the obsidian-second-brain skill. Execute `/obsidian-person $ARGUMENTS`:

The argument is a person's name — handle typos and partial matches.

1. Read `_CLAUDE.md` first if it exists in the vault root
2. Search the vault for an existing note matching the name (fuzzy — handle typos and partial names)
3. If found: confirm with user, then update with new info from conversation
4. If not found: create `People/Full Name.md` with full frontmatter schema
5. Fill in everything inferable from the conversation: role, company, context, relationship strength, last interaction date
6. Log the interaction in today's daily note
7. If a People index file exists, add or update the entry there

If the name has a typo or is approximate, search the vault, show what was found, and confirm before proceeding. Never silently create a note with a misspelled name.
