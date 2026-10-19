---
id: 01M57R9A890C4HPA6XZX7R8WNT
created: 2026-10-18T14:57:36.521476Z
updated: 2026-10-19T18:09:32.077957Z
type: task
title: Tasks that change neither the database nor the API are built and merged alongside a sprint's stack, instead of waiting in line behind it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1091
sprint: sjlj05e
comments:
- id: 01M59M343Y7T8GPGJ1A08CNNW0
  author: Steve Vine
  at: 2026-10-19T08:22:48.189987Z
  text: |-
    Merged in PR #1096 (2026-10-19).
    - brief/ways-of-working.md has a new section, "On the chain, or independent": a **Chain:** line in every task at planning, independent tasks merge whenever green, and an "independent" task that needs a migration or API change joins the end of the chain.
    - The CLAUDE.md loop line points to it.
    - scripts/dev/chain-check.sh [--drift]: exit 0 independent, 1 on the chain, 2 can't tell. Checked against COM-1102's commit (migration 0305 + schema), which it flags as on the chain.

    No ADR 0041 amendment: it already lets independent briefs merge in any order.

    Still open from "done when": plan the next module sprint with every task marked.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Sprint 77, CI / Build optimisation. Raised 2026-10-18. Start after sprint 76 is on staging.

## Why

A sprint's tasks queue end to end because nearly every one does one or both of these:
- adds a database migration, and migrations form one chain;
- changes the API, which regenerates the shared frontend types file (`schema.d.ts`).

Two PRs that both do either can't be in flight at once (memory: stacked PRs and migration chains). So every task waits for the one before it to pass CI and merge, even when it never touches the chain, such as a screen-only change, a copy fix, a report layout or a test.

## What changes

- **When a sprint is planned**, each task is marked **on the chain** (adds a migration or changes the API) or **independent** (neither). The mark is a line in the task body, and it shows in the sprint plan.
- **Independent tasks** branch from main, build alongside the stack, and merge as soon as they're green, in any order. The push-to-main backstop already catches the two ways independent PRs can collide: two migration heads, and API type drift.
- **If an "independent" task turns out to need a migration or an API change**, it joins the end of the chain, and the task says so.
- This becomes part of how sprints are run. Write it into `brief/ways-of-working.md` and the per-task loop in `CLAUDE.md`. If it amends how ADR 0041 describes stacking, add an amendment there; it doesn't change what gates a merge.

## Notes (technical)

- A small script, `scripts/dev/chain-check.sh`, says whether a branch touches `app/backend/migrations/`, the API contract (run the drift script), or neither. Use it before deciding a task can merge out of order.
- Capacity: independent work still costs CI runs. Keep to the existing limit of about 4 PR runs in flight on g5 (memory: g5 uplink saturation; g5 local work competes with CI).

**Done when:** the planning mark and the out-of-order rule are written down in the ways-of-working brief and CLAUDE.md, the chain-check script exists, and the next module sprint is planned with each task marked.