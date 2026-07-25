---
id: 01KYCGDPWC24GQRSW6N246QEDX
created: 2026-07-25T11:26:31.308614Z
updated: 2026-07-25T11:39:59.871326Z
type: task
title: commit_diagnosis — issue-chat commits a structured diagnosis to the timeline
project: 01KX671DATY39VW6GWK3M2T3DN
number: 285
sprint: svgrad3
blocked_by:
- 01KYCGCPSNMCW4H0B8SYCQGJ7A
assignee: steve
priority: medium
task_status: todo
---
**Sprint 24 tuning, batch 1. Pillar 1.** From the sprint discussion (2026-07-25): the conversation IS the investigation — diagnose becomes what a good investigation session *produces*, not only a parallel batch run.

Add a `commit_diagnosis` tool to issue-chat: at any point the session can persist a structured Diagnosis (root cause, confidence, remediation options, citations from `deps.cited`/`evidence_pulls`) to the incident timeline — the same artefact shape the single-shot diagnose run records, with authorship/provenance showing it came from the conversation.

Boundary: an ISE-record write in the loop-driver pattern (like posting a message / enqueuing a run) — **no estate mutation**; covered by the chat-boundary ADR (write-boundary amendment), which must land first.

**Decision (2026-07-25): the single-shot diagnose run is retained** as the one-click "investigate this for me" convenience — this task adds the conversational route, it does not retire the batch one.

Acceptance: an operator investigating in issue-chat (with Evidence) can end the session with a cited diagnosis on the timeline, indistinguishable in standing from a batch-run diagnosis.