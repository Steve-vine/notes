---
id: 01M82WTB0M7J9ZCQNFQVAFWVCM
created: 2026-11-23T00:27:41.972198Z
updated: 2026-11-23T00:48:13.030719Z
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
assignee: steve
label:
- bug
priority: medium
task_status: review
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