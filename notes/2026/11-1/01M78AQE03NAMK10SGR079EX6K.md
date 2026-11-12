---
id: 01M78AQE03NAMK10SGR079EX6K
created: 2026-11-12T16:51:17.123241Z
updated: 2026-11-12T17:25:15.215254Z
type: task
title: On a phone, the trail still shows the page you're on, and its "…" is easy to tap
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1767
sprint: spsp226
comments:
- id: 01M78CNGSYVYV1AM7P66CEF790
  author: Steve Vine
  at: 2026-11-12T17:25:11.614409Z
  text: |-
    Built — PR #1760 (auto-merge set), commit ad25b458. Frontend only.

    What you'll see on a phone (below 576px):
    - The trail reads "… › this page"; a long page name ends in an ellipsis and never shrinks below a few letters.
    - The "…" button is 24px (was 11px) and still opens every earlier step.
    - On a page with a trail, the company name gives way first — down to just the buildings icon on deep pages at 390px — and the button drops its up/down caret; tapping it still opens the company list. On pages with no trail (Dashboard, SAP list) the company name shows as before.
    - Top-bar buttons sit 4px apart on a phone instead of 6px (the customer portal's bar too).
    - Wider windows unchanged (1440, 900 and 600px measured identical before and after).

    Measured at 390px / 360px, page name width: Admin A (SAP entry, 4 steps deep) 66 / 36px (was 0); Viewer (4 steps deep) 104 / 74px. No top-bar control off screen, no sideways scroll, light and dark.

    Checks: eslint, tsc, prettier clean; full vitest suite passes (3966) incl. a new Trail test; the phone Browser smoke now also walks four steps deep (Dashboard › open gaps › a gap › its control) as Admin A and the Viewer and checks the page name is visible and the "…" is 24px — it fails on the old code and passes on this build. Screenshots ~/compass-uat/spsp226/COM-1767/.

    Choice: the task allowed either order; the company name gives way before the page name, since the company is the same on every page and the trail's job is to say where you are.

    Not done: between 576 and 680px (large phone landscape, small tablet) the page name can still squeeze to nothing — that's above the phone breakpoint, so left alone and logged separately.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found in the sprint 116 round-3 pre-UAT pass on staging (3175d2ad, 2026-11-12); follow-up to COM-1759. Fix forward.

**What happens:** at 390 px the trail shows only "…": the current page's name is squeezed to nothing, so the bar never says where you are. The "…" button ("3 more steps") is 11 px wide, a small tap target. It opens the earlier steps correctly.

**What it should do:** at phone width the trail reads "… › <current page>", with the page name truncating with an ellipsis rather than vanishing; the company name gives way before the page name disappears entirely. The "…" button is at least 24 px wide.

**Done when:** at 390 px, as Admin A and the Viewer, on the Dashboard, SAP and a 4-step-deep page, the current page's name is visible (truncated if long) and every top-bar control stays on screen (the COM-1759 phone Browser smoke still passes); the "…" button is at least 24 px wide and opens the earlier steps; desktop unchanged; light and dark; console clean. Frontend only, independent.