---
id: 01M1BEJZTKW45WEK7FPYZ2V1XD
created: 2026-08-31T08:22:18.195769Z
updated: 2026-08-31T16:38:26.731301Z
type: task
title: TOC different styles
project: 01KY6W9951TW0904DT0GGJVGE7
number: 411
sprint: segj1dz
comments:
- id: 01M1CAYTFM3JTE8PWAS4SQSZJJ
  author: Steve Vine
  at: 2026-08-31T16:38:06.065104Z
  text: |-
    PR #406 (brief-411-toc-different-styles).

    Cause: [[toc]] emits the same markup from both renderers so one stylesheet dresses both, but two of the read pane's own rules out-specified it — a Svelte scope class lands on .markdown, so `.markdown a` painted TOC entries as accent-coloured underlined links, and `.markdown ol` stacked the read view's 1.4rem list indent on top of the outline's own per-layer indent.

    Fix: entries take the body text colour with no underline, and hovering one tints the whole line (theme.css, shared by both views); NotePane repeats the exception for nav.toc a / nav.toc ol where the winning rules live; livePreview drops its now-duplicate hover rule.

    Verified by measurement in a throwaway lab (read render + a real EditorView side by side, read CSS extracted with the scope class so specificity matched the app): before, read entries were rgb(122,162,255) at li left 50.25px; after, both views are rgb(232,233,236) at 29.25px with no underline.
assignee: steve
priority: medium
task_status: review
---
The TOC has a different look in Live view than it does in read view. I prefer the live view look, can read view use the same format and style.