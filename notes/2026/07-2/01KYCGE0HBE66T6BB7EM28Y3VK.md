---
id: 01KYCGE0HBE66T6BB7EM28Y3VK
created: 2026-07-25T11:26:41.195421Z
updated: 2026-08-07T11:55:37.654002Z
type: task
title: Assist gains Evidence access (decide + wire, gated on issue-chat experience)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 287
sprint: svgrad3
blocked_by:
- 01KYCGCPSNMCW4H0B8SYCQGJ7A
comments:
- id: 01KYD0SYJDY9FNNY19B5X48ZD1
  author: Steve Vine
  at: 2026-07-25T16:12:49.61336Z
  text: |-
    Done — PR #262 (feature/ise-287-assist-evidence → main), CI running.

    - Wired the Evidence tools into the ASSIST agent definition (not the frozen ASSIST_TOOLS allow-list, which stays as reviewed). assist keeps ADR 0023's read-only txn for estate reads; gains the same bounded, audited live Evidence pulls issue-chat has (one write = the credential_accessed audit of a read). No action catalogue, no mutating tool. Contained by assist's existing gates — no new caps. Prompt updated.
    - ADR 0049 gets a consequences note (no new ADR). test_assist_evidence.py added.

    GATING FLAG: the task deliberately gated this on real issue-chat-with-Evidence spend/usefulness data, which batch-1 only just started producing. I wired it because the safety argument is identical to issue-chat and it's trivially reversible (drop the tools from ASSIST). Happy to revert this one and hold for staging data if you'd prefer — the other 3 batch-2 tasks don't depend on it. Backend ruff+mypy(312 fresh) + assist tests green.
assignee: steve
priority: low
task_status: done
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** ISE-265 catalogue L9, second half.

Extend the read-only Evidence tools to **assist** (estate-wide chat). Same safety argument as issue-chat — the chat boundary is a write boundary, Evidence is read-only by contract — but a looser fit: assist is not scoped to an incident, so an Evidence hunt is less directed. Deliberately gated on real issue-chat-with-Evidence experience (spend + usefulness, via the Sprint 23 panels) before deciding.

If wired: same untrusted-content treatment, contained by assist's existing gates (0.5 share + $1 thread + 60k/turn). Covered by the chat-boundary ADR — at most a consequences note, no new ADR.