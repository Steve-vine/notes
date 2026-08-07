---
id: 01KYHPWS667X1GY8SMYRND46RT
created: 2026-07-27T11:55:48.806456Z
updated: 2026-08-07T08:35:16.349026Z
type: task
title: 'Claude Code client kit: skill, statusline, on-context behaviour + "Work on this in Claude" entry point'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 337
sprint: sax9eff
assignee: steve
priority: medium
task_status: done
---
The operator-side experience: make working with ISE in Claude Code unmistakable, easy to enter, and hard to wander out of. Shipped in-repo (e.g. `clients/claude-code/`) with docs.

- **ISE skill**: loads on `/ise:work-on` (wrapping the MCP prompt) — instructs Claude to lead with the cues block, keep the conversation on the pinned incident (politely deflect off-topic requests back to the incident or suggest `/ise:exit`), record conclusions via `record_note`/`commit_diagnosis` rather than leaving them in chat, and prefer ISE tools over local ones for anything ISE governs.
- **Statusline**: the visual clue — `ISE ▸ IN-1092 (acknowledged) ▸ Steve` while a session is pinned, cleared on exit. The user can always see they're "in ISE", not any old chat.
- **Optional hooks** (documented, off by default): ship user prompts to the session's activity record for a fuller transcript — belt-and-braces beyond the tools-are-the-audit-surface model; team decision whether to enable.
- **UI (pane-of-glass DoD)**: a "Work on this in Claude" button on the incident screen — copyable one-liner (server add if first time + `/ise:work-on IN-NNNN`), plus a first-run setup page in Settings linking token minting to client-kit install.
- Setup docs cover: mint token → `claude mcp add` → install kit → work an incident. Target: an operator who has never used Claude Code is working an incident inside 10 minutes.

Vertical DoD: fresh machine → follow docs → button on IN-1092 → pinned session with statusline showing it, and an off-topic request gets steered back.