---
id: 01KY6ZQ7XD53NQWY85E122WQMG
created: 2026-07-23T07:58:25.70997Z
updated: 2026-07-23T09:08:57.697772Z
type: task
title: 'Hybrid editor: image resizing'
assignee: steve
label: brief
task_status: done
number: 110
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Image resizing via the Obsidian-compatible width syntax (ADR 0017): `![alt|width](attachments/…)`.

## Checklist

- [ ] `markdown.ts`: parse a trailing `|width` (and optional `|wxh`) from the image alt; emit `width`/`height` (or inline style) on the `<img>` in `attachmentImageHtml` / `renderMarkdown`. Unit-test the parse (pure function — fits the existing node test setup).
- [ ] Read view: render embedded images at the specified width.
- [ ] Live view (Brief 2 image widget): render at width **and** provide drag-to-resize handles that rewrite the `|width` back into the markdown reference (lossless round-trip).
- [ ] Sensible bounds (min width, clamp to pane width).

DoD: an embedded image can be resized by drag in Live mode; the width persists as `![alt|width](ref)` in the file and renders at that width in Read + Live. No new on-disk machinery (consistent with ADR 0015).

---

Linear DEV-691 · M13 - Hybrid Edit Mode · created 2026-06-27 · done 2026-06-28