---
id: 01M382ZQGSAADBJ5JHTWD4P6JG
created: 2026-09-23T21:33:13.113945Z
updated: 2026-09-24T20:56:23.625321Z
type: task
title: 'UI redesign: note body typography for Read, Live and MD'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 434
sprint: sqsolof
comments:
- id: 01M3AK90T963A0G404DCC05SDX
  author: Steve Vine
  at: 2026-09-24T20:56:23.624547Z
  text: 'PR #437 open (branch feat/not-434-body-typography). Read/Live/MD typography per the design; new --reading-size token; "Start writing…" placeholder and the "/ to insert" hint line (the slash menu itself is NOT-435). Verified with svelte-check, vitest, build, and headless-Chrome lab screenshots; not yet seen in the running app.'
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
- Meta line above the title (type icon · Type · Updated date).
- Title 36px/500; reading column 780px with 64px gutters; body 16px at 1.72 line height; h2 20px/500; dash bullets; tinted code blocks; accent-bar quotes.
- "Start writing…" placeholder on an empty note; hint line "/ to insert a block · drop files to attach · select text to format" in edit modes.
- Same treatment in Read, Live (CodeMirror live preview) and MD source styling.
- Per-note width toggle still works (from the ⋯ menu).