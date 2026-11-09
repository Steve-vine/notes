---
id: 01M70WJRNTX9D2N153RP6NPHR3
created: 2026-11-09T19:29:23.130739Z
updated: 2026-11-09T19:29:27.627511Z
type: task
title: Sending reminders fails when an action's title is longer than 255 characters — a control review marked by an initiative carries the initiative's reason in its title
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1656
sprint: snyzymp
assignee: steve
label:
- bug
priority: high
task_status: todo
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