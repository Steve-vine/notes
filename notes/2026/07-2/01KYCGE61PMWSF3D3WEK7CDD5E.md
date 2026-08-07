---
id: 01KYCGE61PMWSF3D3WEK7CDD5E
created: 2026-07-25T11:26:46.83868Z
updated: 2026-08-07T10:55:59.701591Z
type: task
title: Chat memory for long investigation sessions
project: 01KX671DATY39VW6GWK3M2T3DN
number: 288
sprint: svgrad3
blocked_by:
- 01KYCGCPSNMCW4H0B8SYCQGJ7A
- 01KYCGDPWC24GQRSW6N246QEDX
comments:
- id: 01KYD13FJ2MDKA68HGX3YABRMY
  author: Steve Vine
  at: 2026-07-25T16:18:01.922119Z
  text: |-
    Done — PR #263 (feature/ise-288-chat-memory → main), CI running.

    - _investigation_memory carries a compact, redaction-safe summary of what THIS conversation has gathered into the per-turn context preamble: evidence pulls the tools recorded (deduped by source+query, newest first, bounded to 15 + a count, failures marked) + the committed diagnosis root cause. Deterministic and FREE (no model call), built from already-stored, already-redaction-safe records — so ADR 0010's prose-only replay is untouched (not replaying transcripts, not raising ai_chat_history_turns). Empty until something is gathered.
    - The smart fix vs the blunt history-turns lever, exactly as the task framed it.
    - Gating: task gated on whether staging shows re-pulls/forgetting; the mechanism can only prevent re-pulls and its effect is measurable via ISE-283 breakdowns. Trivially tunable (MEMORY_MAX_PULLS) / removable.
    - Tests: test_investigation_memory.py (empty, lists pulls+diagnosis, dedup, failure marking, bounded+count). ruff+mypy(312 fresh) green.
assignee: steve
priority: low
task_status: done
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** From catalogue L7/L10 + the sprint discussion: once issue-chat is the investigation surface (Evidence + commit_diagnosis), the 12-turn prose-only history window pinches — the model forgets what it pulled a few turns ago and re-pulls, and its memory ends mid-investigation.

This is a design task, not a number raise: the prose-only replay is deliberate (ADR 0010 redaction — L7 stays). Explore carrying a per-conversation *findings summary* forward (what's been established/pulled so far, compact, redaction-safe) rather than replaying transcripts; `ai_chat_history_turns` is already admin-tunable (ISE-248) for the blunt lever.

Gate on real session data from batch 1 — do we actually see re-pulls and forgetting? (The instrumentation task's breakdowns help answer this.)