---
id: 01M7K60JXSXVV4VV2TVZRYSR7H
created: 2026-11-16T22:00:32.953044Z
updated: 2026-11-17T10:50:54.239088Z
type: task
title: A built-in check's evidence shows on the control's Evidence tab, as a collected check's does
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1883
sprint: s7nqsy0
comments:
- id: 01M7KG9JZPE3S0HZAC8TPSN05Q
  author: Steve Vine
  at: 2026-11-17T01:00:13.686227Z
  text: |-
    Done — PR #1876, merged d146bacb.
    On a control's Evidence tab ▸ Automated Collection, every check now sits in one "Checks" list ordered by ID, built-in checks first. "Checks Compass runs" has gone.
    Each built-in check has a card like a collected check's: its ID and name (linked to its page), Passing / Failing / Can't tell, "failing n of m", when it last ran, and the open gap it raised on this control.
    Details opens what it found as at its last run — the Failing (or Listed) items with Item, Detail and Note, paged, with Export CSV — and its thresholds, read-only. Someone who can't see the items by name sees the count only.
    The ⋮ menu has Run now and Switch off (asks first) for assessors, and "Open the check to edit" for everyone.
    Assumptions: "Nothing collected yet." now shows only when a control has no checks of either kind; a switched-off built-in check stays in the list as Off (switching it on is on its page or the Built-in Checks tab).
    To check on staging: a control with a built-in check (e.g. one MFA covers) — open the card, page through its items, export CSV; check phone width and dark mode.
- id: 01M7MJ34WZK589YEN5VARQSH56
  author: Steve Vine
  at: 2026-11-17T10:50:54.238789Z
  text: |-
    Pre-UAT on staging 44d15b9a — Failed (phone width only)
    - A card like a collected check's: as E2E Admin A, IDM.13 ▸ Evidence ▸ Automated Collection has one "Checks" list with a card each for CHB-1 and CHB-2. Each card shows the ID and name (the name links to the check's page), BUILT-IN, the state pill (FAILING / PASSING), "failing 167 of 1,216" and "last ran …". Passed.
    - Opening the card shows its evidence: CHB-1 shows "Failing (167) as at 17 Nov 2026, 10:25" with Item / Detail / Note, paged 1 2 3 4 5 … 9 (page 2 shows different rows). Export CSV downloaded 167 rows plus a header. CHB-2 (passing) shows "Listed (3) as at …". As E2E Viewer, the open card says "180 — you can't see them by name here" (count only). Passed.
    - Actions: the ⋮ menu has Run now, Switch off and Open the check to edit (a link to the check's page). Run now updated last ran. Switch off asks first ("Switch CHB-2 off? …"), and I cancelled. Viewer sees only "Open the check to edit". Assessor sees all three. Passed.
    - Thresholds read-only: IDM.6's CHB-4 card shows "Dormant after: 90 days" as text, with no editor. Passed.
    - Gaps: with IDM.18 assessed (see COM-1881), CHB-12's card showed "· GAP-139" linking to the gap. Passed.
    - Layout, one list ordered by ID, "Checks Compass runs" gone: yes for controls with built-in checks only (IDM.13: CHB-1, CHB-2). No control in E2E has both a built-in and a collected check, so I couldn't see the two kinds mixed in one list.
    - Other screens unchanged: IDM.13's coverage pill and sentence read as before.
    - Phone width, light and dark: dark at desktop and phone width looks right. FAILED at phone width (390px): with the card open, its items table runs past the card's right edge and the whole page moves sideways (about 265px). On a phone you have to pan the page to read Detail and Note.
    - Tests and Browser smoke: the staging deploy run is green.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1883/
assignee: steve
priority: medium
task_status: review
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