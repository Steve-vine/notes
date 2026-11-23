---
id: 01M847JCCSBD34P0CB1ETYGNYS
created: 2026-11-23T12:54:50.009581Z
updated: 2026-11-23T12:54:53.965952Z
type: task
title: Activity hides a Restricted register from people who can't open it — no name, prefix, entry ID or title in any activity line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2104
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: high
task_status: active
---
Sprint "Registers - Phase 2". Found while building COM-2091 (23 Nov 2026) and confirmed in the code. Registers haven't been released yet, so this should be fixed before they are.

## The problem
Activity hides restricted incidents and restricted privacy requests from people who can't read them, but has no such rule for registers. Anyone who can view Activity can see lines such as "created register entry SAL-1 · Director pay band", even if they can't open that Restricted register. A register's Restricted mark is meant to limit who sees what's in it (ADR 0165).

## What people see
- Someone who can't open a Restricted register sees an activity line about it, or about one of its entries, as "A Restricted register" or "A Restricted entry": who did it and when, with no register name, prefix, entry ID, title or changed values.
- Someone who can open the register sees the line as they do today.
- This holds wherever activity is read: the Activity page, a filtered or exported view, and anything Polaris reads from it.
- A register made Restricted after the line was written is hidden too, because the check is made when the line is read.
- A line about something else that mentions a Restricted register (for example a link to one of its entries, or an evidence or audit line) names no more than the same wording.

## Implementation notes (technical)
- `api/v1/activity.py` already does this for incidents, requests and disclosures (`unreadable_incidents`, `RESTRICTED_TITLE`). Follow that pattern, using `core/registers/access.py` for who can open a register.
- Check every reader of `ActivityLog`, not only that route.
- Check every place a register or entry writes an activity line, including summaries that embed its name.

## Done when
- A person who can't open a Restricted register sees no name, prefix, entry ID, title or value of it in any activity line.
- A person who can open it, and an administrator, see the line in full.
- A register restricted after the line was written is hidden from then on.
- Tests cover register lines, entry lines, link lines and each other reader of the log.

Independent unless the response shape changes (then on the chain). No migration expected.