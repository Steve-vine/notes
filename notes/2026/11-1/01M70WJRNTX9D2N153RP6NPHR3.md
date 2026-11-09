---
id: 01M70WJRNTX9D2N153RP6NPHR3
created: 2026-11-09T19:29:23.130739Z
updated: 2026-11-09T21:01:06.694125Z
type: task
title: Sending reminders fails when an action's title is longer than 255 characters — a control review marked by an initiative carries the initiative's reason in its title
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1656
sprint: snyzymp
comments:
- id: 01M70X5C66N16KMJKGWPE92VN4
  author: Steve Vine
  at: 2026-11-09T19:39:32.934279Z
  text: |-
    PR #1663 is open with auto-merge set. Independent.

    - The title is clipped on the Notification model, so the fix covers every writer. No migration.
    - Regression test: an overdue treatment on a 300+ character risk title. It records clipped ledger rows and still sends the mail.
    - The test fails on main with the staging error (StringDataRightTruncation).
- id: 01M711TQ86Q8EZBF4XZ3RQQY8X
  author: Steve Vine
  at: 2026-11-09T21:01:06.693741Z
  text: |-
    **Verified on staging.** Build 58253384, deployed 2026-11-09 20:00 GMT.

    - Sending reminders at 21:00 **succeeded** in 38 s.
    - It caught up on everything since 4 Nov, writing 26,221 records for 12 people. Of those, 21 titles were over 255 characters and were saved clipped with "…"; none was longer than 255.
    - The mail catcher was off, so the catch-up digests went to the real addresses: three on moneypenny.co.uk and three on stevevine.uk. Mail is batched per person, so that's a few emails each, not one per record.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found 2026-11-09 from Steve's report: Admin ▸ Jobs shows **Sending reminders** failed. It fails every hourly run on staging. Also in v0.17.0.

## What people see

- Today: the run stops at the first long title, so that person and everyone after them in the run get no reminder emails at all.
- After: reminders go out. The record of what someone was told keeps the title shortened, ending "…"; the email and the Actions list still show it in full.

## Notes (technical)

- `core/mail_digest.py _record` writes `Notification(title=action.title)`; `notifications.title` is `String(255)`.
- COM-1557 appends "— Part of initiative INI-n · name (company)" to a control or content review's title (once per initiative), so a long control statement goes over 255. Staging: ACC.11/ACC.12 rows for INI-2 · Test Initiative.
- Fix: clip the title to the column on the Notification model (a `@validates("title")`), so every writer is covered. No migration.

**Chain:** independent.

**Done when:** a regression test with a 300-character action title records a clipped row and sends the mail; on staging the next Sending reminders run succeeds.