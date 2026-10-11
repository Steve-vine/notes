---
id: 01M4NJJRZ0FJBYMYPM8788VFYD
created: 2026-10-11T13:31:35.264879Z
updated: 2026-10-11T14:07:15.599767Z
type: task
title: The "Working towards" choice is hard to find on the HITRUST page — it sits below the nineteen-row domain table, where on CIS it is near the top
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 912
sprint: s4gilxe
comments:
- id: 01M4NMM1W2R2TVJDGG292M2SGP
  author: Steve Vine
  at: 2026-10-11T14:07:14.306564Z
  text: |-
    Merged to main as PR #914 (2026-10-11). Goes to staging with COM-913 to COM-915.

    What is there
    - On every framework that has levels, the "Working towards" choice now comes directly under the headline cards on the Coverage tab, above "Readiness by domain".
    - The "Looking at e1" notice moved with it.
    - Nothing else about the choice changed: who can set it, the default, the audit trail.

    Not confirmed
    - I moved it on my reading of the page's layout: on HITRUST it sat under the nineteen-row domain table. I have not seen the screen. If the choice was missing for a different reason, it will still be missing after this, and I need to know.
    - Someone who cannot write the scope statement sees the level as a badge with no picker, on CIS and HITRUST alike. That is unchanged.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Raised by Steve on 2026-10-11 while smoke-testing sprint 68 on staging: "There's no way to set 'working towards' for HITRUST like there is for CIS." Logged only; not to be actioned until Steve says.

## What Steve saw

- On the CIS page the "Working towards" choice (IG1, IG2, IG3) is easy to find.
- On the HITRUST page he could not find a way to set it.

## Likely cause (read from the code and staging data, not seen on screen)

- **The choice is on the HITRUST page, but a long way down.** On the Coverage tab it comes after "Readiness by domain", which for HITRUST is a nineteen-row table. CIS has no domains, so the same choice sits directly under the headline cards.
- **Nothing in the data hides it.** On staging HITRUST is active, not superseded, and has its three levels, the same conditions CIS meets.
- **Not confirmed.** Nobody has checked this against the screen. If Steve scrolled past the domain table and the choice still was not there, the cause is something else and this task needs a fresh look first.

## What people should see

- **The "Working towards" choice is in the same place on every framework that has levels,** above anything long: before "Readiness by domain", directly under the headline cards.
- **The "Looking at e1" notice stays with it,** since it is about the same thing.
- Nothing else about the choice changes: who can set it, the default, the audit trail.

## Notes (technical)

- `FrameworkDetailPage.tsx`, `CoveragePanel`: the `byDomain` block ("Readiness by domain") is rendered before the `looking` notice and the "Working towards" card. Move both cards above it.
- Check first, on staging, as a user who can write the scope statement: a reader without that permission sees the level as a badge with no picker, on CIS and HITRUST alike.
- Page test: on a framework with many parts, the "Working towards" control comes before the domain table in the document.

**Done when:** on staging the HITRUST page shows "Working towards" above "Readiness by domain", and choosing i1 there changes HITRUST's figures.