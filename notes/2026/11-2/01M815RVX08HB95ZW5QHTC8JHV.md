---
id: 01M815RVX08HB95ZW5QHTC8JHV
created: 2026-11-22T08:25:42.048574Z
updated: 2026-11-22T08:25:46.191709Z
type: task
title: 'ADR 0166 — obligations and interested parties can be kept separately or together: three templates instead of one, and a note when a control is already kept by another register'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2086
sprint: s64t54m
assignee: steve
label:
- brief
priority: high
task_status: active
---
Sprint "Registers". Steve, 2026-11-22: offer both options for INS.5 and INS.12, not only the combined register ADR 0165 §9 chose.

## The decision
- Three templates where there was one:
  - **Legal, regulatory and contractual obligations** (OBL, shared, INS.5, yearly)
  - **Interested parties** (PTY, shared, INS.12, yearly)
  - **Obligations and interested parties** (OIP, shared, INS.5 + INS.12, yearly)
- Each has its own prefix, so any mix can be made without a clash.
- When a register is about to be kept for a control that another register is already kept for, a note says which register. This happens in the template preview and when someone adds a control to a register. It advises; it doesn't block.
- Linking an Interested parties entry to the obligations it gives rise to (a link between entries in two registers) is left to the second sprint.

## Done when
- `decisions/0166-*.md` merged, amending ADR 0165 §9 and the planning call it lists as 5.
- `brief/feature-set-and-phasing.md` §7a matches.
- COM-2084 rewritten to match.

Docs only. Independent.