---
id: 01M7V3BQFT3EYK6SPKHPST9ECT
created: 2026-11-19T23:48:07.802009Z
updated: 2026-11-19T23:49:06.39443Z
type: task
title: Zoom in on a flowchart in the Read tab enlarges the picture again
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2005
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in pre-UAT of round 3, by Tester C on staging 7ea67f64, against COM-2003.

**Steps:** on the Read tab, with paper on or off, press Zoom in three times on a flowchart in a document. Also try it on a standalone flowchart's own page.

**Seen:**
- The picture doesn't grow. A large one stays 680 px at every step. A small one goes 672 → 680 px, then stops. On a standalone flowchart's own page it stays 627 px.
- The frame scrolls over empty space.
- The lane names grow 3× on top of the picture, and the link spots drift off their shapes.
- Full screen works correctly (1.5×, 2×, 3×).

**Likely cause:** a general picture rule that caps every document picture at the page's text width, `.rt-doc .rt-picture img { max-width: min(100%, var(--rt-page-text-width)) }`. It probably arrived with COM-2004 or COM-2000, which merged after COM-2003. Zoomed pictures must be exempt from that cap.

Screenshots: ~/compass-uat/s6y6p7g/COM-2003/r3-zoom3-fig0-read.png, r3-zoom3-fig1-read-paper-off.png, r3-zoom3-fig0-standalone-page.png

**Done when**
- On the Read tab, a flowchart in a document and a standalone flowchart on its own page each grow 1.5×, 2× and 3× the size they're first shown at, small and large alike. Zoom out steps back.
- Lane names, pinned lane headings and Link spots stay on their shapes at every zoom.
- The frame pans inside itself and the page never scrolls sideways.
- The cap on picture width still applies to pictures that aren't zoomed, so COM-2000's sizes are unchanged.
- The same zoom works for images, drawings and diagrams (COM-2004).
- Tests: a test of the real CSS in a browser-like layout, or a guard that the cap doesn't apply to a zoomed stage, so this can't silently break again.

Independent: frontend only.