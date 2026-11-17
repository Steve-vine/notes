---
id: 01M7FAAXJVQXMC0JGTDTYFVD1J
created: 2026-11-15T09:59:08.123233Z
updated: 2026-11-17T19:50:07.585621Z
type: task
title: A collected check's columns can be put in any order, by dragging, on Review and in Edit fields
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1844
sprint: spsp226
comments:
- id: 01M7FH47GQCAWAZSFMRHDC8B9R
  author: Steve Vine
  at: 2026-11-15T11:57:48.95122Z
  text: |-
    Built and merged — PR #1837 (bcf64b49). Independent: the fields save already kept the order it was given, so no migration and no API change.

    What you'll see:
    - **Drag a column head** onto another kept column to move it, on a proposal's Review card and in Edit fields on a live check. Each kept column's head menu also has Move left / Move right. Columns the check doesn't keep don't move. A field ticked later goes at the end.
    - **The order is used everywhere:** the Review sample, captures filed from now on, new audit packs (page and CSV) and the Evidence tab. The check's own page used to list a capture's columns alphabetically; it now uses the check's order, so older captures show in the new order in the app. Pages already filed and packs already built keep their order.
    - **A re-order on a live check applies at once**, without going back to Review, like renaming a column. A change already waiting on Review takes the new order. Ticking or unticking by Polaris still goes to Review, as before.
    - **History:** the check's history gets "Columns re-ordered: …". Ticking and unticking now show there too ("Fields changed: now keeps …; no longer keeps …"); they weren't listed before. I took "Changes list" to mean this history.
    - **Polaris** re-orders on request ("put Approver before Status") and says it applied at once.
    - ADR 0142 has an amendment for this.

    Tests: backend tests for column order in the CSV and page, telling a re-order from ticking, a live re-order, the history lines and Polaris re-ordering. Vitest for drag, the menu moves and the history line.

    To smoke-test: drag a column on a proposal's Review card and approve. Then re-order a live check in Edit fields and look at its history, its page and the next capture.
- id: 01M7FSV8XQN6R1WRN84RVES8VA
  author: Steve Vine
  at: 2026-11-15T14:30:12.663203Z
  text: |-
    **Failed** (one minor defect; the re-ordering itself works). Some parts **Couldn't check**. Pre-UAT, staging build 20261115-1354 (36d3de6c), E2E Test Company, as E2E Admin A.

    **Live check, CHK-2 (ACC.13 ▸ Evidence ▸ the check's menu ▸ Change the fields it keeps):**
    - The table shows the last filed capture, with 102 kept columns in A–Z order. The hint says to drag a column's head or use its menu.
    - On allow_forking, the column menu offers Move left (greyed out on the first column) and Move right. Move right swapped it with archive_url.
    - Dragging the "name" head onto the first column moved it to the front.
    - Clicked Keep these fields, reloaded, and reopened: the order was kept (name, archive_url, allow_forking, archived…).
    - After a reload, the capture history shows **"COLUMNS RE-ORDERED · ran 15 Nov 2026, 14:24 · by E2E Admin A · Columns re-ordered: name, archive_url, allow_forking, …"**. It lists all 102 columns, which makes a long line.

    **Defect: the capture history doesn't refresh after a re-order.**
    1. Change the fields it keeps on CHK-2, then move a column.
    2. Click Keep these fields.
    3. The history under the card doesn't get the "Columns re-ordered" entry. I waited 6 s and it still showed the previous entries. It appears only after reloading the page. Seen both times I saved.

    **Review card (CHK-1 proposal):**
    - Dragging resultReason onto the first column moved it to the front, and Move left on activityDateTime moved that back to first. Both work.
    - The new order isn't kept if the page is reloaded before approving. It went back to Polaris's order, which I take as intended.
    - I didn't approve CHK-1, since it isn't my proposal and was left alone. So **"Approving keeps it, and the first capture page and CSV follow it" Couldn't check.**

    **Couldn't check:**
    - The capture page, CSV and PDF following the new order on a new capture, and older captures showing in the new order on the check page. CHK-2's Collection integration was deleted, so it can't capture, and its check page lists nothing.
    - The PDF of an already-filed capture downloaded fine. Filed pages keep their order by design.
    - Polaris re-ordering in chat: not tried, to avoid more changes to CHK-2.

    **Test data restored:** CHK-2's columns are back to A–Z, with a second "Columns re-ordered" history entry at 14:28. CHK-1's order is unchanged.

    Screenshots: ~/compass-uat/spsp226/COM-1844/
assignee: steve
label:
- improvement
priority: low
task_status: done
---
## What happened

Steve, testing Checks (2026-11-15): he wants to re-order a check's table columns. A collected check keeps the fields a person ticks (COM-1804, COM-1819), and they show as columns on its sample table on Review, its captures, its CSV and its PDF / audit-pack pages. The order is whatever Polaris proposed ("in the order a reader should see them"), and nobody can change it. Edit fields (`collection/EditFields.tsx`) only ticks and unticks.

## What people see

- **Column heads can be dragged left or right** on the sample table, both on Review (before approving) and in Edit fields on a live check. Each head also has Move left and Move right in its menu, for keyboard use.
- **The order is saved with the check** and used everywhere its columns appear: the capture page, CSV, PDF, audit packs built from now on, the sample on Review, and the control's Evidence tab.
- **Past captures show the new order too.** Only the order changes; what they captured doesn't. Audit packs already built keep the order they were built with.
- **Polaris's proposed order is the starting order.** Polaris in chat can change the order when asked ("put Approver before Status"), trying it first and saying what changed, as it does for other changes to a check.
- A re-order is recorded in the check's Changes list ("Columns re-ordered"), like ticking and unticking fields.
- **The order of unticked columns doesn't matter.** A field that's ticked later goes at the end, and can then be moved.

## Done when

- On staging (E2E Test Company), on a proposed check's Review card, dragging a column changes the order. Approving keeps it, and the first capture page and CSV follow it.
- On a live check, Edit fields re-orders columns by dragging and with Move left / Move right. After saving, the capture page, CSV and PDF follow the new order, older captures display in it, and the Changes list has the entry.
- Polaris in chat re-orders a check's columns on request.
- Vitest covers drag and the menu moves. Backend tests confirm the order is kept and used for CSV/PDF.

**Independent** if the fields save already keeps the order it's given. Otherwise **on the chain** (API change). Check first.