---
id: 01M78CNRDK6N6ECBZB1AEBPM0C
created: 2026-11-12T17:25:19.411376Z
updated: 2026-11-13T02:00:02.13235Z
type: task
title: Between phone and desktop widths (576–700px), the trail still names the page you're on
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1773
sprint: spsp226
comments:
- id: 01M78ESS3NTTK0NP54G6GF9MPZ
  author: Steve Vine
  at: 2026-11-12T18:02:28.34096Z
  text: 'Also in the trail (seen in the COM-1767 re-check, 2026-11-12): on a phone, after the "…" menu closes, focus returns to the "…" button and its focus ring is mostly clipped — the trail hides overflow and the "…" sits flush to its edges, so only a thin bar shows on the right. Done when: a keyboard user sees the whole ring on the "…" at 390px. Screenshot ~/compass-uat/spsp226/COM-1767/recheck-04-adminA-390-dark-trail-focus-ring-clipped.png.'
- id: 01M78Y6BAXXQN8KH32QV9JFMAX
  author: Steve Vine
  at: 2026-11-12T22:31:28.861618Z
  text: |-
    Built — PR #1770 (frontend only; auto-merge once rebased past #1765, which also edits phone.spec.ts).

    Below 768px the top bar now behaves as on a phone: the trail reads "… › this page", and the company name gives way first, down to just the buildings icon. Page-name width four steps deep (light and dark): 576px — Admin A 91px (was 0), Viewer 131px (was 0); 640px — 155 (was 0), 195 (was 19); 700px — 208 (was 35), 223 (was 67). Every top-bar control stays on screen. At any width the page name keeps at least a few letters. After the "…" menu closes, the whole focus ring on "…" is visible. 390 and 1440px unchanged.

    Choices:
    - Cut-off at 768px, not 700px: at 768px the old two-step trail was still squeezed (page name 38px, the step before 9px).
    - From 576 to 768px the company button is treated as on a phone (no caret, shrinks to the icon); keeping the caret showed a half-cut letter.
    - The colour-scheme and light-bulb buttons stay in the bar at these widths; only phones move them into your menu.

    Checks: phone.spec.ts gains a 640px test for both accounts and a focus-ring check at 390 and 640px (both fail on today's staging, pass on this branch). Trail and AppLayout tests (2 new), tsc, eslint, prettier pass; CI green. Screenshots ~/compass-uat/spsp226/COM-1773/.
- id: 01M79A47AM8K2TBDJHKJV5WPEG
  author: Steve Vine
  at: 2026-11-13T02:00:02.132092Z
  text: |-
    Pre-UAT on staging (6e988b9d), E2E Test Company: **Passed**.
    Dashboard → open gaps → a gap → its control (4 steps), Admin A and Viewer, light and dark. Page-name width: 576 → 91px / 131px; 640 → 155 / 195; 700 → 208 / 223; 390 unchanged 66 / 104; 1440 full trail, page name 280px. No top-bar control off screen at any width; company button shrinks to its icon below 768; no sideways scroll. "…" is 24px, its menu lists Dashboard / Gaps / G-43, focus returns to it and its whole ring shows at every phone width. Console clean. Screenshots ~/compass-uat/spsp226/COM-1773/.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found by the COM-1767 builder (sprint 116, 2026-11-12). Not a regression: COM-1767 fixed phones (below 576px) only.

**What happens:** in the 576–700px range (large phone in landscape, small tablet) the trail still squeezes the current page's name to nothing: measured 0px at 576 and 640px, 37px at 700px.

**What it should do:** at every width the trail shows the current page's name, truncated with an ellipsis if need be, as it now does below 576px (COM-1767); the company name gives way first.

**Done when:** at 576, 640 and 700px, as Admin A and the Viewer, 4 steps deep, the page name is visible (at least a few letters) and every top-bar control is on screen; 390px and 1440px unchanged; the phone Browser smoke (phone.spec.ts) gains a check at 640px. Frontend only, independent.