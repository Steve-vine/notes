---
id: 01M1TTVR6M7VWX8JMEV4GYEJ0K
created: 2026-09-06T07:45:24.692436Z
updated: 2026-09-06T07:45:27.527455Z
type: task
title: the carry-over fix missed the control's own page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 571
sprint: s2fcksg
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Follow-up to COM-564 (merged, b7d862f). Noticed 2026-09-06 while reading the same file for COM-570 — **not** reproduced on staging.

COM-564 fixed the assessment editor carrying one control's answers onto the next by keying the panel on the control, so moving between controls remounts it. That was done at **one** of the two places the panel renders:

- the assessments queue — fixed;
- **a control's own page** (`/controls/<ref>`) — not.

The control's page reads its ref from the URL and fetches, so going from one control to another changes the parameter without remounting the page. The editor keeps its instance, exactly as the queue's did, and the original fault is still there: move between two controls that have **never been assessed** and the second arrives holding the first one's answers, ready to be saved over it.

Reaching it takes a deliberate path — following a control link from a framework or requirement page, or the browser's back and forward — rather than the queue's Next button, which is why it did not show up in testing. The consequence if you do reach it is identical: a false judgement written into the governance record with nothing to warn you.

## What changes

- Key the panel on the control at that call site too, so both entry points behave the same way.
- Then look for a way to stop this recurring rather than fixing it a third time. The panel is rendered in two places today and either can be added to; if the panel keyed itself on the control it is given, no call site could get it wrong. That is the better shape, and it is a small change.
- Cover it with a test at the second entry point, since the one COM-564 added passes while this is broken.

## Related

- COM-564 — the fix this completes.
