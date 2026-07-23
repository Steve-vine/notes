---
id: 01KY6ZNJJ4RMNDFQPH8S0N8R0B
created: 2026-07-23T07:57:31.076283Z
updated: 2026-07-23T11:03:34.327686Z
type: task
title: 'Hybrid editor: Live preview decorations'
comments:
- id: 01KY6ZNVHVWXBN1YJAP0EJD0NT
  author: Steve Vine
  at: 2026-07-23T07:57:40.282801Z
  text: |-
    Steve Vine · 2026-06-28:

    Done — PR #95 (https://github.com/Steve-vine/notula/pull/95).

    **What was built**
    - `src/lib/livePreview.ts`: a `StateField` of decorations (hide-off-cursor markers + reveal-on-cursor, inline styling, and widgets for images / horizontal rules / GFM tables / task checkboxes / bullets, plus blockquote bar and fenced-code tint). Buffer stays literal markdown — display-only.
    - `Editor.svelte`: enabled GFM in the markdown parser (strikethrough/tables/task lists) and mounted `livePreview` for Live via the `previewConf` compartment.

    **Decisions / fixes made on the fly (from live review with Steve)**
    - **`StateField`, not `ViewPlugin`.** First cut used a `ViewPlugin`; once a note contained a table, building a *block* decoration from a plugin threw and blanked **both** Live and Source (same editor instance) — block decorations are only legal from a field. Moved everything to a `StateField` over the whole (short) note.
    - **Tables editable**: the rendered table is a block widget; the caret can't land inside a block-replaced range, so the widget handles its own click (`EditorView.findFromDOM`) and drops the caret into the source, which reveals the block.
    - **Image drag bug**: dragging an inline image dropped its resolved `notula-attachment://…` URL into the note — fixed by making the widget `<img>` non-draggable.
    - **Link affordance**: links were styled text with an I-beam and fuzzy hit area — added pointer cursor + hover highlight and more tolerant hit detection; click opens (web/mail → browser, attachment → `open_attachment`), stepping aside when the cursor is on that line.

    **Verification** — full lefthook gate green (check/build/npm test 69, cargo fmt/clippy/test 134) + manual pass in `tauri:dev`.

    **Follow-up filed**: viewport-scoped decorations for large notes (tech-debt, parent-linked) — the field currently decorates the whole doc, fine for short notes.

    Deferred to their own briefs: highlight `==` (DEV-690), image resize (DEV-691).
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 107
sprint: st23znm
---
The big visual brief: the CM6 live-preview decoration layer that makes **Live** mode look like the rendered result while editing (Obsidian-style), built on Brief 1's `Editor.svelte`.

## Checklist

- [ ] CM6 `ViewPlugin` + `Decoration`s driven by the Lezer markdown syntax tree (`syntaxTree`).
- [ ] Hide/dim syntax markers (`#` heading marks, `*`/`_` emphasis/strong marks, `~~`, backticks, link/image brackets & URLs) on lines **away from the cursor/selection**; reveal the raw syntax when the cursor enters that node's line (reveal-on-cursor).
- [ ] Inline styling: headings sized, bold/italic/strikethrough/inline-code/highlight rendered.
- [ ] Inline image widgets for `![alt](attachments/…)` via a `WidgetType`, resolved with `convertFileSrc(ref, "notula-attachment")` (reuse the read-view resolution).
- [ ] Links shown as clickable rendered text; open in OS browser / `open_attachment` like the read view.
- [ ] Lists, blockquotes, horizontal rules, tables rendered; fenced code blocks styled.
- [ ] Performance: only decorate the visible range; recompute on doc/selection change.

DoD: Live mode reads like the rendered note, edits stay in raw markdown (lossless), cursor reveals syntax for the active construct, images show inline. Source mode unaffected.

---

Linear DEV-688 · M13 - Hybrid Edit Mode · created 2026-06-27 · done 2026-06-28