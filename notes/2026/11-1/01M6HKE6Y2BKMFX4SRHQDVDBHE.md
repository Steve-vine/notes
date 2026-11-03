---
id: 01M6HKE6Y2BKMFX4SRHQDVDBHE
created: 2026-11-03T21:01:00.226196Z
updated: 2026-11-03T21:01:03.869508Z
type: task
title: Finish an initiative — the owner marks it Complete or Cancelled (with a note), it keeps its percentage and item list as they stood and becomes read-only; reopen puts it back to Active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1561
sprint: snyzymp
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). Builds on COM-1560.

## What people see

- **Who can finish it.** The owner, or anyone with *Manage initiatives*, can mark an initiative **Complete** or **Cancelled** at any time, with an optional closing note.
  - Below 100%, Complete asks for confirmation and says what's still open ("4 actions still open: they stay with their owners").
- **What finishing does to the initiative:**
  - it shows its **final percentage**, the date, who closed it and the note;
  - every tab shows the items **as they stood** at that moment, each with its status then;
  - a banner says "Completed on 3 Dec 2026, shown as it stood", with a link to each item's live page;
  - nothing on it can be edited;
  - "Initiative · Deliver" leaves the owner's Actions list.
- **What finishing doesn't do to the items.** Gaps, risks, plans and content are untouched. Their own actions stay with their owners.
- **Requires review.** Requests still open are withdrawn. Their actions go unless another initiative still wants the review.
- **Reopen** (owner or *Manage initiatives*) puts it back to **Active** and live. It keeps its history: who closed it, when, and the reopening. The withdrawn review requests aren't restored automatically. The screen offers to mark them again.
- **The list.** "Active only" hides finished initiatives. Turning it off shows them with their final figure.

## Notes (technical)

- On close, write a snapshot (JSONB on `initiatives`, or an `initiative_snapshots` row): the resolved items with status and owner name at the time, plus the progress breakdown.
- A closed initiative's read endpoints serve the snapshot.
- Status changes are audited.
- Refuse writes to a closed initiative with 409 and a plain message.

**Chain:** on the chain (migration + API).

**Done when:** on staging, as admin in E2E Test Company:
- completing a 40% initiative asks to confirm, then shows 40% and the items as they were;
- closing one of its gaps afterwards doesn't change the completed initiative;
- reopening shows it live again, with the new figure.