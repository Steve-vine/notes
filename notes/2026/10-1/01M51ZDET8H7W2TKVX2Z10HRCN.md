---
id: 01M51ZDET8H7W2TKVX2Z10HRCN
created: 2026-10-16T09:06:45.704557Z
updated: 2026-10-16T16:39:49.268373Z
type: task
title: The house style preview has no toolbar — nothing can be drawn or typed on it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1000
sprint: s2ufsxd
comments:
- id: 01M5277E2RRW83RZXZH2V4TDZQ
  author: Steve Vine
  at: 2026-10-16T11:23:16.951659Z
  text: 'Done in PR #987 (merged to main, 42aa341b). The house style preview now shows only the pages — no drawing, text, highlight, print or download tools in Edge or Chrome. Scrolling and zoom still work, and the "preview on this document" choice gets the same treatment. Firefox''s own PDF viewer ignores the setting and still shows its tools; Compass''s users are on Edge, so I left that. The document''s Print preview is unchanged — printing and downloading are the point there.'
assignee: steve
label:
- improvement
priority: low
task_status: done
---
Found in Steve's smoke test of sprint 71 (COM-990), 2026-10-16.

## What is wrong

Content ▸ House styles ▸ edit a style: the preview shows the real PDF inside the browser's own PDF viewer, so it comes with that viewer's toolbar. In Edge and Chrome the toolbar lets you:
- draw freehand;
- add text;
- highlight;
- print and download.

None of it is Compass's. Anything drawn on the preview is thrown away, and it never reaches the style or a document. That looks as if the preview is editable when it isn't. **Steve: remove it.**

## What people see

- The preview shows the pages and nothing else: no toolbar, no side panel.
- **Kept:** you can still scroll through the pages and zoom (pinch, or Ctrl/Cmd with + / −).
- **Gone:** the viewer's own print and download buttons. The preview isn't a document; a real export is Print preview or Export on the document itself.
- The same goes for the "preview on this document" choice.

## Technical

- `content/houseStyles/HouseStyleEditor.tsx`: the `<iframe src={preview.data}>`. Append the PDF open parameters `#toolbar=0&navpanes=0`. Chromium's viewer (Edge, Chrome) honours them; Safari's viewer has no annotation tools anyway.
  - Firefox's built-in viewer (pdf.js) ignores `toolbar=0` and keeps its editor buttons. Note that in the PR; Compass's users are on Edge.
  - If Firefox ever matters, draw the pages with pdf.js in our own canvas instead. That's a bigger change and a new dependency, so not now.
- Check whether the document Print preview, which opens the PDF in a new tab, should stay as it is. It should: there, printing and downloading are the point.
- Test (Vitest): the preview frame's `src` ends with `#toolbar=0&navpanes=0`.

## Done when

- [ ] In Edge, the house style preview shows no toolbar, and you can't draw or type on it.
