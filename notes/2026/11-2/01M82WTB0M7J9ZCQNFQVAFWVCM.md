---
id: 01M82WTB0M7J9ZCQNFQVAFWVCM
created: 2026-11-23T00:27:41.972198Z
updated: 2026-11-23T19:36:19.460124Z
type: task
title: 'Register entry evidence: show each piece''s classification and status on the card'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2102
sprint: s64t54m
comments:
- id: 01M82XZT9H2M5G7XWASCHGWKRT
  author: Steve Vine
  at: 2026-11-23T00:48:10.033085Z
  text: |-
    Fixed and merged to main (PR #2086, 29d0849fc).

    What changed for people
    - Each file and web address on a register entry's Evidence card shows its classification and its status (Current, Due soon or Out of date), in the same words as the evidence register.
    - The evidence cards on other records (risks, vulnerabilities) don't change.

    My call (for Steve to overturn)
    - If the evidence register doesn't list a piece for the person reading, because another area's rules hide it from them, the card shows its classification and no status rather than guessing one.

    Checked by automated tests so far, for a file and a web address read by someone who can only see registers. I'll re-test it in the browser once it's on staging.
- id: 01M82ZX0BFCDP1FDA91FSMK713
  author: Steve Vine
  at: 2026-11-23T01:21:35.087223Z
  text: |-
    Re-test on staging 29d0849fc: Partly. The fix works; one bullet couldn't be checked.

    - A file and a web address on an entry each show their classification and status on the card: Passed. As E2E Admin A and E2E Viewer, on ZMA-1: file EVD-100 and web address EVD-103 (added for this test) each show a Current pill and Internal. The evidence card on risk RSK-125 hasn't gained them. COM-2102/retest-01-admin-zma1-file.png, retest-02-admin-file-and-link.png, retest-08-viewer-evidence-card.png, retest-04-risk-card-unchanged.png
    - A restricted piece stays hidden from anyone who couldn't otherwise see it: Couldn't check in the browser. Compass hides a piece by where it came from (a restricted incident, a data subject request or a signed contract), and Add evidence can't create one. I didn't link an existing one, as that would change evidence this test didn't create. To check: link a file from a restricted incident to an entry and confirm E2E Viewer doesn't see it on the card.

    For Steve to decide: a file classified Restricted is open to anyone who can see the register. E2E Viewer saw EVD-104's name and its Restricted label on ZMA-1 and downloaded it, though the same Viewer is refused the Evidence register. I checked the code and ADR 0122 §2: what hides a piece is where it came from, and classification plays no part. So this is how evidence works across Compass, not a fault in this fix, and I haven't changed it. COM-2102/retest-03-admin-with-restricted.png, retest-05-viewer-card.png, retest-06-viewer-no-evidence-register.png

    Left on staging: EVD-103 on ZMA-1, and EVD-104 (taken off ZMA-1, still in E2E Test Company's evidence register).

    Screenshots are under ~/compass-uat/s64t54m/.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in the pre-UAT pass of sprint "Registers" on staging f73af7daf. Fix-forward for COM-2080.

## What's wrong
COM-2080 says each piece on an entry shows its EVD ID, name, type, classification and status. The entry's Evidence card shows the EVD ID, name, type, dates and who added it. Classification and status appear only on the piece's own page.

Screenshot: `~/compass-uat/s64t54m/COM-2080/evidence-card-two-pieces.png`.

## What people see
- Each piece on an entry's Evidence card shows its classification and its status, in the same words as the evidence register.
- Nothing changes on the evidence cards of other records.

## Done when
- A file and a web address on an entry each show their classification and status on the card.
- A restricted piece stays hidden from anyone who couldn't otherwise see it.