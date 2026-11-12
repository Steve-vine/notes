---
id: 01M78AQE03NAMK10SGR079EX6K
created: 2026-11-12T16:51:17.123241Z
updated: 2026-11-12T16:51:20.795058Z
type: task
title: On a phone, the trail still shows the page you're on, and its "…" is easy to tap
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1767
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found in the sprint 116 round-3 pre-UAT pass on staging (3175d2ad, 2026-11-12); follow-up to COM-1759. Fix forward.

**What happens:** at 390 px the trail shows only "…": the current page's name is squeezed to nothing, so the bar never says where you are. The "…" button ("3 more steps") is 11 px wide, a small tap target. It opens the earlier steps correctly.

**What it should do:** at phone width the trail reads "… › <current page>", with the page name truncating with an ellipsis rather than vanishing; the company name gives way before the page name disappears entirely. The "…" button is at least 24 px wide.

**Done when:** at 390 px, as Admin A and the Viewer, on the Dashboard, SAP and a 4-step-deep page, the current page's name is visible (truncated if long) and every top-bar control stays on screen (the COM-1759 phone Browser smoke still passes); the "…" button is at least 24 px wide and opens the earlier steps; desktop unchanged; light and dark; console clean. Frontend only, independent.