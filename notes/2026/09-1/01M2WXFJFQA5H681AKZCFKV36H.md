---
id: 01M2WXFJFQA5H681AKZCFKV36H
created: 2026-09-19T13:25:22.039868Z
updated: 2026-09-19T13:37:59.118039Z
type: task
title: A directory sync that is killed says "running" for ever — and the production size cannot finish a first crawl
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 729
sprint: stek6vx
comments:
- id: 01M2WY6NTE3TJFTMEPPJCDQFFM
  author: Steve Vine
  at: 2026-09-19T13:37:59.117928Z
  text: |-
    2026-09-19 ~14:50 BST: production worker limit raised to 2Gi (devops 12157b8); the first full crawl then completed, no restart. Highest `kubectl top` sample during it: worker 439Mi / 304m CPU; worker-execution 254Mi (idle).

    Reading: 439Mi is a sampled figure (metrics-server averages over ~15–30 s) on a worker with concurrency 2, so the true peak — crawl plus whatever the second slot was running (sign-in sweep, posture snapshot, a PDF) — evidently crossed 512Mi on seven earlier passes. The preset's 512Mi leaves no headroom over a measured 439Mi; a 1Gi limit for `sizes.production.worker` (request 384–512Mi) is the evidence-based default, and `evaluation` should be checked the same way against a small tenant. Separately: worker-execution idles at 254Mi against a 384Mi limit (two forked children each importing the whole app) — 66% before doing any work; worth raising to 512Mi or dropping its concurrency to 1 in the same change.
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found on production go-live day, 2026-09-19. The directory mirror "ran" for five hours. In fact the worker was OOM-killed on every pass — `Restart Count: 7`, `Last State: Terminated, Reason: OOMKilled, Exit Code 137`, each run lasting up to ~45 min — and nothing in the app said so.

Two defects:

1. **The `production` size preset gives the worker 512Mi, and a first full crawl of a real tenant does not fit.** Staging has the same limit but only ever runs delta passes now. Production worked around it in the devops repo (`worker.resources` limit 2Gi). Do: measure the first-crawl peak (staging with an emptied mirror, or production after the fix — `kubectl top`), then either raise the preset's worker limit or cut the crawl's peak (it holds whole collections in memory before reconciling; stream/batch per collection). State the figure in `chart/README.md`'s resources row.
2. **A killed pass is invisible.** `sync_directory` records a finish or a failure; a SIGKILL records neither, `sync_in_flight` treats the claim as live for 30 min, then Beat starts another pass that dies the same way. The Integrations card shows "running" throughout, with no error. Do: when a pass claims the singleton and finds a previous claim that never finished or failed, record that as a failure ("the previous sync stopped without finishing — the worker was probably restarted; check its memory") and count consecutive ones, so the card shows a failing sync rather than a perpetual one. Consider the same for the other long sweeps (sign-in, auth methods).

**Acceptance**: a worker killed mid-crawl produces a visible failed state on the directory sync card by the next tick; a fresh install at `size: production` completes its first crawl of this tenant without a restart.

Refs: COM-275 (the overlap window), COM-316 (delta vs full crawl).