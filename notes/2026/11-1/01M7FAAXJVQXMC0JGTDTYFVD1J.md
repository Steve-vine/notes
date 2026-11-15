---
id: 01M7FAAXJVQXMC0JGTDTYFVD1J
created: 2026-11-15T09:59:08.123233Z
updated: 2026-11-15T09:59:11.016436Z
type: task
title: A collected check's columns can be put in any order, by dragging, on Review and in Edit fields
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1844
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
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