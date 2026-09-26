---
id: 01M3EA3J4PH3QDM0RYBFD1D1PP
created: 2026-09-26T07:33:05.302289Z
updated: 2026-09-26T08:34:45.563648Z
type: task
title: Note editing
project: 01KY6W9951TW0904DT0GGJVGE7
number: 442
sprint: sqsolof
comments:
- id: 01M3EDMFNVYMGFKZ94EHX7Q6VT
  author: Steve Vine
  at: 2026-09-26T08:34:45.563337Z
  text: 'PR #445 covers all four points: hint only while the body is empty; Live lines take the read view''s text-wrap: pretty so paragraphs break identically; MD source loses its box; the image widget asks CodeMirror to re-measure on load so the caret lands under the image after Enter. The caret fix is reasoned from CodeMirror''s measure path and couldn''t be reproduced in Chrome (it self-heals there), so please try paste-then-Enter in the app.'
assignee: steve
priority: medium
task_status: review
tech: null
---
The text that appears on every note "/ to insert a block · drop files to attach · select text to format" should disappear as soon as you start typing the same as the "Start writing..." text.

Also, there seems to be a slight difference between the text in Read and Live mode, E.g. the first paragraph of this page wraps the text differently in each mode, screenshots below.

**Read Mode**
![CleanShot 2026-09-26 at 08.41.11@2x.png](attachments/2026/09/01M3EA3J4PH3QDM0RYBFD1D1PP/CleanShot-2026-09-26-at-08.41.11@2x.png)
**Live Mode**
![CleanShot 2026-09-26 at 08.41.42@2x.png](attachments/2026/09/01M3EA3J4PH3QDM0RYBFD1D1PP/CleanShot-2026-09-26-at-08.41.42@2x.png)
In Markdown mode, the text appears in a box, I'd rather it just appear the same background type as Read and Live modes. E.g.
![CleanShot 2026-09-26 at 08.42.35@2x.png](attachments/2026/09/01M3EA3J4PH3QDM0RYBFD1D1PP/CleanShot-2026-09-26-at-08.42.35@2x.png)

When I paste an image into the note, the image appears as the text rendering, which is correct, but when I hit return, rather than the cursor dropping down to the next line, the image renders and the cursor moves to the left of the image and I have to cursor down to get to the next empty line.