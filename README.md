# 🧠 obsidian-second-brain

**A Claude skill that turns your Obsidian vault into a living second brain — operated autonomously across every Claude surface.**

Instead of manually saving notes, Claude reads your conversations and writes directly to your vault: creating daily notes, logging dev sessions, updating kanban boards, tracking people, capturing decisions — and always propagating changes everywhere they belong.

---

## What This Is

A [Claude skill](https://docs.anthropic.com/en/docs/build-with-claude/skills) — a set of instructions and scripts that teaches Claude how to operate any Obsidian vault as a persistent OS for your life and work.

**The key idea: `_CLAUDE.md`**

A file that lives inside your vault and tells every Claude surface (Desktop, Code, VS Code, terminal) exactly how your vault works — your folder structure, naming conventions, what to auto-save, what to ask first. No memory required. Every session starts with full context.

---

## Features

### 🤖 Autonomous vault operations
Claude writes to your vault from any surface — Claude Desktop, Claude Code, VS Code, terminal — consistently, because they all read `_CLAUDE.md` first.

### 🔗 Propagation rule
Nothing gets saved in isolation. Create a project → it appears on the kanban board and in today's daily note. Complete a task → it's logged in the project, the board, and the daily note. Every write propagates everywhere it belongs.

### 📋 Full note lifecycle
- Daily notes with structured sections
- Dev logs linked to projects
- People notes with interaction history
- Kanban boards with proper done/in-progress/waiting columns
- Deal tracking with pipeline math
- Goal tracking with progress
- Mentions log for recognition

### 🔍 Search before write
Claude searches for existing notes before creating new ones. No duplicates, no vault rot.

### 🏗️ Bootstrap from scratch
Run one command to generate a complete, production-ready vault structure with all templates, a Home dashboard, kanban boards, and a pre-filled `_CLAUDE.md`.

### 🩺 Health check
Scan any vault for duplicates, orphaned notes, stale tasks, broken links, missing frontmatter, and unfilled templates.

---

## Quick Start

### Option A — Install into existing Claude setup

1. Clone this repo into your Claude skills directory:
```bash
git clone https://github.com/eugeniughelbur/obsidian-second-brain ~/.claude/skills/obsidian-second-brain
```

2. Make sure the [obsidian-vault MCP server](https://github.com/calclavia/mcp-obsidian) is configured in your Claude config:

**Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "obsidian-vault": {
      "command": "npx",
      "args": ["-y", "mcp-obsidian", "/path/to/your/vault"]
    }
  }
}
```

**Claude Code** (`~/.claude/settings.json`):
```json
{
  "mcpServers": {
    "obsidian-vault": {
      "command": "npx",
      "args": ["-y", "mcp-obsidian", "/path/to/your/vault"]
    }
  }
}
```

3. Drop a `_CLAUDE.md` into your vault:
```
"Claude, generate a _CLAUDE.md for my vault"
```

Claude will scan your vault structure, read your templates, and generate a customized operating manual.

### Option B — Bootstrap a new vault

```bash
python scripts/bootstrap_vault.py \
  --path ~/my-vault \
  --name "Your Name" \
  --jobs "Company Name"
```

This creates a complete vault with all folders, templates, kanban boards, a Home dashboard with Dataview queries, and a ready-to-use `_CLAUDE.md`.

Then configure the MCP server to point at the new path, restart Claude, and you're live.

---

## How `_CLAUDE.md` Works

```
Your Mac
│
├── Claude Desktop / Claude Code / VS Code
│   └── reads _CLAUDE.md on every session start
│
└── Your Vault/
    ├── _CLAUDE.md          ← Claude's operating manual
    ├── Home.md
    ├── Daily/
    ├── Projects/
    ├── Boards/
    └── ...
```

`_CLAUDE.md` is not magic — it's a plain markdown file. But it's the file that makes every Claude surface behave consistently in your vault, without relying on Claude's memory between sessions.

It contains:
- Your folder map and what each folder is for
- Naming conventions
- Frontmatter schemas for your note types
- What to auto-save vs. what to ask first
- Active context (current priorities, key people)
- Kanban format rules
- Propagation rules (when X happens, also update Y)

Update it when your priorities shift or your structure changes:
```
"Claude, update my _CLAUDE.md"
```

---

## Vault Health Check

```bash
python scripts/vault_health.py --path ~/my-vault
```

Reports:
- 🔴 Unfilled template syntax left in notes
- 🟡 Possible duplicate notes
- 🟡 Stale / overdue tasks
- 🟡 Notes missing frontmatter
- 🟡 Broken internal links (`[[Note]]` pointing to nothing)
- ⚪ Orphaned notes (nothing links to them)
- ⚪ Empty folders

For machine-readable output (to pipe into Claude):
```bash
python scripts/vault_health.py --path ~/my-vault --json
```

---

## Skill Structure

```
obsidian-second-brain/
├── SKILL.md                          ← Core instructions for Claude
├── references/
│   ├── vault-schema.md               ← Folder structure + frontmatter specs
│   ├── write-rules.md                ← How Claude writes, links, and propagates
│   └── claude-md-template.md        ← Template for generating _CLAUDE.md
└── scripts/
    ├── bootstrap_vault.py            ← Bootstrap a complete vault from scratch
    └── vault_health.py               ← Audit a vault for structural issues
```

---

## Recommended Obsidian Plugins

| Plugin | Why |
|---|---|
| [Dataview](https://github.com/blacksmithgu/obsidian-dataview) | Powers the Home dashboard queries |
| [Templater](https://github.com/SilentVoid13/Templater) | Powers the Templates/ folder |
| [Kanban](https://github.com/mgmeyers/obsidian-kanban) | Powers the Boards/ folder |
| [Calendar](https://github.com/liamcain/obsidian-calendar-plugin) | Daily note navigation |

---

## Examples

### "Save what we just discussed"
Claude identifies what's worth saving from the conversation, determines the right note type(s), checks for existing notes, writes them with correct frontmatter, and propagates to boards and daily note — without you specifying where anything goes.

### "Log today's work session"
Claude creates a dev log with what was worked on, problems solved, and decisions made. Links it from the relevant project note and today's daily note automatically.

### "Update my Side Biz board with the new client deal"
Claude finds or creates the deal file, sets frontmatter (status, pax, revenue, probability), adds it to the kanban board in the right column, and updates the pipeline math in the dashboard.

### "Run a health check on my vault"
Claude calls `vault_health.py` and summarizes the findings — duplicates, orphans, broken links — and offers to fix the safe ones automatically.

---

## Philosophy

> A second brain shouldn't require manual maintenance. If you have to think about where to put something, the system is broken.

The goal is zero friction. You work, talk, and think. Claude handles the memory.

---

## Contributing

PRs welcome. Especially interested in:
- Additional note type schemas (habits, books, investments)
- Agent integration (automated vault updates from Slack/email)
- Alternative folder structures (GTD, PARA, Zettelkasten variants)
- VS Code / Cursor-specific setup guides

---

## License

MIT
