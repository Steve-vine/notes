---
id: 01M81A2KFVFRYRDEBCDQ2FT208
created: 2026-11-22T09:40:55.419185Z
updated: 2026-11-23T12:09:12.559111Z
type: task
title: 'Polaris reads registers — its own Registers area: which registers there are, their entries, one entry with history and links, a register as it stood on a date, and what changed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2090
sprint: ssj8zkq
blocked_by:
- 01M81A1ZNSNWH7FM10E1J579E3
comments:
- id: 01M844YS2FZYSNYGPNM1Y1QW5K
  author: Steve Vine
  at: 2026-11-23T12:09:10.479725Z
  text: |-
    Built and merged to main in two PRs: #2091 (8d7393867) and #2093 (b2925397b). No migration, no /api/v1 change.

    What people see:
    - Polaris has a Registers area with its own Copilot address (/api/mcp/registers), listed in Admin ▸ Assistant. It is read-only.
    - It can list the registers (owner, shared or per company, controls, entry count, last and next review), show a register's fields, filter or search entries, show one entry with its values, history, links and evidence, show a register as at a date, and say what changed over a period.
    - For "this month", "last month", "this quarter" or "last quarter", Compass works out the dates and the answer states them. A period still running is read up to today and marked as such. Explicit dates work too.
    - Answers give each entry's ID and a link.

    Steve needs to: set up one more Copilot agent for the Registers address, the same way as the others.

    Decisions made while building, for Steve to check:
    1. Everyone who can connect an assistant gets the area, because a register's owner or editor may have no register permission. Someone with access to no registers gets an empty list.
    2. Filters: text fields match on contained words; numbers and dates match exactly. There are no ranges such as "due before 31 March".
    3. On a shared register with no company named, links and evidence held by a company are left out, and the answer says so.
    4. As at and named periods follow the person's own clock, matching the screen. Posture's What changed page uses the deployment's clock, so around a month or quarter boundary the two could differ by a day for someone in another time zone. Posture is unchanged.
    5. The as-at tool can also take a single entry and show the links it held on that date.

    Tested against real Postgres: the six tools; Restricted registers invisible in every tool, search, links and history; per-company registers; as-at equal to the screen's list on five past days, including archived entries and removed fields; named periods either side of a boundary. CI green.

    Not checked: a real Copilot Studio agent, or the Polaris window with a live AI provider choosing the named period from a question (please try "What changed in this register this quarter?" in UAT); very large registers (the Polaris window cuts a tool answer at 60,000 characters); past-date as-at on a per-company register; evidence that is a file. The Polaris window has no Registers section until COM-2091.
assignee: steve
label:
- feature
priority: medium
task_status: review
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