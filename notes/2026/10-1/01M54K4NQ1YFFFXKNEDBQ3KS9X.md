---
id: 01M54K4NQ1YFFFXKNEDBQ3KS9X
created: 2026-10-17T09:29:58.241257Z
updated: 2026-10-17T09:30:02.030427Z
type: task
title: Marking an SAP entry done records how it went — an outcome, a completion date and evidence (or why there's none) — and freezes it; a skipped one is cancelled with a reason
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1045
sprint: sxflvhs
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 75, SAP - Schedule (ADR in COM-1041). Built on COM-1044, because done needs evidence.

## What people see

- **Mark done** on an entry, for `sap.manage_plan` and the entry's owner. It asks for:
  - **Completed on** (defaults to today; can't be in the future);
  - **Outcome:** a short note on how it went, such as "14 findings, 2 high, raised as gaps";
  - **Evidence:** at least one file, uploaded there or already on the entry. **Or** tick **No evidence** and say why.
- **Once done the entry is frozen.** Title, description, type, owner, dates and links can't change, and it can't be deleted (Steve, B). These stay possible:
  - comments;
  - adding evidence (never removing);
  - **Correct outcome** for `sap.manage_plan`, which changes the outcome note or completion date with a reason. The entry's history shows the correction, the before and after, and who made it.
- **Cancel** (for `sap.manage_plan`), for an entry that won't happen. It asks for a **reason**, such as "Q3 review merged into Q4 after the restructure". A cancelled entry is kept, shows the reason, can't be deleted, and can't be un-cancelled. To do it after all, add a new entry.
- **On the entry:** "Done on 12 March 2027 by Jo Smith". If it was finished after its end date, it also shows "finished 9 days late".
- **On the list:** done entries can be filtered out (hidden by default after 90 days), and cancelled entries show their reason on hover.

## Rules

- Done and Cancelled are final. There's no going back to Planned.
- Completing, correcting and cancelling are in Activity and the entry's history.
- Overdue stops showing once an entry is done or cancelled. "Finished late" is kept as a fact on the record.

## Notes (technical)

- Add `completed_on`, `outcome`, `no_evidence_reason`, `completed_by_id`, `cancelled_reason`, `cancelled_at` and `cancelled_by_id` (or a separate completion row; builder's call). The freeze is enforced in the API on every write route: update, delete, link changes from COM-1049, and evidence removal from COM-1044.
- "Mark done" from the owner's portal comes in COM-1053; build the route so that task only adds the portal surface.

**Done when:** entries can be marked done (with outcome and evidence, or a reason), corrected, and cancelled with a reason, and done or cancelled entries refuse every change outside the rules above.