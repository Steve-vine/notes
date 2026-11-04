---
id: 01M6HKE6Y2BKMFX4SRHQDVDBHE
created: 2026-11-03T21:01:00.226196Z
updated: 2026-11-04T07:45:43.188809Z
type: task
title: Finish an initiative — the owner marks it Complete or Cancelled (with a note), it keeps its percentage and item list as they stood and becomes read-only; reopen puts it back to Active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1561
sprint: snyzymp
blocked_by:
- 01M6HKDJSC2D4G5EWY2DR05WS4
comments:
- id: 01M6HWS68G2930WV2963HB6D9N
  author: Steve Vine
  at: 2026-11-03T23:44:17.168523Z
  text: |-
    Done: PR #1575 merged, migration 0772.

    What's there:
    - **Finishing:** an Active initiative's header has **Complete** and **Cancel initiative**, for its owner or Manage initiatives, each with an optional note.
      - Below 100%, the dialog says "It's 40% complete. 4 actions are still open: they stay with their owners."
    - **A finished initiative:**
      - shows a banner: "Completed on 3 Dec 2026 by Mia Manager, shown as it stood. Each item's own page is live.", plus the note;
      - serves its tabs and percentage from a snapshot taken when it was finished;
      - has an empty Actions tab, because its items' actions stay with their owners on Actions;
      - drops "Initiative · Deliver" from the owner's list;
      - can't be edited;
      - has its open Requires review marks withdrawn.
    - **Reopen** puts it back to Active and live. The activity log keeps who finished it and who reopened it.

    My calls:
    - **Withdrawn review marks don't come back** when an initiative is reopened. Mark them again from the row menu.
    - **Edit, Complete and Cancel are hidden once it's finished.** Only Reopen shows.

    To test on staging (after the sprint deploys), as admin in E2E Test Company:
    1. Complete an initiative that's at 40%: it asks to confirm, then shows 40% and the items as they were.
    2. Close one of its gaps: the completed initiative doesn't change.
    3. Reopen it: it's live again, with the new figure.
- id: 01M6HYZDN34XY8EH4RCPKMYCZD
  author: Steve Vine
  at: 2026-11-04T00:22:38.499498Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04, E2E Test Company): **Passed** (through the API; the Playwright browser wasn't connected this session).

    Steps and what I saw, as E2E Admin A on INI-1:
    1. Completed it at 7% with the note "Pre-UAT": it shows Complete, 7%, by E2E Admin A, with the note.
    2. Closed G-61 afterwards: INI-1 still shows 7%, and G-61's row still reads "new", as it stood.
    3. Tried to edit it while Complete: refused.
    4. Reopened it: Active, now 10%.

    For you to look at: the "below 100%" warning in the Complete dialog, and the "shown as it stood" banner.
assignee: steve
label:
- feature
priority: medium
task_status: done
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