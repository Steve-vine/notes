---
id: 01KXX7H0RX5T3F7GGKV5B12PYN
created: 2026-07-19T13:02:26.077125667Z
updated: 2026-07-19T13:23:32.881437929Z
type: task
title: Playbooks — library screen + match in Recall
priority: high
assignee: steve
label:
- feature
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 135
tech: null
sprint: sdv8hgy
blocked_by:
- 01KXX7GWGYRFEK4HZ9FDGHVVHA
---
**Sprint 13 (vertical slice: backend + UI).** Distil recurring resolutions into reusable playbooks.

- **Backend**: `playbook` model (six-part: applicability signature, ranked hypotheses, investigation plan as intents, remediation options each referencing an existing `ActionSpec`, validation criteria, efficacy/provenance), versioned in Postgres; match by applicability signature. **Judgment, not privilege** — references only the existing action catalogue.
- **UI**: a new **Playbooks** nav screen (list with efficacy + provenance), and the Recall panel now surfaces the matched playbook on an incident ("Playbook: checkout OOM → scale, 4/5 success").

**DoD**: an operator can browse the Playbooks screen and, on a matching incident, sees the recommended playbook in Recall. Not done until both the screen and the in-Recall match render.

Depends on Recall.