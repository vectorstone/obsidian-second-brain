---
description: Save everything worth keeping from this conversation to the vault
---

Use the obsidian-second-brain skill. Execute `/obsidian-save`:

1. Read `_CLAUDE.md` first if it exists in the vault root
2. Scan the entire conversation and identify all vault-worthy items: decisions, tasks, people mentioned, projects started, ideas, learnings, deals, mentions/shoutouts
3. Group items by type: people, projects, tasks, decisions, ideas, deals
4. Spawn parallel subagents — one per group — so all note types are handled simultaneously:
   - **People agent**: search for each person, create or update notes, log interactions
   - **Projects agent**: search for each project, create or update notes
   - **Tasks agent**: parse tasks, add to the right kanban columns
   - **Decisions agent**: find relevant project notes, append to Key Decisions sections
   - **Ideas agent**: search Ideas/ for related notes, create or append
5. After all agents complete: update today's daily note with links to everything saved
6. Report back: a clean list of what was saved and where

Search before creating anything — duplicate notes are vault rot. Propagate every write to boards, daily note, and linked notes. Never create an orphaned note.
