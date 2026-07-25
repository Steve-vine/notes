---
id: 01KYCGE61PMWSF3D3WEK7CDD5E
created: 2026-07-25T11:26:46.83868Z
updated: 2026-07-25T11:27:19.76378Z
type: task
title: Chat memory for long investigation sessions
project: 01KX671DATY39VW6GWK3M2T3DN
number: 288
sprint: svgrad3
blocked_by:
- 01KYCGCPSNMCW4H0B8SYCQGJ7A
- 01KYCGDPWC24GQRSW6N246QEDX
assignee: steve
label:
- improvement
- follow_up
priority: low
task_status: backlog
---
**Sprint 24 tuning, batch 2 — start after batch 1 completes.** From catalogue L7/L10 + the sprint discussion: once issue-chat is the investigation surface (Evidence + commit_diagnosis), the 12-turn prose-only history window pinches — the model forgets what it pulled a few turns ago and re-pulls, and its memory ends mid-investigation.

This is a design task, not a number raise: the prose-only replay is deliberate (ADR 0010 redaction — L7 stays). Explore carrying a per-conversation *findings summary* forward (what's been established/pulled so far, compact, redaction-safe) rather than replaying transcripts; `ai_chat_history_turns` is already admin-tunable (ISE-248) for the blunt lever.

Gate on real session data from batch 1 — do we actually see re-pulls and forgetting? (The instrumentation task's breakdowns help answer this.)