---
id: 01KYCGD93A325Q2VJB9P3EWMAH
created: 2026-07-25T11:26:17.194395Z
updated: 2026-08-05T11:55:36.699154Z
type: task
title: Per-stage token instrumentation + run-detail spend breakdown
project: 01KX671DATY39VW6GWK3M2T3DN
number: 283
sprint: svgrad3
blocked_by:
- 01KYCGD343RQ8WCTXBJP7DMZW5
comments:
- id: 01KYCKCQA87B1C0W2KYSEWKF9D
  author: Steve Vine
  at: 2026-07-25T12:18:24.712348Z
  text: |-
    Done — PR #256 (feature/ise-283-token-breakdown → main, stacked on #255/ISE-282), CI running.

    - token_breakdown JSONB on AgentRun (migration 0053, additive), computed in record_usage from the redacted transcript — so single-shot AND chat runs get it: system-prompt/schema overhead, input prompt, per-tool returned results (by tool — where the pulled estate context now lands), model output, iteration count.
    - Char-based estimates (~4 chars/token) for proportion; billed totals stay on input/output_tokens. The panel is explicit it's an estimate and that a multi-iteration run re-feeds history (billed input > content shown).
    - Run-detail screen: new Spend breakdown panel (sorted bars, per-tool call counts, iterations). API types regenerated.
    - Fixed the stale AI_TASK_DESCRIPTIONS[analyse-issue] trigger text → button / issue-chat / post-execution verify (not a timer).
    - Tests: test_instrumentation.py + tokenBreakdown.test.ts; migration models-match green. Backend ruff+mypy(308, fresh --no-incremental) + frontend build/lint/format/vitest green.

    Note: an incremental mypy-cache flake (test_sync.py "no attribute sync") is spurious — fresh mypy (as CI runs) is clean; verified with --no-incremental.

    First job once live (its stated purpose): confirm/correct the audit's structural estimates and feed the measured numbers to the per-task-caps task (ISE-286, batch 2).
assignee: steve
priority: medium
task_status: done
---
**Sprint 24 tuning, batch 1. Pillar 2 — and the sprint's user-facing screen.** ISE-264 audit rec 4; journey gap D ("you can see what an incident cost, but not why").

- Record a `token_breakdown` on `AgentRun` (JSONB; migration): estate-context size, per-tool-result sizes (by tool), iteration count, system-prompt/schema overhead, output size.
- Surface it on the run-detail screen as a spend breakdown — an operator can see *where* a big run's tokens went and judge whether the cost was warranted.
- First job once live: confirm or correct the audit's structural estimates (its stated purpose), and provide the measured numbers the per-task-caps task (batch 2) needs.
- Rides along: fix the stale L15 trigger description — `AI_TASK_DESCRIPTIONS["analyse-issue"]` claims a detection-schedule trigger that doesn't exist (`models.py:124`); correct to the real triggers (button / issue-chat / post-execution verify).

Sequence after the push→pull task ideally, so the breakdown measures the new context shape.