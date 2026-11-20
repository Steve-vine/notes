---
id: 01M7TS6ZFSW4C23AY5AKB97ZWQ
created: 2026-11-19T20:50:46.393629Z
updated: 2026-11-20T14:05:05.189978Z
type: task
title: A flowchart's Zoom in and out steps are relative to the size it's shown at
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2003
sprint: s6y6p7g
comments:
- id: 01M7TX99HKKARZKRRBGBKZ08AW
  author: Steve Vine
  at: 2026-11-19T22:01:56.531349Z
  text: |-
    Done — PR #1994, merged 7d3a145f.
    Zoom in on a flowchart now makes it 1.5×, 2× and then 3× the size it was first shown at, whatever its size, and Zoom out steps back the same way. A small flowchart and a large one grow by the same proportion on each click.
    Unzoomed, every flowchart shows as before: a large one fitted to the column, a small one at its own size. Zoomed past the column, the frame scrolls inside itself and the page never scrolls sideways; lane names and linked steps stay on their shapes.
    The same holds in full screen (from the size full screen first shows), on a standalone flowchart's own page and when a standalone flowchart is shown in a document.
    Assumption: only flowcharts have zoom today; COM-2004 (zoom for other pictures) should use the same rule.
    To check on staging: zoom a 3-box flowchart and a large one in a document's Read tab; each first click should be half as big again.
- id: 01M7V394JENJBV81DSC51RK040
  author: Steve Vine
  at: 2026-11-19T23:46:42.893898Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Failed
    Tested as E2E Admin A in E2E Test Company, in a headless Chromium at 1440 px wide. Test document "E2E pre-UAT COM-2003 zoom small and large" holds a 3-box flowchart (672 px), a large two-lane flowchart (3432 px, fitted to 680 px) and the standalone "E2E pre-UAT COM-2003 standalone large". Widths measured in pixels on the picture itself.
    - Each Zoom in step makes the flowchart 1.5×, 2× and 3× as big, whatever its size: FAILED on the Read tab, with paper on and with it off. The picture never grows. The large one stays 680 px at every step (680 → 680 → 680 → 680). The small one goes 672 → 680 and then stops. Only the frame round it and the lane names get bigger. The cause is a picture rule capping every document picture at the page's text width: max-width min(100%, 680px) on ".rt-doc .rt-picture img". It probably came in with COM-2004, which merged after this task.
    - At the first size, a large flowchart is fitted to the column and a small one is at its own size: Passed. Large 680 px (column/page text width), small 672 px (its own size).
    - Zoomed past the column, the frame scrolls inside itself and the page never scrolls sideways: half passed. The page never scrolls sideways (1440/1440 at every step). The frame does scroll (2041 px of scroll at 3×), but over a picture that hasn't grown, so you pan into empty space.
    - Lane names, pinned lane headings and Link spots stay on the right shapes at every zoom: FAILED on the Read tab. The lane name boxes grow 3× while the picture doesn't, so at 3× "Requester" and "Approver" cover about a tenth of the picture instead of the lane headings. The Link spot moves from 24% to 71% across the picture.
    - Full screen, with steps relative to the size it first shows at: Passed. Large 680 → 1020.5 → 1360.6 → 2040.9 and back down; small 672 → 1008 → 1344 → 2016 and back down. Lanes and spots stay put.
    - Standalone flowchart on its own page and shown in a document: FAILED, the same as above. On its own page it stays 627 px at every step, with the lane names drifting. Shown in the document it stays 680 px.
    - Same rule for any future picture zoom: nothing to check here (COM-2004 is Tester B's).
    - Tests: the frontend unit tests pass in jsdom, which doesn't apply CSS, so they can't catch this.
    Steve: on the Read tab, press Zoom in three times on any flowchart. The picture doesn't grow, and the lane names swell over it.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2003/ (r3-zoom3-fig0-read.png, r3-zoom3-fig1-read-paper-off.png, r3-zoom3-fig0-standalone-page.png, r3-full-zoom3-doc-fig*.png)
- id: 01M7VAVAQ4CPVC3P26V0WPV656
  author: Steve Vine
  at: 2026-11-20T01:58:59.044675Z
  text: |-
    Re-check on staging 0ed475e8 (after COM-2005): these points now Passed: zoom steps 1.5×/2×/3× on the Read tab; the frame pans over the grown picture; lane names, pinned lane headings and link spots stay put; standalone on its own page and shown in a document.
    Measured as E2E Admin A in "E2E pre-UAT COM-2003 zoom small and large", paper on and off. Large: 680 → 1020 → 1361 → 2041 → back to 680. Small: 672 → 1008 → 1344 → 2016 → back. Lane and spot positions moved by at most 0.1% of the picture. The page never scrolled sideways (1440/1440).
    Standalone: "…COM-2003 standalone large" on its own page went 680 → 2041; shown in the document, the same. Full screen is still correct (680 → 2041, 672 → 2016).
    Screenshots: ~/compass-uat/s6y6p7g/COM-2005/r3re-* and COM-2003/r3re-full-zoom3-*
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Steve's smoke test of round 2: Zoom in on a flowchart in the Read tab isn't relative to the flowchart's size. A large flowchart gets about 50% bigger on the first click, but a small one gets 5 or 6 times bigger.

Cause (FlowchartFigure.tsx, ZOOMS = [1, 1.5, 2, 3]): each zoom step makes the picture a share of the column's width (150%, 200%, 300%), not a share of the size it was shown at. A large flowchart already fills the column, so 150% is half as big again. A small one is shown at its own small size, so 150% of the column is many times bigger.

**Done when**
- Each Zoom in step makes a flowchart the same amount bigger than it was, whatever its size: 1.5×, 2× and 3× the size it's first shown at. Zoom out steps back the same way. A small flowchart and a large one grow by the same proportion on each click.
- At the first size (no zoom), every flowchart shows as now: a large one fitted to the column, a small one at its own size.
- When zoomed past the column's width, the frame scrolls to pan inside itself as now, and the page never scrolls sideways.
- Lane names, pinned lane headings and Link spots stay on the right shapes at every zoom.
- The same holds in full screen, where the steps are relative to the size full screen first shows it at. It also holds for a standalone flowchart, on its own page and when shown in a document.
- If a picture or diagram zoom is added elsewhere, it follows the same rule. Today only flowcharts have zoom.
- Tests cover a small and a large flowchart each growing 1.5× on the first Zoom in, and back on Zoom out.

Independent: frontend reading view only.