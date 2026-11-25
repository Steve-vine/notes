---
id: 01M89TVAHZZYN71N1GP4SMY91W
created: 2026-11-25T17:07:58.143007Z
updated: 2026-11-25T22:31:43.043495Z
type: task
title: Browser journey 5 raises its leaver as the Access Manager, so a self-approving Admin never runs it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2169
sprint: s4qjpqd
comments:
- id: 01M8A0JJXVMA73P8SA1AF76ASH
  author: Steve Vine
  at: 2026-11-25T18:48:03.259228Z
  text: |-
    Merged: PR #2174.
    - Journey 5 now raises as E2E Access Manager, and Admin B still rejects it.
    - It first checks the raiser can't approve their own requests, and fails if they can.

    Seen on staging:
    - On the first deploy (509e818ae), that check fired: E2E Access Manager held the permission because of migration 0922 (→ COM-2170). The journey stopped before raising anything, so nothing ran.
    - After COM-2170 (2016209cf), the Browser smoke passed 41/41, with journey 5 raising ACR-196 as the Access Manager and Admin B rejecting it.
assignee: steve
label:
- bug
priority: urgent
task_status: done
---
Sprint "Access Control Review". Fix-forward found before the staging deploy (from COM-2166).

## Why
Browser journey 5 has E2E Admin A raise a leaver for the real test person (Compass.Test@moneypenny.co.uk), and expects E2E Admin B to reject it. It blocks every approve, validate and expedite call from the browser. Since COM-2166, Admin holds **Approve their own requests**, so Admin A's leaver is approved and **runs as it is raised**. That is a POST the journey's guard doesn't block, and it would disable the real account. The staging deploy's Browser smoke runs the journeys whenever staging's mail goes to the mail catcher.

## What changes
- The journey raises as **E2E Access Manager**, who can't approve their own requests, and E2E Admin B still rejects it.
- Before raising anything, it checks the raiser doesn't hold Approve their own requests, and fails loudly if they do, so a later role change can't re-arm it.

## Done when
- The journey file raises as the Access Manager and has the guard. The Browser smoke on staging is green.
- **Independent** (test code only).