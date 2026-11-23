---
id: 01M82WTB0M7J9ZCQNFQVAFWVCM
created: 2026-11-23T00:27:41.972198Z
updated: 2026-11-23T00:27:46.515212Z
type: task
title: 'Register entry evidence: show each piece''s classification and status on the card'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2102
sprint: s64t54m
assignee: steve
label:
- bug
priority: medium
task_status: active
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