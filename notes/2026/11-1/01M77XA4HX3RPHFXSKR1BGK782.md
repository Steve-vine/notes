---
id: 01M77XA4HX3RPHFXSKR1BGK782
created: 2026-11-12T12:56:49.981152Z
updated: 2026-11-12T12:56:54.494384Z
type: task
title: 'SAP list: a Controls column shows each entry''s linked controls as pills, and "None" stands out'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1754
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Steve, testing on staging (2026-11-12).

**Today:** the SAP schedule's **List** view has the columns Ref, Title, Type, Owner, Starts, Due and Status. You can't tell which entries have no linked controls without opening each one.

**What it should do:**
- A new **Controls** column, after Title, shows each entry's linked controls as pills. Each pill shows the control's reference (e.g. "IAM.3"), shows its name on hover, and opens the control when clicked.
- Pills follow the screen conventions: a pill never truncates. Past three, the rest fold into a "+N" pill that lists them on hover.
- An entry with **no linked controls** shows a "None" pill in the warning colour, so the gaps are visible at a glance.
- The column sorts by the number of linked controls, so sorting brings every "None" together.
- Cancelled entries show their controls the same way.
- The list loads no slower: the controls come with the list, not one request per row.

**Done when:**
- the Controls column shows the right pills for entries with one, several (more than three) and no linked controls;
- clicking a pill opens that control;
- sorting by Controls puts the "None" entries together at one end;
- linking or unlinking a control on an entry shows on the list when you come back to it;
- light and dark mode and a narrow window are checked;
- there are no errors in the browser console.

On the chain: the API change is that `SapEntryOut` (the list response) gains each entry's linked controls (id, ref, name), loaded in one query for the page. Regenerate the OpenAPI and `schema.d.ts`. Frontend: `pages/SapPage.tsx` list table (SortableTh); the screen-conventions test covers the new column.