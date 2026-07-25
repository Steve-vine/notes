---
id: 01KYCGE0HBE66T6BB7EM28Y3VK
created: 2026-07-25T11:26:41.195421Z
updated: 2026-07-25T15:47:31.394043Z
type: task
title: Assist gains Evidence access (decide + wire, gated on issue-chat experience)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 287
sprint: svgrad3
blocked_by:
- 01KYCGCPSNMCW4H0B8SYCQGJ7A
assignee: steve
priority: low
task_status: todo
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** ISE-265 catalogue L9, second half.

Extend the read-only Evidence tools to **assist** (estate-wide chat). Same safety argument as issue-chat — the chat boundary is a write boundary, Evidence is read-only by contract — but a looser fit: assist is not scoped to an incident, so an Evidence hunt is less directed. Deliberately gated on real issue-chat-with-Evidence experience (spend + usefulness, via the Sprint 23 panels) before deciding.

If wired: same untrusted-content treatment, contained by assist's existing gates (0.5 share + $1 thread + 60k/turn). Covered by the chat-boundary ADR — at most a consequences note, no new ADR.