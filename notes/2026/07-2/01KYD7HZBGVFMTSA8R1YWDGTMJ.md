---
id: 01KYD7HZBGVFMTSA8R1YWDGTMJ
created: 2026-07-25T18:10:48.30405Z
updated: 2026-08-05T12:03:09.519182Z
type: task
title: Measured-numbers tuning pass — caps and shares from real breakdowns
project: 01KX671DATY39VW6GWK3M2T3DN
number: 297
sprint: svgrad3
blocked_by:
- 01KYD59GBJHNSQGZZK7NETEYBH
- 01KYD5A2FFFNF16H6V5D248CVF
comments:
- id: 01KYD98J4GG4BC1R3Z8JBA7R2Q
  author: Steve Vine
  at: 2026-07-25T18:40:37.008807Z
  text: |-
    Done (interim) — PR #267 (feature/ise-297-measured-tuning-pass → main, stacked on #266/ISE-296).

    Honest note first: this task is explicitly gated on "a few days of meaningful volume" and staging has only ~2 days / thin volume (11 issue-chat, 4-6 analyse-issue, 2 diagnose). I did NOT invent measured numbers from thin data — that's what the task forbids. So this is an interim pass: validate the fixes, walk back the crisis overrides, keep the shape-based caps, and document the re-run trigger.

    - MEASURED (fresh = total − cache_read): issue-chat avg 18k/max 34k (cap 60k); analyse-issue avg 37k/max 97k* (cap 60k; *97k is a pre-282 force-fed-block run, not representative); diagnose avg 55k/max 109k (cap 200k). The 389k-total/280k-cache killed diagnose was 109k FRESH — under 200k → ISE-294 validated end to end, it would now complete.
    - DECISIONS: keep per-task caps (ISE-286) + chat shares/caps unchanged (no measured case from n=2-11 justifies a change). Walked back the crisis spend_policy overrides on staging to honest defaults: run 300k→200k, chat 200k→60k (ISE-294), ceiling $11→$10 (this pass), reserve unchanged. No settings.py change. L12 noted as more affordable but deliberately still off.
    - Documented in ai-token-spend-audit.md (measured table + re-run trigger: dozens of runs/task-type on post-282/294 code).

    When staging accrues real volume, re-run to set caps a healthy run never touches and a runaway always does.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 24 closing task — deliberately gated on a few days of staging usage.** Several sprint items explicitly promised this pass once real data existed; do not start until the Spend panels and run breakdowns have meaningful volume.

- **Re-size the per-task run caps (ISE-286) from measured ISE-283/295 breakdowns** — they are currently sized from task *shape*. On the fresh-token metric (ISE-294), set values that a healthy run never touches and a runaway always does.
- **Confirm or correct the ISE-264 audit's structural estimates** — its stated "first job once instrumentation exists": estate-context size, per-tool-result sizes, iteration counts vs the audit's ~10–40k / ≤10k / ×12 model.
- **Review chat caps and spend shares against post-Evidence reality** (catalogue L10/L11): per-turn cap, history window, 0.5 shares, $1 conversation caps — against the Sprint 23 By-Task / By-Incident panels now that chat pulls Evidence and runs retrieval searches.
- **Walk the admin overrides down** (spend_policy: run 300k, chat 200k, ceiling $11 — set 2026-07-24 during the crisis) to honest defaults; ISE-294 carries the run-cap part, this closes the rest.
- Output: tuned defaults in settings.py + any spend_policy resets, each number citing the measurement that justifies it. Also the moment to decide whether L12 (Evidence on analyse-issue's inconclusive path) is now affordable — a note, not necessarily a build.

Blocked by ISE-294 + ISE-295 (the metric and the killed-run visibility both change what gets measured).