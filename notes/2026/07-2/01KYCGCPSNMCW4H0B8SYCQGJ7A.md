---
id: 01KYCGCPSNMCW4H0B8SYCQGJ7A
created: 2026-07-25T11:25:58.453083Z
updated: 2026-07-25T11:39:33.794157Z
type: task
title: 'ADR: chat investigation boundary — Evidence in issue-chat (amends ADR 0023)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 280
sprint: svgrad3
assignee: steve
label:
- feature
- follow_up
priority: high
task_status: todo
---
**Sprint 24 tuning, batch 1. Pillar 1 (conversation-first investigation).** From the ISE-265 catalogue (L9, the motivating case) and the sprint discussion (2026-07-25).

Write the ADR (next free NNNN) amending ADR 0023: **the chat boundary is a WRITE boundary** — chat may not mutate ISE or the estate; read-only Evidence pulls are permitted. `fetch_evidence` is read-only by contract (ADR 0031 §3). The ADR also covers the `commit_diagnosis` chat write (implemented separately — an ISE-record write in the loop-driver pattern, not an estate mutation).

Then wire it: add `EVIDENCE_TOOLS` (`tools.py:411`) to `ISSUE_CHAT.tools`. Pulled content treated as untrusted exactly as diagnose does. Cost contained by the existing chat gates (ceiling + 0.5 daily share + $1/conversation + 60k/turn) — no new caps.

Assist is deliberately NOT included (batch 2, gated on issue-chat experience).

Acceptance: an operator can ask issue-chat to "check DataDog" and get a live, cited answer in the conversation. Record the decision in the ISE Canon memo (standing instruction).