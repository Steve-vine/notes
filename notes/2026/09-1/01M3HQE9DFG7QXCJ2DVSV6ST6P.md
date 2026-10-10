---
id: 01M3HQE9DFG7QXCJ2DVSV6ST6P
created: 2026-09-27T15:23:51.599623Z
updated: 2026-10-10T16:58:41.396874Z
type: task
title: 'Maths: inline $…$ and block $$…$$ (KaTeX)'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 458
sprint: s9peyxr
comments:
- id: 01M4KC17K8WNN5MCTD6T1MN218
  author: Steve Vine
  at: 2026-10-10T16:58:40.103962Z
  text: |-
    Done in PR #516 (branch brief-458-katex-maths).

    What was done: $x$ inline, $$ x $$ one-line display, and $$ blocks (a line opening $$ to the first line ending $$) render with KaTeX in Read and Live. Shape rules are pandoc's, in src/lib/math.ts and shared by both views: opener followed by a non-space, closer after a non-space and not before a digit, never across a line, so "$5 and $6", "US$5", escaped \$ and code spans stay text. Read: marked block and inline extensions; blank lines inside a block are kept as the writer's. Live: Lezer MathBlock leaf and InlineMath element (no emphasis parsing inside TeX), rendered as widgets off-cursor through the read renderer; cursor inside reveals the source. KaTeX's stylesheet and fonts ride in the bundle. New markdownSyntax.test.ts parses with the Live editor's parser and asserts the nodes.

    Decisions: KaTeX is imported statically (about 280 KB before gzip) so rendering stays synchronous inside marked; errors render as red source rather than breaking the note (throwOnError off). An unclosed $$ in Live is parsed to the end of its container like an unclosed code fence, but it is shown as plain source rather than rendered, so a half-typed formula never swallows the note into a render.

    Not run in the app: a visual pass is owed (inline, block, block inside a quote, prices, Live leave/enter the line, dark mode).
assignee: steve
label:
- feature
priority: low
task_status: review
tech: null
---
Split from NOT-450. `$E = mc^2$` and `$$ … $$` blocks render as literal text in both views. Would need KaTeX (or similar) in the read renderer and a Live widget for the block form, plus its stylesheet and fonts in the bundle.