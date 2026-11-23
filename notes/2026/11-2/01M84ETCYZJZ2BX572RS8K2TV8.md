---
id: 01M84ETCYZJZ2BX572RS8K2TV8
created: 2026-11-23T15:01:32.767959Z
updated: 2026-11-23T16:53:39.701348Z
type: task
title: Provide a register suggests live registers first — an archived one is never among the suggestions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2110
sprint: ssj8zkq
comments:
- id: 01M84KFR5XAE9A5VK737ERKWFC
  author: Steve Vine
  at: 2026-11-23T16:23:06.685575Z
  text: |-
    Fixed and merged to main: PR #2102 (5c258ff83). No migration or API change. Not on staging yet.

    What people see:
    - On a request, Provide a register suggests only live registers under "Kept for this request's controls".
    - An archived register can still be chosen: it's listed after every live register, under Archived, and can be provided as at a day.
    - A register the person can't open is still not offered, and providing it directly is refused.

    For Steve to confirm: archived registers stay available to provide, because an audit may need one as it stood during its period.

    Tested against real Postgres and in the screen's component tests: an archived register isn't suggested, is listed last under Archived, and can still be provided; a register the person can't open is refused. CI green.

    Not yet checked on staging: that comes with the re-test.
- id: 01M84N7P7NNCYWGZVZ96KCDVPJ
  author: Steve Vine
  at: 2026-11-23T16:53:39.701133Z
  text: |-
    Pre-UAT on staging f6abe2fd5: PASSED.

    Accounts: E2E Admin A and E2E Viewer, E2E Test Company. Audit AUD-6 "E2E UAT 122 Retest Audit" (AUD-5 is cancelled), requests kept for INS.5. Steps: open a request ▸ Provide a register ▸ open the Register list.

    - An archived register kept for the request's controls isn't in the suggestions: PASSED. As Admin A, "Kept for this request's controls" holds only E2E UAT 122 Obligations (UOB) and Legal, regulatory and contractual obligations (OBL). Archived registers kept for INS.5, such as E2E 121 Template obligations (ZOB) and E2E 121 Per-company main (ZMA), are no longer there.
    - It can still be found under Archived and provided as at a day: PASSED. The list runs Kept for this request's controls, Other registers, then Archived last, each marked "· Archived". I chose E2E UAT 122 Import (UIM) · Archived as at 23 Nov on RT-3. The request lists "E2E UAT 122 Import (UIM), as at 23 Nov 2026, 7 entries", and opening it shows the entries and values.
    - A register the person can't open is still not offered: PASSED. As E2E Viewer, on request RT-4 which it owns, the list leaves out both live Restricted registers (URS, and UPA while it was Restricted) and the archived E2E 121 Restricted Zebra (ZRS), which Admin A does see.

    Not tried: forcing a register the person can't open past the list by calling the server directly.

    Screenshots: ~/compass-uat/sprint-122/COM-2110/
assignee: steve
label:
- bug
priority: low
task_status: review
---
Sprint "Registers - Phase 2". Found in the pre-UAT pass of COM-2094 on staging e2248892e (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2094/02-suggested-registers-first.png`.

## The problem
On a request, Provide a register lists archived registers under "Kept for this request's controls", including one marked Restricted · Archived.

## What people see
- "Kept for this request's controls" holds only live registers.
- An archived register can still be chosen, because an audit may need one as it stood during its period. It's listed after every live register, under its own heading "Archived", and marked as archived.
- Nothing else about who can choose a register changes.

Assumption, for Steve to confirm: archived registers stay available to provide, because an archived register can still be opened and exported (ADR 0165).

## Done when
- An archived register kept for the request's controls isn't in the suggestions.
- It can still be found under Archived and provided as at a day.
- A register the person can't open is still not offered.

No migration expected.