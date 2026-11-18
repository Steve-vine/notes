---
id: 01M7QBV2V7C56T904YXPX7TE1P
created: 2026-11-18T12:59:21.831258Z
updated: 2026-11-18T16:29:05.602867Z
type: task
title: A light/dark toggle for the flowchart canvas background
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1947
sprint: s6y6p7g
comments:
- id: 01M7QQV2VC3Y9CGKNVH4VN8G33
  author: Steve Vine
  at: 2026-11-18T16:29:04.747833Z
  text: |-
    Done — PR #1943, merged 753e34ff. On the chain: it adds migration 0877 and a new saved preference.
    The flowchart canvas toolbar has a sun/moon button that switches the canvas between a light and a dark background, whatever Compass's own theme is. Shapes, lines, lane bands, labels and the canvas ground all switch with it, and the words stay readable on both.
    A flowchart's full-screen reading view has the same button. With dark chosen, the picture is drawn on a dark background.
    The choice is saved with the person's preferences, so it follows them to any device. Until they choose, the canvas follows Compass's theme, as before.
    It's only for viewing. Nothing is added to the draft or to undo. The kept picture, downloads, PDF and Word stay in the light house style.
    Assumptions: until someone has made a choice, full screen keeps today's light picture, even in Compass's dark theme. Once they choose, both the canvas and full screen use their choice. The full-screen button only shows to someone signed in, because it saves a preference.
    To check on staging: after the deploy runs the migration, open the canvas and click the sun/moon button. Reload, and open it on another browser: the choice should stick. Open a flowchart full screen and switch it there too. Then download a PNG and the PDF: both should still be light.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve, testing on staging, 2026-11-18: add a toggle to change the canvas background between light and dark.

**What people see**
- The canvas toolbar has a **light/dark** toggle (sun/moon icon) that switches the canvas between a light and a dark background, whatever Compass's own theme is.
- Shapes, lines, lane bands and labels switch with it and stay readable on either background. Chosen colours (COM-1942) stay the colours they are, and their text stays readable.
- The same toggle is on a flowchart's full-screen view when reading.
- The choice is remembered for that person, on any device, like their other preferences. Until they choose, the canvas follows Compass's theme, as now.

**What doesn't change**
- The toggle is only for viewing. It doesn't change the flowchart itself, so nothing is saved to the draft.
- The published picture, PDF, Word and downloads always use the light house style (COM-1910).

**Done when**
- The toggle switches the canvas and the reading full-screen view between light and dark, and everything stays readable in both.
- The choice is remembered for the person, and it never creates draft changes or alters exports.
- Tests cover the toggle, readability in both, and exports staying light.

Independent: frontend, plus the person's saved preferences if that needs a new setting.