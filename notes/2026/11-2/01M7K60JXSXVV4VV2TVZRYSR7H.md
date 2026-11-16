---
id: 01M7K60JXSXVV4VV2TVZRYSR7H
created: 2026-11-16T22:00:32.953044Z
updated: 2026-11-16T22:59:14.10367Z
type: task
title: A built-in check's evidence shows on the control's Evidence tab, as a collected check's does
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1883
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: todo
---
From Steve's testing of round 2 (staging 43d03f09). Steve: "the actual evidence doesn't show on the control page either, can that be added the same as custom checks show."

**Today.** On a control's Evidence tab ▸ Automated Collection, a collected check has a card that opens to show its evidence (the table), with its status, actions and Details. A built-in check is only a line in "Checks Compass runs", showing its name and passing or failing. Its evidence (what it found failing, or what it listed) is only on the check's own page.

**Done when**
- **A card like a collected check's.** Each built-in check on the control has a card in the same style as a collected check's, in the same list:
  - CHK ID and name, linked to the check's page;
  - a state pill (Passing / Failing / Can't tell), and "failing n of m" when it fails;
  - when it last ran.
- **Opening the card shows its evidence:**
  - the **Failing** items when it fails, or the **Listed** items when it passes, with Item, Detail and Note as on the check's page;
  - paged, with Export CSV;
  - "as at <last run>" above the table.
  Someone who can't see the items by name sees the count only, as on the check's page.
- **Actions.** The card's ⋮ menu has Run now and Switch off.
- **Thresholds and Edit.** The card shows thresholds read-only. Editing happens only on the check's own page (Steve, 16 Nov: thresholds are only editable on Evidence Collection ▸ All checks ▸ the check), so the menu has **Open the check to edit**, a link, not an editor on the card.
- **Gaps.** An open gap the check raised on this control is shown on its card, linked.
- **Layout.** Built-in and collected checks sit in one list under Automated Collection, ordered by CHK ID, so the two kinds look and behave the same. The separate "Checks Compass runs" list goes.
- **Other screens.** The control's coverage pill and gap sentence are unchanged by this. COM-1880 changes where coverage comes from.
- **Checks.** It works at phone width and in light and dark. The page's tests are updated, and the Browser smoke still passes on the control page.

**Where** (for the builder): control/EvidenceTab.tsx (`AutomatedCollection`, `ChecksCard builtInOnly`), collection/CollectionCard.tsx (the card to match, or a shared card shell), pages/CheckDetailPage.tsx (the items table to reuse), checks/checks.ts (`useChecks`, items, CSV).