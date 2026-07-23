---
id: 01KY6YB8CJXZ83YYK7MMGPYHRD
created: 2026-07-23T07:34:24.402293Z
updated: 2026-07-23T07:34:24.402293Z
type: task
title: Render markdown in the note viewer (read mode)
assignee: steve
imported_from: linear
label: follow_up
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 26
---
Deliberately deferred in DEV-513 ("markdown render can be basic" → body shown as plain pre-wrapped text) but never tracked as an issue. In **read mode** the viewer currently shows the raw markdown source (literal `#`, `**`, `[]()` etc.) rather than rendered markup.

**Checklist**

- [ ] Render the note body as HTML in read mode (a markdown lib — e.g. `marked` / `markdown-it`)
- [ ] **Sanitise** the rendered HTML (e.g. DOMPurify) — note bodies are user content; don't inject raw HTML/scripts
- [ ] Edit mode stays raw markdown in the textarea (unchanged)
- [ ] Basic GFM coverage (headings, lists, links, code, emphasis); links open sensibly (external via the opener plugin)
- [ ] Apply in `NotePane.svelte` (the per-pane viewer)

**Done when:** in read mode a note renders its markdown (headings, lists, links, etc.) instead of showing the raw tags; edit mode is unaffected.

**Notes:** adds a frontend dep (markdown + sanitiser). Rich-editor/WYSIWYG is out of scope; this is read-mode rendering only. No new ADR expected.

---

Linear DEV-530 · M4 — Main UI · created 2026-06-20 · done 2026-06-20