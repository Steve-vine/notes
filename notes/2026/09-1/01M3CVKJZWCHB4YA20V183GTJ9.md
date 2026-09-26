---
id: 01M3CVKJZWCHB4YA20V183GTJ9
created: 2026-09-25T18:00:30.732322Z
updated: 2026-09-26T12:39:48.080569Z
type: task
title: A scrolling page keeps a gutter on the right, not just the left
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 750
sprint: s71mee4
comments:
- id: 01M3CWHFY6B2SCQ4JKE9VV50W1
  author: Steve Vine
  at: 2026-09-25T18:16:47.301982Z
  text: |-
    Done: PR #760, squash-merged to main as c60f5c3. It is not yet deployed to staging.

    The page's scrolling area now reaches the window edge and keeps its 16px gap inside the scrollbar. Only that area changed; the restored-company notice above it keeps its margin.

    I measured it in a real (headless) browser with the actual app frame and a standard scrollbar:
    - Before: 0px between text and scrollbar, and 16px of dead space outside the scrollbar. This matches the screenshot.
    - After: 16px between text and scrollbar, the same as the left, and the scrollbar at the window edge.

    List pages that scroll inside their own table keep the same width as before.

    To smoke-test: open a long document's Read tab and check the right edge of the text and of the Posture box. Also glance at a list page such as Content or Risks.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
![CleanShot 2026-09-25 at 18.57.11@2x.png](attachments/2026/09/01M3CVKJZWCHB4YA20V183GTJ9/CleanShot-2026-09-25-at-18.57.11@2x.png)

On a scrolling page, the text and boxes run right up to the scrollbar on the right, while the left keeps a gap. It was reported on a document's Read tab with the Posture box, but every page that scrolls as a whole had the same problem.

**Cause:** the app's frame puts a 16px margin around the page area, and the page scrolls inside that margin. The scrollbar therefore took up the right-hand margin, leaving no gap between the text and the scrollbar and a strip of empty space outside the scrollbar.

**Fix:** the scrolling area now extends to the window edge and keeps the 16px gap inside itself. The scrollbar sits at the edge of the window, and the text has the same gap on both sides.