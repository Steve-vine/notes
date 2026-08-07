---
id: 01KYCGCPSNMCW4H0B8SYCQGJ7A
created: 2026-07-25T11:25:58.453083Z
updated: 2026-08-07T10:55:52.422287Z
type: task
title: 'ADR: chat investigation boundary — Evidence in issue-chat (amends ADR 0023)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 280
sprint: svgrad3
comments:
- id: 01KYCJ0MFZN22Q41H107BPB9PQ
  author: Steve Vine
  at: 2026-07-25T11:54:20.0314Z
  text: |-
    Done — PR #253 (feature/ise-280-chat-evidence-boundary → main), CI running.

    - ADR 0049 written: the chat boundary is a WRITE boundary on estate + ungoverned ISE state, not a read boundary. Amends ADR 0023's framing (which stays in full force for assist).
    - Wired the on-demand Evidence tools into ISSUE_CHAT (list_evidence_sources → list_evidence_queries → pull_evidence). Chat holds no shared session, so chat-surface variants open one per call from session_factory. They sit OUTSIDE the ADR 0023 read-only transaction by design: revealing a credential writes a mandated credential_accessed audit row (ADR 0018) — the one write a read performs. No estate mutation, no approve/execute tool.
    - System prompt updated to point the agent at Evidence for "check DataDog"-type asks; pulled content treated as untrusted exactly as diagnose does. evidence_pulls surfaced on the chat run outcome like the single-shot engine.
    - Tests: new test_chat_evidence_tools.py; loop-tools boundary test now asserts Evidence present + still no approve/execute. Full ruff + mypy (305 files) green locally.

    Canon: the write-boundary decision was already recorded in the "AI interaction model: three pillars" memo entry (agreed 2026-07-25); ADR 0049 is its concrete artefact. Assist Evidence remains deferred to batch 2 (ISE-287).
- id: 01KYCQP496PXS2SRX1ES1K17BR
  author: Steve Vine
  at: 2026-07-25T13:33:27.206834Z
  text: |-
    Smoke-test fix (2026-07-25, review session): "check DataDog" killed the turn with `Unable to serialize unknown type: Point`. Root cause: the DataDog connector's `query_metrics` evidence returned the SDK's `pointlist` verbatim — a list of `Point` model objects, not the plain `[epoch_ms, value]` pairs its comment claimed — and pydantic-ai cannot serialize those into the tool return. Pre-existing since ISE-150 (the same payload rides the diagnose path); first reached interactively by chat Evidence.

    Fixed two layers on this branch (de1510f): unwrap `Point.value` in the connector, plus a `default=str` round-trip in `_pull_evidence` so any future connector leak degrades to a string instead of a dead turn. Connector test now uses real `Point` objects (the plain-list fake was why it slipped through); new chat-tools test pins the degrade behaviour. PR #253 CI green; re-merged to staging, deployed staging-20260725-1331.
assignee: steve
priority: high
task_status: done
---
**Sprint 24 tuning, batch 1. Pillar 1 (conversation-first investigation).** From the ISE-265 catalogue (L9, the motivating case) and the sprint discussion (2026-07-25).

Write the ADR (next free NNNN) amending ADR 0023: **the chat boundary is a WRITE boundary** — chat may not mutate ISE or the estate; read-only Evidence pulls are permitted. `fetch_evidence` is read-only by contract (ADR 0031 §3). The ADR also covers the `commit_diagnosis` chat write (implemented separately — an ISE-record write in the loop-driver pattern, not an estate mutation).

Then wire it: add `EVIDENCE_TOOLS` (`tools.py:411`) to `ISSUE_CHAT.tools`. Pulled content treated as untrusted exactly as diagnose does. Cost contained by the existing chat gates (ceiling + 0.5 daily share + $1/conversation + 60k/turn) — no new caps.

Assist is deliberately NOT included (batch 2, gated on issue-chat experience).

Acceptance: an operator can ask issue-chat to "check DataDog" and get a live, cited answer in the conversation. Record the decision in the ISE Canon memo (standing instruction).