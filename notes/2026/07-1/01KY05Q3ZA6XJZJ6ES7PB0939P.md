---
id: 01KY05Q3ZA6XJZJ6ES7PB0939P
created: 2026-07-20T16:28:32.106614Z
updated: 2026-07-20T18:39:32.122280587Z
type: task
title: 'Incident timeline entries for alert lifecycle: triggered, recovered, re-triggered'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 161
order: 4.0
task_status: active
assignee: steve
label:
- feature
priority: medium
sprint: skj7tft
---
The incident timeline shows human/AI activity but nothing about what the underlying signal is doing — an alert can recover (source went green) or re-fire and the timeline says nothing. Add machine-generated timeline entries for the alert lifecycle, worded:

- `Alert triggered - <alert name>` — when the incident is opened by the alert (the initial entry)
- `Alert recovered - <alert name>` — the source went green on its own
- `Alert re-triggered - <alert name>` — the recovered alert fired again

## Mechanism

`audit.record()` against the **Issue** (`entity=issue`, `actor="sync"`), inside the sync transaction — the timeline endpoint (`api/v1/issues.py` `get_issue_timeline`) merges issue-scoped audit events automatically, no new table (ADR 0024 merge-on-read). Events recorded against the Finding would NOT surface — must be recorded against the incident.

## Implementation notes

- Signal status transitions are detected in `reconcile_findings` (`sync.py:116–128`: re-detected → `recurring`, no-longer-reported → `recovered`), which doesn't know about incidents. The finding→incident link is resolved via `correlation_key` in `promote_findings` (`promotion.py`), which already builds the `live` incident map — record the events there (or thread transitions through to it).
- "Alert triggered" belongs where the incident is created from the finding (`promote_findings` → `_new_issue`).
- **Related gap:** incident reactivation (`promotion.py:169`, resolved → `reactivated` on recurrence) writes no audit event today either — a reactivation appears on the timeline unexplained. Add it in the same change.
- Frontend: new action verbs render generically via `statusLabel(event.action)`; add cases to `describeAudit()` (`IssueTimeline.tsx:~565`) for the exact wording above. Formatting (timestamp/name style) is ISE-160.
- Per ADR 0025 semantics: alerts *recover* on their own; *resolved* only happens via the human cascade (already audited as the status change on the incident). A flapping monitor writes a recovered/re-triggered pair per flap — intended: the incident is where flap history accumulates.