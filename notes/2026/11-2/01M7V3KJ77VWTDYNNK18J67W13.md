---
id: 01M7V3KJ77VWTDYNNK18J67W13
created: 2026-11-19T23:52:24.551914Z
updated: 2026-11-19T23:52:24.551914Z
type: task
title: The picture settings panel never covers the selected picture, and a picture isn't selected when the page opens
priority: high
assignee: steve
label: bug
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2008
---
Found in pre-UAT of round 3, by Tester B on staging 7ea67f64, against COM-1999.

**1. The panel covers the picture.**
- In a 600×900 window with paper off, select the document's own flowchart in "E2E pre-UAT COM-2004 every kind of picture". The panel docks at the bottom (y 536–884) and covers the bottom 113 px of the flowchart (y 307–649).
- In a 1100×700 window, a Full width image near the top has its top-right corner covered.
- Cause: Compass scrolls an inner page container, not the window. The panel's scroll-clear uses window scrolling, so nothing moves (window.scrollY stays 0).
- Screenshots: ~/compass-uat/s6y6p7g/COM-1999/r3-narrow600-scroll-flowchart.png, r3-1100x700-fullwidth-image-covered.png

**2. A picture that is the document's first block is already selected when the Edit tab opens.** Its panel is open, and the first click on it closes the panel. Screenshot: ~/compass-uat/s6y6p7g/COM-1999/r3-onload.png

**Done when**
- On every window size, the panel never covers the selected picture. When it would, the panel moves to another free place, or the page scrolls the picture clear. The scrolling uses whatever actually scrolls (Compass's page container), not the window.
- Check 600×900, 800×600, 1100×700 and 1440×900, with paper on and off, for a picture at the top, the middle and the bottom of a long document, and a Full width picture.
- Opening a document's Edit tab selects nothing, and no panel opens, even when the first block is a picture. The first click on it selects it.
- Tests cover the panel position against the picture in a short and a narrow window, and nothing being selected on load.

Independent: frontend only.