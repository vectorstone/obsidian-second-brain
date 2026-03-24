---
description: Smart vault search — returns results with context, not just filenames
---

Use the obsidian-second-brain skill. Execute `/obsidian-find $ARGUMENTS`:

The argument is the search query.

1. Read `_CLAUDE.md` first if it exists in the vault root
2. Run `search(query="...")` with the provided query
3. Also try variations if results are sparse (synonyms, related terms)
4. Return results with context: note title, folder, a relevant excerpt, and what type of note it is
5. If results are ambiguous, group them by type (people, projects, tasks, etc.)
6. Offer to open, update, or link any of the found notes

Do not just return filenames — return enough context for the user to act on the results.
