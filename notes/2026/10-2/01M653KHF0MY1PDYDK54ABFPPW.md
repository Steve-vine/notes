---
id: 01M653KHF0MY1PDYDK54ABFPPW
created: 2026-10-30T00:33:24.448065Z
updated: 2026-10-30T08:16:06.928774Z
type: task
title: Staging's API was restarted when two people opened Frameworks at once — it was too busy to answer its health check, so Kubernetes took it for dead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1456
sprint: s5pn06h
comments:
- id: 01M658NBS47RRXHCR91DTNMQPZ
  author: Steve Vine
  at: 2026-10-30T02:01:47.044612Z
  text: |-
    Fixed: PR #1470, merged, and deploying with sprint 99.

    - Staging's API CPU limit goes from 0.5 to 2 CPUs.
    - Its liveness check now allows 10 s to answer (was 3 s), so a busy API isn't restarted. Readiness is unchanged.
    - Production isn't changed. Its preset runs 2 copies at 1 CPU each with the same 3 s check, so it's less exposed but could meet this under heavy load. Raising the default liveness timeout too is worth a separate decision.

    Note: the second restart on staging (00:49 GMT) was a separate cause, running out of memory at 1 GB. That's logged as COM-1457.

    Done when (two suite runs at once, no restart) gets checked after this deploy.
- id: 01M65998Y5ACTXE766ATH48T3B
  author: Steve Vine
  at: 2026-10-30T02:12:39.493286Z
  text: 'Verified on staging after the deploy (ca55ed7d, 02:05 GMT): two full browser-suite runs at the same time, both walking every screen for every account, Frameworks included. The API had 0 restarts before and after. Done when met.'
assignee: steve
label:
- bug
priority: high
task_status: done
---
Defect found by the browser suite (COM-1449), sprint 99, on staging 2026-10-30 00:08 GMT.

## What happens

Two browsers walking the menu at once both opened **Frameworks**. Each asks for every framework's coverage at the same moment. Staging's API is a single process limited to half a CPU. It stopped answering its liveness check (3 s timeout, 3 tries) and Kubernetes restarted it: about 30 seconds of "502" for everyone on staging.

## The fix

- Staging's API gets more CPU headroom (limit 2 CPUs instead of 0.5) in the staging values.
- Its liveness check waits longer before giving up (10 s), so a busy API is not mistaken for a dead one. Readiness still takes it out of rotation quickly.
- Production runs elsewhere, with its own sizes: check whether the same 0.5 CPU limit applies there, and say so in the PR.

**Chain:** independent (chart values only).

**Done when:** after the deploy, two browser suite runs at the same time leave the API with no new restart.