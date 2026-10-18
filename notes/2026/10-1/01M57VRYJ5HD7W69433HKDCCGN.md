---
id: 01M57VRYJ5HD7W69433HKDCCGN
created: 2026-10-18T15:58:34.565397Z
updated: 2026-10-18T15:59:44.256544Z
type: task
title: People are emailed when something opens for them to sign, reminded before the deadline, and told when they're overdue — one email listing everything, with a link to the portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1097
sprint: s7s7mn9
blocked_by:
- 01M57VR859FTKHNPFBF5TXVK5X
- 01M57VRJR2RH8JA8G9GJGDKSF5
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 78, Attestations (ADR in COM-1092; Steve's decision: only the person is chased). Builds on the portal section (COM-1095) and portal sign-in (COM-1096), because the email links there.

## What people get

- **"You have documents to read and sign"**: sent the day something opens for them (a new cycle, or they just joined a role). It lists every document newly asked of them that day, with each one's due date, and a **Review and sign** button to Portal ▸ Attestations. It sends one email a day at most, however many roles opened.
- **A reminder 7 days before** and **1 day before** a due date, listing everything still unsigned that's due soon.
- **"Overdue"** the day after a due date, then **weekly** until signed. It lists everything overdue.
- When everything is signed, nothing more is sent.

The emails name the documents and dates and nothing else. They don't say which roles or who else is outstanding.

## Rules

- Only the person is emailed. Managers and role owners see the overdue list in the module (COM-1099).
- Someone with no email address in the directory isn't emailed. The Open view flags them.
- An item that disappears (they left the role, or signed) is never in a later email.
- In the person's **Actions**, each unsigned document shows as an action, so it's in the actions view as well as the inbox.

## Notes (technical)

- Declare an action source and let mail derive from it (ADR 0055, memory "Actions queue and derived mail"). Don't write a separate notify().
- If the derived digest can't send on a person's exact day, use a declared send-now notification, as COM-1077 did for incident reports.
- Times are UK local. Beat crontabs are wall-clock.
- Test that one email is sent when three roles open the same day, and that the reminder and overdue days are right around month ends.

**Done when:** a role-holder gets one email when something opens, reminders at 7 and 1 days, then overdue emails until they sign, and nothing after.