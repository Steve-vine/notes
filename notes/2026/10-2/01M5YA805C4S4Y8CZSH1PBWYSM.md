---
id: 01M5YA805C4S4Y8CZSH1PBWYSM
created: 2026-10-27T09:14:45.292788Z
updated: 2026-10-27T09:14:45.292788Z
type: task
title: Each night Compass keeps the day's vulnerability figures for every company — open by severity, overdue, found, fixed, by source and by system — so change over time can be drawn
label: feature
assignee: steve
task_status: todo
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1370
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1368. The ADR 0070 pattern, as Posture ▸ Timeline does it.

## What it keeps

One record per company per day:
- open, by severity;
- open by kind;
- overdue, by severity;
- accepted;
- found that day and fixed that day;
- open by source;
- open critical and high by system;
- the average days to fix, over items fixed in the last 90 days;
- the oldest open critical and high.

## Rules

- **One calculation.** The Overview's "now" figures and the nightly record come from the same function, so today's line ends where the cards say.
- Informational items are left out, as on the Overview.
- **No guessing.** A day with no record shows a gap, not a joined-up line.
- **History before the module existed** can be rebuilt once from each vulnerability's history, marked "reconstructed". It matters for sprint 92's first Nessus import, which brings months of first-seen dates.

## Notes (technical)

- A `vulnerability_snapshots` table unique on (company, day). Headline numbers as columns, breakdowns as JSONB.
- A Beat entry at 23:40, after posture's 23:30, with a plain label for System status.
- The rebuild is a one-off task, to be run again after a backfilling import.

**Chain:** on the chain (migration + API).

**Done when:**
- a nightly row is written per company;
- today's figures equal the Overview's;
- the rebuild draws a history for imported items.