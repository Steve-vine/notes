---
id: 01KY33QW3Z18PPDM2HZH5N5JX7
created: 2026-07-21T19:51:42.975184Z
updated: 2026-07-24T07:17:35.771484Z
type: task
title: Implicit acknowledgement — first substantive action acknowledges the incident
project: 01KX671DATY39VW6GWK3M2T3DN
number: 202
sprint: sohzsw2
assignee: steve
label: null
priority: medium
task_status: done
---
Drop the explicit Acknowledge button; an incident moves New → Active (`open`/`reactivated` → `acknowledged`) the moment a person starts working it. ADR 0038 (drafted at `docs/decisions/0038-implicit-acknowledgement.md`) has the full decision.

- Shared helper: if status is `open`/`reactivated`, set `acknowledged` + same audit record (actor = acting operator), called at the top of: conversation turn (commit at turn start — own session inside the SSE path), diagnose / propose-remediation / analyse, remediation approve/execute, learning entry, assignee change, merge-as-master.
- Signal tuning (downgrade / ignore / silence) does NOT auto-ack; children stay frozen (ADR 0035 §4).
- State machine and `PATCH /status` unchanged (`acknowledged` still accepted); UI removes the Acknowledge button + its `TRANSITIONS` entry. "Assign to me" is the explicit seen-and-mine gesture.
- On this task's branch: add the 0038 row to `docs/decisions/README.md` and mark ADR 0025 as amended by 0038 (the ADR file is already drafted in the working tree — commit it here, not with the Sprint 17 tag work).
- Tests: auto-ack from each trigger; no ack from tuning actions or on children; audit/timeline entry present.