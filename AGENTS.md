# Repository Guidelines

This repository packages **obsidian-second-brain** for Codex-first use, while keeping Claude compatibility where practical.

## Project layout
- `SKILL.md` - primary Codex skill manual.
- `commands/` - command-intent reference files.
- `references/` - shared templates/specs. `ai-first-rules.md` is canonical for vault note shape.
- `scripts/` - bootstrap, health-check, install/setup, research helpers.
- `hooks/` - optional background automation entrypoints.
- `README.md` - end-user install and usage docs.

## Non-negotiable rule
Any command or script that writes into a vault must preserve the AI-first rule:
- self-contained notes
- rich frontmatter
- wikilinks
- recency markers for external claims
- source URLs preserved
- confidence markers where applicable

Do not simplify output into human-only notes if that drops retrieval structure.

## Codex migration conventions
- Prefer `AGENTS.md` at vault root. `_CLAUDE.md` is legacy compatibility only.
- Prefer generic “agent” wording in new docs/scripts unless a Claude-only behavior is truly required.
- Keep Codex install paths under `~/.codex/skills/obsidian-second-brain`.
- Do not assume Codex has a Claude-style `PostCompact` hook.

## Editing rules
- Keep diffs small and reversible.
- When changing `commands/*.md`, update `SKILL.md` and relevant docs if behavior changes.
- When changing note templates or generated vault files, update both bootstrap scripts and reference templates.
- Prefer repo-relative or auto-detected paths over hard-coded `~/.claude/...` paths.

## Validation
Before claiming completion, re-scan for broken `~/.claude` / `_CLAUDE.md` assumptions, run targeted script checks, and verify the documented install flow still matches the code.
