---
id: 01M2WXFJFQA5H681AKZCFKV36H
created: 2026-09-19T13:25:22.039868Z
updated: 2026-09-24T20:29:40.380482Z
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
- id: 01M2X6RVM8JGG73CVS96PFWE94
  author: Steve Vine
  at: 2026-09-19T16:07:43.496229Z
  text: |-
    Merged to main 2026-09-19 as cc78f4b (PR #736). Unreleased.

    1. A killed pass is visible: the next pass to claim the singleton records a predecessor that never finished as the last failure ("it started … and stopped without finishing or reporting an error — the worker was probably killed… check the restart count and memory limit"). Cleared when a pass completes. No schema or API change; `sync_in_flight` shares `_unfinished()` and compares with `<=`. Limit of the design: the failure appears when the NEXT pass claims (up to the 30-min overlap window + one tick after the kill), not at the moment of the kill — nothing is alive to record it then. The other sweeps (sign-in, auth methods, posture) have no claim pattern, so nothing to fix there.
    2. Memory: production preset worker 512Mi→1Gi, execution 384→512Mi; evaluation 512→768Mi and 256→384Mi; staging 512Mi→1Gi; new `worker.maxMemoryPerChildMiB: 300` recycles a child that ends a task above that. I did not reduce the crawl's own peak (streaming per collection) — not needed at this tenant's size; revisit if a larger tenant appears.

    Follow-up after the next release is deployed: production's 2Gi override in the devops repo can drop to the preset. Also confirmed here: COM-725's acceptance — this PR's chart job skipped "Fetch kubeconform".
- id: 01M2ZWWDNRRSTTZFZMJ6CYTA13
  author: Steve Vine
  at: 2026-09-20T17:12:37.81608Z
  text: |-
    2026-09-20, production on 0.4.0 — the daily full re-read confirmed from the worker log (times UTC): 13:45 tick → `succeeded in 145.5s` (users 1548, groups 3277, memberships 70851, devices 2045, apps 380, SPs 1792, CA 29); every other pass 20–30 s; 24 of 24 ticks in 6h succeeded, no `stranded`, no restart. So a steady-state full crawl is ~2.5 min — the 45-minute runs on go-live day were the first crawl into an empty mirror being killed partway.

    The pool children stayed ForkPoolWorker-1/-2 before and after the full pass, i.e. `--max-memory-per-child` (300 MiB) did not trigger: the crawling child ended below 300 MiB resident. Consistent with yesterday's 439 MiB being parent + two children.

    Removal of production's 2Gi override is edited in `~/code/devops.application.compass`, NOT committed (rendered diff: worker limit 2Gi→1Gi, request 512→384Mi). Caveat recorded there: the heaviest pass — a first crawl into an empty mirror — has only ever been seen to succeed at 2Gi; it does not recur on this install, and the 1Gi default is what a new installer would meet.
- id: 01M2ZWZYTG3GCVA8T36XDM7TEP
  author: Steve Vine
  at: 2026-09-20T17:14:33.680091Z
  text: 'Decision, Steve 2026-09-20: production''s worker stays at request 512Mi / limit 2Gi — "just to future proof it". The staged removal was reverted; the devops repo is clean at 2bd5504. Do not propose dropping it again; the chart''s 1Gi default stands for other installs.'
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
Found on production go-live day, 2026-09-19. The directory mirror "ran" for five hours. In fact the worker was OOM-killed on every pass — `Restart Count: 7`, `Last State: Terminated, Reason: OOMKilled, Exit Code 137`, each run lasting up to ~45 min — and nothing in the app said so.

Two defects:

1. **The `production` size preset gives the worker 512Mi, and a first full crawl of a real tenant does not fit.** Staging has the same limit but only ever runs delta passes now. Production worked around it in the devops repo (`worker.resources` limit 2Gi). Do: measure the first-crawl peak (staging with an emptied mirror, or production after the fix — `kubectl top`), then either raise the preset's worker limit or cut the crawl's peak (it holds whole collections in memory before reconciling; stream/batch per collection). State the figure in `chart/README.md`'s resources row.
2. **A killed pass is invisible.** `sync_directory` records a finish or a failure; a SIGKILL records neither, `sync_in_flight` treats the claim as live for 30 min, then Beat starts another pass that dies the same way. The Integrations card shows "running" throughout, with no error. Do: when a pass claims the singleton and finds a previous claim that never finished or failed, record that as a failure ("the previous sync stopped without finishing — the worker was probably restarted; check its memory") and count consecutive ones, so the card shows a failing sync rather than a perpetual one. Consider the same for the other long sweeps (sign-in, auth methods).

**Acceptance**: a worker killed mid-crawl produces a visible failed state on the directory sync card by the next tick; a fresh install at `size: production` completes its first crawl of this tenant without a restart.

Refs: COM-275 (the overlap window), COM-316 (delta vs full crawl).