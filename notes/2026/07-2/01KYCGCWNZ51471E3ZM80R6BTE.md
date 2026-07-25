---
id: 01KYCGCWNZ51471E3ZM80R6BTE
created: 2026-07-25T11:26:04.47956Z
updated: 2026-07-25T11:40:08.703677Z
type: task
title: Cheap-verdict-first for analyse-issue — deterministic self-resolution pre-check
project: 01KX671DATY39VW6GWK3M2T3DN
number: 281
sprint: svgrad3
assignee: steve
priority: high
task_status: todo
---
**Sprint 24 tuning, batch 1. Pillar 2 (cost proportional to difficulty).** ISE-264 audit rec 2; the Canon self-tiering principle. Fixes the motivating case (216k/209k-token runs killed by the cap to conclude "resolved itself") and journey gap A/C.

Before any model call, analyse-issue runs a deterministic pre-check: is the originating `Finding` resolved (`Finding.resolved_at`), and has the issue's signal stopped firing on the entity? If the condition's own signal is gone → return `appears_resolved` with that evidence, **no estate block, no tool loop, zero model tokens** (or one small-model call for wording only). Fall through to the full run only when inconclusive.

Applies to all three triggers — operator Re-analyse button, issue-chat `trigger_analyse`, and (most importantly) the automatic post-execution verify (`ai/verify.py`, ISE-100), which is the journey's least reliable step today.

Verdict + its deterministic evidence must be visible on the incident timeline like any reanalysis. May warrant an ADR note (self-resolution is deterministic before it is agentic).