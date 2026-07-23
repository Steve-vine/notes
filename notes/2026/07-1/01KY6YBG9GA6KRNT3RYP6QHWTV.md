---
id: 01KY6YBG9GA6KRNT3RYP6QHWTV
created: 2026-07-23T07:34:32.496499Z
updated: 2026-07-23T07:34:32.496499Z
type: task
title: ADR 0010 — live editing model (shared buffers + autosave)
task_status: done
imported_from: linear
assignee: steve
label: chore
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 27
---
Pin the Obsidian-like editing model that fixes the concurrent-edit data loss (DEV-529) and supersedes DEV-515's explicit-save interaction.

**Decisions to record (agreed with Steve):**

1. **Shared in-memory document per note id** (within the main window) — panes are views of one buffer, not copies; edits propagate instantly; no divergence to clobber.
2. **Autosave, no Save/Cancel** — debounced write (~800 ms) + on pane blur/close, atomic (temp+rename). Undo is the editor's own.
3. **Keep the read/edit toggle** — read = rendered markdown (reading view, absorbs DEV-530); edit = source + autosave.
4. **External changes reload via the watcher (**DEV-508**)** — clean panes reload; local-unsaved-edits + external change → non-destructive "changed on disk" indicator (the residual guard; safety net for sync).
5. **Suppress self-writes** — ignore the watcher event our own autosave triggers (content/hash match) so the editor doesn't jump the cursor.

**Checklist**

- [ ] Write `decisions/0010-live-editing-model.md` (house format)

**Done when:** ADR 0010 is committed; it shapes the implementation brief (which resolves DEV-529 and absorbs DEV-530).

---

Linear DEV-531 · M4 — Main UI · created 2026-06-20 · done 2026-06-20