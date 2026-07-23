---
id: 01KY6YCE5VSTPYVRP7Y516Z0DA
created: 2026-07-23T07:35:03.09981Z
updated: 2026-07-23T09:08:57.161707Z
type: task
title: Markdown reading view (rendered read mode)
assignee: steve
comments:
- id: 01KY6YCKXHS6490E8B4XRDKQ35
  author: Steve Vine
  at: 2026-07-23T07:35:08.977622Z
  text: |-
    Steve Vine · 2026-06-20:

    PR: https://github.com/Steve-vine/notula/pull/24 — In Review.

    Implemented the reading view (ADR 0010 read mode):
    - New `src/lib/markdown.ts` — `renderMarkdown()` parses with `marked` (GFM) and sanitises with `DOMPurify`.
    - `NotePane` read mode renders `{@html}` of the sanitised output (read-mode-only `$derived`); links are intercepted and `http(s)`/`mailto` open in the system browser via the opener plugin instead of navigating the WebView. Scoped `.markdown` styles added.
    - Edit mode unchanged (DEV-532 autosave editor). No backend change.

    Local gates all green: `npm run check`, `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`, `cargo test`, `npm run tauri build`.

    Holding for your manual sign-off (markdown renders in read mode; edit still autosaves; external link opens in the browser, pane doesn't navigate) + CI before merge. Resolves DEV-530.
- id: 01KY6YCVZ9EG083GJHYHAX4WBK
  author: Steve Vine
  at: 2026-07-23T07:35:17.22503Z
  text: |-
    Steve Vine · 2026-06-20:

    Pushed a fix for the two reading-view anomalies you found:
    - **Newlines swallowed** — a single newline was being joined per standard markdown. Enabled marked's `breaks` (+ explicit `gfm`) so a line break in the editor renders as one in read mode (notes are short fragments where that's the intent).
    - **Tables "not rendering"** — they *were* in the DOM but unstyled (no borders), so they read as run-together text. Added scoped `table`/`th`/`td` styling.

    `npm run check` + `npm run tauri build` green. Ready for another look.
label: brief
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 29
---
Implements ADR 0010's read mode = rendered markdown (the "reading view"). Absorbs DEV-530.

**Checklist**

- [ ] Render the note body as HTML in **read** mode (markdown lib — e.g. `marked`)
- [ ] **Sanitise** the output (e.g. DOMPurify) — note bodies are user content
- [ ] Edit mode stays source (the autosave editor from DEV-532)
- [ ] Basic GFM (headings, lists, links, code, emphasis); external links open via the opener plugin
- [ ] Apply in `NotePane.svelte`

**Done when:** in read mode a note renders its markdown; edit mode is the source editor.

**Resolves:** DEV-530. Implements ADR 0010 (reading view). Depends on DEV-532.

---

Linear DEV-533 · M4 — Main UI · created 2026-06-20 · done 2026-06-20