---
description: Quick idea capture — zero friction, saves to Ideas/ and mentions in daily note
---

Use the obsidian-second-brain skill. Execute `/obsidian-capture $ARGUMENTS`:

The optional argument is the idea text. If not provided, pull the most recent idea or thought from the conversation.

1. Read `_CLAUDE.md` first if it exists in the vault root
2. Take the argument as the idea, or pull from recent conversation context
3. Search `Ideas/` for a related existing note — if found, append to it
4. If new: create `Ideas/Title.md` with minimal frontmatter (`date`, `tags: [idea]`)
5. Write the idea with any supporting context from the conversation
6. Add a brief mention in today's daily note under an Ideas or Captures section
