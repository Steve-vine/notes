---
id: 01M84YWN85MGT72GGWJGQKB78K
created: 2026-11-23T19:42:24.005502Z
updated: 2026-11-23T20:59:14.305701Z
type: task
title: Each provided register an auditor opens gets its own Viewed line in the audit's trail
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2126
sprint: ssj8zkq
comments:
- id: 01M85399QWWPZEEV6S0HJVACW1
  author: Steve Vine
  at: 2026-11-23T20:59:12.508486Z
  text: |-
    Fixed and merged to main: PR #2111 (c2e0b394f). No migration or API change.

    What people see:
    - Every provided register an auditor opens gets its own Viewed line, on its request's History and the audit's Activity, even when the same register is provided as at the same day on another request.
    - Reopening one in the same visit adds no line, and first open locks it once.
    - Each download is recorded against the right request.
    - Who can read a line's register name is unchanged.

    Cause: a Viewed line counted as a repeat if the same words were already logged in that visit, so two copies of one register read as one. Lines are now matched on the provided item. Ordinary evidence doesn't have this bug.

    Small known edge: an item reopened in a visit that spans the deploy could get one extra Viewed line. This affects staging only.

    Tested against real Postgres: two copies on different requests and on one request; reopening; downloads; who can read the name. A "later visit" is simulated. CI green.

    Not yet checked in a browser: the Auditor portal is off on staging again.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Sprint "Registers - Phase 2". Found in the auditor portal check of COM-2095 on staging d8a915977 (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2095/28-second-copy-view-not-logged.png`.

## The problem
The same register is provided as at the same day on two requests (AQ-2 and AQ-5). The auditor opens both in one visit. AQ-5's copy becomes "Seen by the auditor" and locks, but neither its History nor the audit's Activity has a Viewed line for it. The audit's record of what the auditor opened is incomplete.

## What people see
- Every provided item the auditor opens has its own Viewed line, on its request's History and the audit's Activity, even when the same register is provided on another request.
- Opening the same item again in the same visit doesn't add another line, as for evidence today.
- Downloads are recorded per item in the same way.
- Who can read a line's register name is unchanged (COM-2108).

## Done when
- Opening two provided copies of one register in one visit writes one Viewed line for each.
- Reopening one in that visit adds none.
- Downloading each copy is recorded against the right request.

No migration expected.