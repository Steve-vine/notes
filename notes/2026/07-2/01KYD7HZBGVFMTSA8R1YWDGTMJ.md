---
id: 01KYD7HZBGVFMTSA8R1YWDGTMJ
created: 2026-07-25T18:10:48.30405Z
updated: 2026-07-25T18:26:05.084869Z
type: task
title: Measured-numbers tuning pass — caps and shares from real breakdowns
project: 01KX671DATY39VW6GWK3M2T3DN
number: 297
sprint: svgrad3
blocked_by:
- 01KYD59GBJHNSQGZZK7NETEYBH
- 01KYD5A2FFFNF16H6V5D248CVF
assignee: steve
label:
- improvement
- follow_up
priority: medium
task_status: todo
---
**Sprint 24 closing task — deliberately gated on a few days of staging usage.** Several sprint items explicitly promised this pass once real data existed; do not start until the Spend panels and run breakdowns have meaningful volume.

- **Re-size the per-task run caps (ISE-286) from measured ISE-283/295 breakdowns** — they are currently sized from task *shape*. On the fresh-token metric (ISE-294), set values that a healthy run never touches and a runaway always does.
- **Confirm or correct the ISE-264 audit's structural estimates** — its stated "first job once instrumentation exists": estate-context size, per-tool-result sizes, iteration counts vs the audit's ~10–40k / ≤10k / ×12 model.
- **Review chat caps and spend shares against post-Evidence reality** (catalogue L10/L11): per-turn cap, history window, 0.5 shares, $1 conversation caps — against the Sprint 23 By-Task / By-Incident panels now that chat pulls Evidence and runs retrieval searches.
- **Walk the admin overrides down** (spend_policy: run 300k, chat 200k, ceiling $11 — set 2026-07-24 during the crisis) to honest defaults; ISE-294 carries the run-cap part, this closes the rest.
- Output: tuned defaults in settings.py + any spend_policy resets, each number citing the measurement that justifies it. Also the moment to decide whether L12 (Evidence on analyse-issue's inconclusive path) is now affordable — a note, not necessarily a build.

Blocked by ISE-294 + ISE-295 (the metric and the killed-run visibility both change what gets measured).