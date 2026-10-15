---
id: 01M4ZTCDSDVEKA7008FVTG6TYY
created: 2026-10-15T13:00:20.141365Z
updated: 2026-10-15T13:00:25.954252Z
type: task
title: The assistant can read and work Gaps — raise one against a control, update its owner, target date and status, close it, and comment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 980
sprint: sadf3j6
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975, and uses COM-977's control lookup. Posture batch.

## What people can ask of it

- **Read, for a named company:**
  - the open gaps, filtered as on screen (owner, status, target date, overdue, domain, control);
  - a gap in full, with who raised it, when it closed, its comments and the risks it is linked to.
- **Write (whatever the person's role allows on the Gaps screen):**
  - raise a gap against a control;
  - change its description, owner, target date and status, including closing it;
  - add, edit and delete comments.
- A gap can't be deleted on screen today, so the assistant can't delete one either.
- **Example:** "What gaps for Acme are overdue, and who owns them?" Then: "push the backup-testing gap to the end of next month and add a comment saying why."

## Notes (technical)

- These wrap `gaps.py`. Linking a gap to a risk is done from the risk side (COM-981), as on screen.
- Owners are resolved as in COM-979. Dates are accepted as ISO dates, and the description says so.
- A comment edit or delete is allowed only on the person's own comment, as the route enforces. Annotate comment delete as destructive.

**Done when:** on staging, the assistant raises a gap and comments on it, and both show on the Gaps screen as via assistant.