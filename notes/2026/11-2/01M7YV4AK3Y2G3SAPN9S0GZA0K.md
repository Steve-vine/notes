---
id: 01M7YV4AK3Y2G3SAPN9S0GZA0K
created: 2026-11-21T10:41:14.339262Z
updated: 2026-11-21T10:41:14.339262Z
type: task
title: 'Add evidence window ▸ Link existing evidence: the preview stays in view while the register scrolls (today it scrolls off the top)'
priority: medium
task_status: todo
assignee: steve
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2065
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