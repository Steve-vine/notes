---
id: 01KYCGCWNZ51471E3ZM80R6BTE
created: 2026-07-25T11:26:04.47956Z
updated: 2026-08-05T12:31:51.828463Z
type: task
title: Cheap-verdict-first for analyse-issue — deterministic self-resolution pre-check
project: 01KX671DATY39VW6GWK3M2T3DN
number: 281
sprint: svgrad3
comments:
- id: 01KYCKVF45WM6619T7HZHX0MF2
  author: Steve Vine
  at: 2026-07-25T12:26:27.845162Z
  text: |-
    Done — PR #257 (feature/ise-281-cheap-verdict-first → main), CI running.

    - run_issue_reanalysis now runs a deterministic pre-check before any model call. The originating Finding IS the signal (unique per system+source_key); if its resolved_at is set → appears_resolved with that evidence at ZERO model tokens, recorded as an ordinary analyse-issue run (provider 'deterministic', $0) so it stands on the timeline like any re-analysis and still drives auto-resolve where opted in.
    - Falls through to the full agentic run only when it can't decide cheaply: manual issue with no signal, or a signal still firing (still-present vs changed is a model judgement).
    - Applies to all three triggers (Re-analyse button, issue-chat trigger_analyse, post-execution verify) since all route through run_issue_reanalysis. Survives a spent budget — costs nothing. Timeline card captions it "· no model run".
    - ADR 0024 gets a dated note.
    - Tests: test_ai_analyse_issue.py (no-tokens deterministic path proven by not stubbing the model under ALLOW_MODEL_REQUESTS=False; still-firing + manual fall through) + timeline.test.ts. Backend ruff+mypy(304 fresh) + frontend build/lint/format/vitest green.
assignee: steve
priority: high
task_status: done
---
**Sprint 24 tuning, batch 1. Pillar 2 (cost proportional to difficulty).** ISE-264 audit rec 2; the Canon self-tiering principle. Fixes the motivating case (216k/209k-token runs killed by the cap to conclude "resolved itself") and journey gap A/C.

Before any model call, analyse-issue runs a deterministic pre-check: is the originating `Finding` resolved (`Finding.resolved_at`), and has the issue's signal stopped firing on the entity? If the condition's own signal is gone → return `appears_resolved` with that evidence, **no estate block, no tool loop, zero model tokens** (or one small-model call for wording only). Fall through to the full run only when inconclusive.

Applies to all three triggers — operator Re-analyse button, issue-chat `trigger_analyse`, and (most importantly) the automatic post-execution verify (`ai/verify.py`, ISE-100), which is the journey's least reliable step today.

Verdict + its deterministic evidence must be visible on the incident timeline like any reanalysis. May warrant an ADR note (self-resolution is deterministic before it is agentic).