---
id: 01M77XA4HX3RPHFXSKR1BGK782
created: 2026-11-12T12:56:49.981152Z
updated: 2026-11-12T16:50:35.027863Z
type: task
title: 'SAP list: a Controls column shows each entry''s linked controls as pills, and "None" stands out'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1754
sprint: spsp226
comments:
- id: 01M7855F327AREJJN8Z6HYHG4F
  author: Steve Vine
  at: 2026-11-12T15:14:05.538428Z
  text: |-
    Built — PR #1754 (auto-merge set), commit 304a56be. On the chain (the list response gains each entry's controls); no migration.

    What you'll see:
    - SAP ▸ List has a Controls column after Title. Each linked control is a pill with its reference (e.g. VUM.3); hover shows its name; clicking opens the control.
    - Past three, the rest fold into a grey "+N" pill that lists them on hover ("REF · name"); clicking it opens the entry.
    - No controls: a "None" pill in the warning colour (amber in light and dark).
    - Sorting by Controls puts every "None" first (ascending) or last (descending).
    - Cancelled and done entries show the controls they finished with; a repeating entry shows its series' controls, as the entry page does.
    - Controls come with the list — two queries for the whole page, not one per row.
    - Polaris's SAP list tool now includes each entry's control references too.

    Choices:
    - Controls are in natural order by reference (SEA.2, SEA.3, SEA.10).
    - A control deleted from the library is left off the list (nothing to open), so in that rare case the list says "None" while the entry page still shows the deleted control.

    Checks: ruff, mypy strict, unit suite (2192 passed), SAP integration tests (59 passed, incl. a new one: none/one/several, series, cancelled, unlink shows on next read); eslint, tsc, prettier clean; 4 new SAP page tests; full vitest green apart from a known load flake; schema.d.ts regenerated. Checked in headless Chromium, light and dark, 1400px and 390px, console clean.

    Seen but not part of this: at 390px the whole SAP page scrolls sideways because the filter bar's toggles overflow — passed to COM-1759 (phone top bar).
- id: 01M78AP4WKSA5JZ1VH3RB38SZY
  author: Steve Vine
  at: 2026-11-12T16:50:35.027599Z
  text: |-
    Pre-UAT on staging (3175d2ad), 2026-11-12 — **Passed**.
    Made SAP-72 (5 controls), SAP-73 (1) and SAP-74 (2, then cancelled) in E2E Test Company. List: SAP-72 shows ACC.1, ACC.11, ACC.12 and "+2"; SAP-73 CHM.7; cancelled SAP-74 still THP.2, THP.3; SAP-65/70/71 "None" in amber (light and dark). Hover ACC.11 shows its name; hover "+2" lists ACC.13/ACC.14 with names; clicking CHM.7 opened /controls/CHM.7. Sorting ascending puts the Nones first, descending last. Unlinking CHM.7 made SAP-73 read None; linking BCR.13 showed it; unlink + browser Back showed None straight away. At 390px the table scrolls inside itself, page doesn't. Console clean.
    Screenshots ~/compass-uat/spsp226/COM-1754/.
assignee: steve
label:
- improvement
priority: low
task_status: review
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