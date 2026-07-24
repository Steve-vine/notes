---
id: 01KYAT448DP1991Z13VSBZTX5S
created: 2026-07-24T19:37:34.221307Z
updated: 2026-07-24T19:38:30.319661Z
type: task
title: Audit context assembly and token spend — why does analyse-issue need 200k+?
project: 01KX671DATY39VW6GWK3M2T3DN
number: 264
sprint: svgrad3
assignee: steve
priority: medium
task_status: backlog
---
Motivating case (2026-07-24): two analyse-issue runs burned 216,560 and 209,208 tokens — killed by the 200k run cap — to conclude an issue had **resolved itself**. That is the cheapest possible verdict at the most expensive possible price, and it coincided with the estate doubling (second cluster + Rollouts: 131 workloads / 171 services).

Working from the ISE-263 map, find where the tokens actually go and bound it:

- Instrument per-stage token contribution (investigation context size, tool-result sizes, iteration count) so a run's spend is decomposable — not just a total. Consider persisting this on the run for the run-detail screen.
- Check the obvious suspects: does investigation_context/traverse scale with estate size (blast radius over 300+ entities)? Are tool results (evidence slices) uncapped or oversized? Does the agent loop re-fetch what it already has?
- Cheap-verdict-first: "signal recovered, nothing firing" should be determinable deterministically or in one small model call before assembling a full investigation context — self-resolution is the *common* case and should be the cheapest, per the Canon's self-tiering principle.
- Output: fixes where clear (context bounding, result caps), and right-sized per-task caps grounded in real numbers rather than raising `ai_run_max_tokens` until the errors stop.

Depends on ISE-263 (the map).