---
id: 01M653KHF0MY1PDYDK54ABFPPW
created: 2026-10-30T00:33:24.448065Z
updated: 2026-10-30T00:33:29.518044Z
type: task
title: Staging's API was restarted when two people opened Frameworks at once — it was too busy to answer its health check, so Kubernetes took it for dead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1456
sprint: s5pn06h
assignee: steve
label:
- bug
priority: high
task_status: todo
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