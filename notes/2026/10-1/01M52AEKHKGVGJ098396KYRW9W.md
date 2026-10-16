---
id: 01M52AEKHKGVGJ098396KYRW9W
created: 2026-10-16T12:19:37.651263Z
updated: 2026-10-16T15:48:05.695888Z
type: task
title: Mermaid diagram - error on page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1011
sprint: s2ufsxd
comments:
- id: 01M52PCADZ3CJVG6DQYT7ZK32D
  author: Steve Vine
  at: 2026-10-16T15:48:05.695761Z
  text: 'Done in PR #999 (main 81b6ad98). The cause: whenever a diagram''s text wasn''t valid yet (normal while typing), Mermaid drew its own "Syntax error in text — mermaid version 11.17.2" picture at the very bottom of the page and never took it away. Now a mistake shows only Compass''s short message beside the diagram, the last good picture stays, and nothing is left at the bottom of the page. Checked in a real browser with the real Mermaid: before, the error picture was left in the page; after, nothing, and the page height doesn''t change.'
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Steve's smoke test of sprint 71 (COM-994), 2026-10-16: "I occasionally get the below error show at the bottom of the edit page when a mermaid diagram exists in a section. ax error in text / mermaid version 11.17.2"

## What is wrong

While you type a text diagram, a moment where the text isn't valid yet (half a line typed) is normal. Compass shows a short message beside the diagram, and keeps the last good picture. But Mermaid also draws its own "Syntax error in text — mermaid version 11.17.2" picture at the very bottom of the page, and never takes it away. One is left behind for every mistake, until the page is reloaded.

## What people see

- A mistake in a diagram's text shows only Compass's short message beside the diagram, as now. The last good picture stays.
- Nothing appears at the bottom of the page, however many mistakes are made along the way.

## Technical

- `content/richtext/mermaid.ts`: Mermaid's `render()` draws an error diagram into its temporary element and throws, leaving the element in `<body>` (`suppressErrorRendering` off). Set `suppressErrorRendering: true` in the config, so Mermaid removes its temporary element and just throws.
- Belt and braces: COM-1010 gives `render()` its own off-screen box and empties it after every drawing, success or failure.
- Test (Vitest, the `mermaid` package mocked): Mermaid is set up with `suppressErrorRendering`; a failing drawing leaves nothing in the page and shows Compass's message.

## Done when

- [ ] Typing a diagram with mistakes along the way never leaves "Syntax error in text" at the bottom of the page.

**Builds on COM-1010** (same files), stacked.
