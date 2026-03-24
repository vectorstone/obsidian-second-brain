---
name: obsidian-second-brain
description: >
  Operate any Obsidian vault as a living second brain. Use this skill whenever
  the user asks Claude to read, write, update, search, or manage their Obsidian
  vault — including saving notes from conversation, creating daily entries, updating
  kanban boards, logging dev work, managing people notes, capturing decisions,
  tracking deals, or maintaining any vault structure. Also triggers when the user
  wants to bootstrap a new vault from scratch, run a vault health check, or drop
  a _CLAUDE.md into their vault so all Claude surfaces share the same operating rules.
  Use proactively whenever the conversation produces information worth preserving
  (decisions, people met, projects started, tasks completed, lessons learned).
---

# Obsidian Second Brain

> Claude operates your Obsidian vault as a living OS — not a note-taking app.
> Everything worth remembering gets saved. Every update propagates everywhere it belongs.

---

## Quick Start

### 1. First time in a vault → read `_CLAUDE.md`

Before doing anything in a vault, check if `_CLAUDE.md` exists at the vault root:

```
read_text_file("/path/to/vault/_CLAUDE.md")
```

If it exists: follow its rules exactly — it overrides defaults below.
If it doesn't exist: use the defaults in this skill, then offer to create one.

### 2. First time with a new user → run discovery

```
directory_tree(vault_root, excludePatterns=[".obsidian", ".trash", "_archived"])
```

Scan the structure to understand: folder names, template locations, naming conventions, frontmatter patterns. Read 2–3 existing notes to calibrate writing style before creating anything new.

### 3. Bootstrap a new vault

If the user has no vault yet, run:
```bash
python scripts/bootstrap_vault.py --path ~/path/to/vault --name "Your Name"
```

This creates a complete production-ready vault structure with all templates, a Home dashboard, kanban boards, and a pre-filled `_CLAUDE.md`. See `scripts/bootstrap_vault.py`.

---

## Core Operating Principles

### Never create in isolation
Every write operation must ask: *where else does this belong?*

| You create/update... | Also update... |
|---|---|
| A new project note | Kanban board (add to Backlog), today's daily note (link it) |
| A task completed | Kanban board (move to Done), project note (log it), daily note |
| A person note | Daily note (mention interaction), People index if it exists |
| A dev log | Daily note (link it), project note (Recent Activity) |
| A deal update | Side Biz / Deals kanban, Dashboard totals |
| A decision made | Project note (Key Decisions), daily note |
| A mention/shoutout | Mentions Log, person's note, daily note |

Always propagate. Never create a single orphaned note.

### Search before creating
Before creating any new note, search for an existing one:
```
search_files(vault_root, pattern="keyword")
```
Duplicate notes are vault rot. Merge or update instead of creating new.

### Match the vault's voice
Read existing notes in the same folder before writing new ones.
Match: frontmatter schema, heading style, list formatting, tone, emoji usage (or lack of it).
Never introduce new conventions — extend what's already there.

### Frontmatter is mandatory
Every note gets frontmatter. At minimum:
```yaml
---
date: 2026-03-24
tags:
  - <note-type>
---
```
See `references/vault-schema.md` for full frontmatter specs by note type.

---

## Write Rules

See `references/write-rules.md` for the complete guide. Summary:

- **Links**: Use `[[Note Name]]` for internal links. Always link to people, projects, and jobs mentioned in a note.
- **Dates**: ISO format (`YYYY-MM-DD`) in frontmatter. Human format (`March 24`) in body text.
- **Naming**: `YYYY-MM-DD — Title.md` for dated notes. `Title.md` for evergreen notes. No special characters except `—` (em dash).
- **Status values**: `active` / `planning` / `completed` / `archived` / `on-hold` for projects. `in-progress` / `done` / `waiting` for tasks.
- **Kanban**: Items follow the format `- [ ] 🔴 **Title** · @{YYYY-MM-DD}\n\tDescription [[Link]]`

---

## The `_CLAUDE.md` File

This is the most important concept in this skill.

`_CLAUDE.md` lives at the vault root and persists Claude's operating rules across every session and every surface (Claude Desktop, Claude Code, VS Code, terminal). Without it, Claude has to re-learn your vault conventions every conversation.

**What it contains:**
- Your vault's folder map and what each folder is for
- Frontmatter schemas for your specific note types
- Naming conventions you use
- What to auto-save vs. what to ask first
- People and projects that need special handling
- Links to key files (boards, dashboard, templates)

To generate a `_CLAUDE.md` for an existing vault, run vault discovery then use the template in `references/claude-md-template.md`.

To install it: write the file to the vault root. Every Claude session that starts in that vault should read it first.

---

## Common Operations

### Save info from conversation
When a conversation produces something vault-worthy:
1. Identify the note type (decision → project note, person met → People/, task → board + Tasks/, etc.)
2. Check if a relevant note already exists
3. Write or update — always frontmatter-first
4. Propagate to boards, daily note, linked notes

### Create today's daily note
```
date = today in YYYY-MM-DD format
path = Daily/{date}.md
```
Read `Templates/Daily Note.md`, fill in the date fields, create the file.
Then scan recent conversation for anything worth logging in today's sections.

### Log a dev session
Read `Templates/Dev Log.md`. Fill: date, project name, what was worked on, problems solved, decisions made, next steps.
Save to `Dev Logs/YYYY-MM-DD — Project Name.md`.
Link from project note's Recent Activity section and today's daily note.

### Update a kanban board
Boards use the `kanban-plugin: board` frontmatter.
Columns are `## Column Name` headers.
Items are `- [ ] **Title** · @{due-date}\n\tDescription [[Links]]`
Completed items move to the `## ✅ Done` column with a strikethrough: `- [x] ~~**Title**~~ ✅ Date`

### Run vault health check
```bash
python scripts/vault_health.py --path ~/path/to/vault
```
Reports: duplicate notes, orphaned files (no incoming links), stale tasks (overdue), empty folders, broken links, notes missing frontmatter.

---

## Reference Files

- `references/vault-schema.md` — Complete folder structure + frontmatter specs for all note types
- `references/write-rules.md` — Detailed writing, linking, and formatting rules
- `references/claude-md-template.md` — Template for generating a vault's `_CLAUDE.md`

## Scripts

- `scripts/bootstrap_vault.py` — Bootstrap a complete vault from scratch
- `scripts/vault_health.py` — Audit a vault for structural issues
