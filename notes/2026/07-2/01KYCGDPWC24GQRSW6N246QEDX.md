---
id: 01KYCGDPWC24GQRSW6N246QEDX
created: 2026-07-25T11:26:31.308614Z
updated: 2026-08-05T12:02:49.460865Z
type: task
title: commit_diagnosis — issue-chat commits a structured diagnosis to the timeline
project: 01KX671DATY39VW6GWK3M2T3DN
number: 285
sprint: svgrad3
blocked_by:
- 01KYCGCPSNMCW4H0B8SYCQGJ7A
comments:
- id: 01KYCJEZKFDYN7T3DNRHYTAHXX
  author: Steve Vine
  at: 2026-07-25T12:02:10.159226Z
  text: |-
    Done — PR #254 (feature/ise-285-commit-diagnosis → main, stacked on #253/ISE-280), CI running.

    - New commit_diagnosis tool on issue-chat. Persists a Diagnosis (root cause, confidence, evidence, remediation options) as issue.evidence.diagnosis in the exact shape ai/diagnosis records, behind a task_type=diagnose AgentRun so it renders on the timeline identically to a one-shot diagnosis (no API change — _linked_run_ids picks it up).
    - Zero fresh spend: the run carries 0 tokens (the reasoning was billed on the issue-chat turn) with provider/model from that turn. Single-shot diagnose retained as decided.
    - Provenance: committed_from_conversation + conversation_run_id in the outcome; timeline card shows a subtle "· from conversation" caption. Re-committing replaces the diagnosis; superseded run stays in history.
    - Boundary (ADR 0049): a governed ISE-record write in the loop-driver pattern — opens its own session and commits, no estate mutation, no approve/execute tool. AgentDeps gained run_id/provider/model, set on the chat turn.
    - Tests: test_commit_diagnosis.py (write, clamp, replace, refusals, boundary). Backend ruff+mypy(307) green; frontend build+lint+format+vitest green.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 24 tuning, batch 1. Pillar 1.** From the sprint discussion (2026-07-25): the conversation IS the investigation — diagnose becomes what a good investigation session *produces*, not only a parallel batch run.

Add a `commit_diagnosis` tool to issue-chat: at any point the session can persist a structured Diagnosis (root cause, confidence, remediation options, citations from `deps.cited`/`evidence_pulls`) to the incident timeline — the same artefact shape the single-shot diagnose run records, with authorship/provenance showing it came from the conversation.

Boundary: an ISE-record write in the loop-driver pattern (like posting a message / enqueuing a run) — **no estate mutation**; covered by the chat-boundary ADR (write-boundary amendment), which must land first.

**Decision (2026-07-25): the single-shot diagnose run is retained** as the one-click "investigate this for me" convenience — this task adds the conversational route, it does not retire the batch one.

Acceptance: an operator investigating in issue-chat (with Evidence) can end the session with a cited diagnosis on the timeline, indistinguishable in standing from a batch-run diagnosis.