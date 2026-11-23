---
id: 01M81A2KFVFRYRDEBCDQ2FT208
created: 2026-11-22T09:40:55.419185Z
updated: 2026-11-23T10:45:38.746625Z
type: task
title: 'Polaris reads registers — its own Registers area: which registers there are, their entries, one entry with history and links, a register as it stood on a date, and what changed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2090
sprint: ssj8zkq
blocked_by:
- 01M81A1ZNSNWH7FM10E1J579E3
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint "Registers - Phase 2" (ADR 0167 §3, in COM-2087). Builds on the links between registers (so an entry's links include other registers' entries).

## What people see
- A new Polaris area, **Registers**, with its own address for Copilot (ADR 0144). Admin ▸ Assistant lists it with the others; Copilot needs one more agent, set up the same way.
- Polaris can answer:
  - "What registers do we keep?" — each with its owner, shared or per company, controls, entry count and when it was last reviewed or is due
  - "What fields does the obligations register have?"
  - "Which obligations are Not met?", "Show me contracts in OBL owned by Sam" — entries filtered by any field, or searched
  - "Tell me about OBL-4" — its values, history, links (including other registers' entries) and evidence
  - "What did the obligations register look like on 31 March?" — the as-at view
  - "What changed in the incident contacts register this quarter?"
- It works as the person: Restricted registers only if they can open them, per-company registers in the company being viewed.
- Answers give each entry's ID and a link to it.

## Implementation notes (technical)
- One `Area("registers", "Registers", "registers_", …)` in `core/assistant_areas.py`, with its instructions headings; the area test then covers it (128 limit, no orphans).
- Tools (read): `registers_list`, `registers_get`, `registers_list_entries` (filters by field id/value, text search, archived), `registers_get_entry`, `registers_as_at`, `registers_what_changed`.
- Instructions section: what a register is, shared vs per company, IDs, archived entries, "as at" meaning end of day in the company's time zone.
- MCP instructions for the area say Polaris can't make registers or change fields (next task adds entry writes).

## Done when
- The registers address lists the six tools (plus the shared ones), and a person connected there gets the answers above.
- A Restricted register is invisible to someone who can't open it.
- The as-at answer matches the screen's as-at view for the same date.

Independent once the links task is on main (no migration, no /api/v1 change).