---
id: 01KY5158M01K8TKPQC02NAAVAA
created: 2026-07-22T13:45:04.896032Z
updated: 2026-07-22T14:53:48.946422Z
type: task
title: Proposals queue — unified confirm surface + tag-mapping candidate detector
project: 01KX671DATY39VW6GWK3M2T3DN
number: 213
sprint: s5khymf
blocked_by:
- 01KY514VRBX9E4E7V7Q7ZSWAND
assignee: steve
label:
- feature
priority: high
task_status: todo
---
The one place "ISE thinks it learned something — confirm?" lands (Canon: "The proposals queue"). Serves the Dictionary now; document claims and incident-learned edges plug in later in the sprint.

- **Model + migration**: proposal rows — kind (tag-mapping / edge / tag / alias), subject refs, payload, source provenance (integration/document/incident/detector), citation/evidence text, status `proposed|confirmed|rejected`, decided-by/at. **Rejection is remembered** — the same proposal never returns.
- **Confirm executes**: confirming a tag-mapping creates the dictionary mapping (audited, re-evaluates rules); confirming an edge creates the `entity_edge` row with `ai_proposed`→confirmed provenance. Unconfirmed proposals never join the graph.
- **Detector (deterministic first)**: case-fold equality, whitespace/punctuation variants, seeded synonym table over the live pool → tag-mapping candidates for values not already dictionary-listed (the `pr0d` escalation path). Runs post-sync, idempotent against remembered rejections. AI long-tail matching is a later enhancement, not this task.
- **UI (DoD)**: own nav entry ("Proposals"); list filterable by source/kind; one-click confirm/reject with the evidence rendered alongside; empty state.
- Tests: confirm-side-effects, rejection memory, detector idempotency.