---
id: 01M7YV4AK3Y2G3SAPN9S0GZA0K
created: 2026-11-21T10:41:14.339262Z
updated: 2026-11-21T13:33:45.709976Z
type: task
title: 'Add evidence window ▸ Link existing evidence: the preview stays in view while the register scrolls (today it scrolls off the top)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2065
sprint: s9hexqn
comments:
- id: 01M7YXH69Y51FYAJ5ZFHF8BGFB
  author: Steve Vine
  at: 2026-11-21T11:23:13.085934Z
  text: |-
    Done and merged to main (PR #2055). This changes the screen only.

    What changes:
    - On Link existing evidence, the preview never moves. Only the register's rows scroll, in their own column.
    - Clicking a row far down shows it in the preview at once.
    - The search and filters stay at the top throughout, and the Previous/Next bar stays in view under the rows.
    - A tall preview scrolls within itself. The title bar and bottom bar stay put.
    - Moving through the rows with Tab keeps the current row in full view, below the column headings.
    - In a window too narrow for two columns, it scrolls as one with the preview underneath, as before.

    Checked in headless Chromium with 40 rows, at 900px and 700px tall: after scrolling the register from top to bottom, the preview and the search bar were exactly where they started, and highlighting the last row updated the preview in place. The narrow layout is unchanged, with no sideways scroll.

    Calls for you to overturn:
    - The search and filters stay fixed (the task's own call).
    - Rows can't be highlighted with the arrow keys today, only by clicking, so "keyboard movement" here means tabbing through the ticks. I didn't add arrow keys, as that would be new behaviour.
- id: 01M7Z507BDE4WHQ107N39PX58S
  author: Steve Vine
  at: 2026-11-21T13:33:45.709703Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps: Opened Link existing on RIM.9 (68 pieces). Highlighted EVD-82, scrolled the register to the bottom, then clicked the last row (EVD-34). Also opened the tab at 390 wide.
    Seen:
    - The search box and the preview header stayed put the whole time (y=135 and y≈260).
    - Clicking EVD-34 updated the preview in place, and Previous/Next stays under the rows.
    - At 390 the columns stack, with no sideways scroll.
    Screenshots: ~/compass-uat/s9hexqn/COM-2065/
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Raised by Steve while testing sprint 120 (2026-11-21). Same kind of fix as COM-2063 (the Assessment screen's box).

**What Steve saw.** On the Link existing evidence tab, the preview of the highlighted piece sits beside the register. Scrolling down the register carries the preview off the top of the window, so you have to keep scrolling back up to see what you've highlighted.

**Why** (checked in the code). The register and the preview are side by side inside one area that scrolls as a whole, so both move together.

**What people see after this**
- The preview never moves. Only the register scrolls, in its own column.
- Highlighting a row further down shows it in the preview at once, without scrolling back up.
- **My call (Steve to overturn): the search and filters above the register stay at the top too.** They don't scroll away with the rows, so a search can be changed from anywhere in the list.
- A preview taller than the window scrolls within itself.
- The window's title bar and bottom bar (with the selection count and Link button) stay put as now.
- In a window too narrow for two columns, the preview drops underneath as now.

**Implementation notes**
- `evidence/LinkExistingEvidence.tsx`: the body is one `overflowY: auto` box (padding 20) holding a wrapping flex row of the register column and `ExistingEvidencePreview`.
- Make the register column its own scrollport, and the preview a column beside it that doesn't scroll with it (with its own inner scroll), within the window's fixed height. Keep the search and filters above the scrolling rows.
- Don't fake it with `position: sticky` inside the shared scrollport. That's what makes the Assessment screen's box slide before it sticks (COM-2063).
- Check keyboard movement through the rows keeps the highlighted row in view.
- Frontend only. Independent: no migration or API change.

**Done when**
- Scrolling the register from top to bottom leaves the preview exactly where it was, and highlighting any row updates it in place.
- The search and filters stay visible throughout.
- The narrow layout behaves as before.