---
id: 01M78CNRDK6N6ECBZB1AEBPM0C
created: 2026-11-12T17:25:19.411376Z
updated: 2026-11-12T17:25:23.813281Z
type: task
title: Between phone and desktop widths (576–700px), the trail still names the page you're on
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1773
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: todo
---
Found by the COM-1767 builder (sprint 116, 2026-11-12). Not a regression: COM-1767 fixed phones (below 576px) only.

**What happens:** in the 576–700px range (large phone in landscape, small tablet) the trail still squeezes the current page's name to nothing: measured 0px at 576 and 640px, 37px at 700px.

**What it should do:** at every width the trail shows the current page's name, truncated with an ellipsis if need be, as it now does below 576px (COM-1767); the company name gives way first.

**Done when:** at 576, 640 and 700px, as Admin A and the Viewer, 4 steps deep, the page name is visible (at least a few letters) and every top-bar control is on screen; 390px and 1440px unchanged; the phone Browser smoke (phone.spec.ts) gains a check at 640px. Frontend only, independent.