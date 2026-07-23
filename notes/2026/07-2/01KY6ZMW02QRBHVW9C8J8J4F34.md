---
id: 01KY6ZMW02QRBHVW9C8J8J4F34
created: 2026-07-23T07:57:07.970033Z
updated: 2026-07-23T07:57:17.397232Z
type: task
title: 'Hybrid editor: CodeMirror 6 foundation + Source mode + tri-mode wiring'
label: brief
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 106
comments:
- id: 01KY6ZN56NF4374RX6DWEYP1KM
  author: Steve Vine
  at: 2026-07-23T07:57:17.396806Z
  text: |-
    Steve Vine · 2026-06-28:

    Done — PR #94 (https://github.com/Steve-vine/notula/pull/94), landing alongside ADR 0017 (DEV-686).

    **What was built**
    - New `src/lib/Editor.svelte`: a CM6 `EditorView` bound to the shared note buffer (`handle.doc.body`). User edits flow out via `onChange` → `markEdited()` (autosave, ADR 0010); external buffer changes (changed-on-disk reload, attach splice) reconcile back in via a guarded dispatch with an `applyingExternal` flag, so there's no typing→onChange→value feedback loop. Attach (picker/paste/drop) ported onto CM transactions; exposes `insertAtCursor` / `wrapSelection` for DEV-689/690. Theme bound to the app tokens (light/dark), line wrapping, app font.
    - `NotePane`: `<textarea>` → `<Editor>`; Read/Edit button → a **Read·Live·Source** segmented control.
    - `Main`/`Pane`: per-pane mode state (`Record<…,"live"|"source">`, absence = Read), `setMode()`; `openNote` resets to Read.

    **Decisions/fixes made on the fly**
    - `Live` mode equals `Source` for now (a `previewConf` compartment is the seam DEV-688's decorations reconfigure into) — kept the brief honest rather than half-building decorations.
    - **Alt+E inside the editor** is now honoured at the window dispatcher (like `leaveEdit`) with `preventDefault()`. Two reasons: without it you could enter edit but not leave, and on macOS Option+E is a dead-key that was inserting a `´` accent. The matcher is code-based (`KeyE`), so it's robust to the dead key.
    - Segmented-control border fix: adjacent segments overlap their 1px borders (`margin-left:-1px`) and the active one raises `z-index`, so the selected Live/Source shows a full accent border (it previously lost its left edge).

    **Verification** — full lefthook gate green (`check`/`build`/`npm test` 69, `cargo fmt`/`clippy`/`test` 134). Manually verified with Steve in `tauri:dev`: lossless Source autosave, two-pane shared-buffer editing, attach insert+render, and the mode/keyboard flows.

    Out of scope (later briefs): Live decorations (DEV-688), Insert menu (DEV-689), Format menu (DEV-690), image resize (DEV-691).
---
The load-bearing integration brief for M13 (ADR 0017). Introduces CodeMirror 6 as the editing surface and the three-mode (Read / Live / Source) model. Ships a visible win — CM6 source editing with markdown highlighting — while Live-preview decorations land next (Brief 2).

## Checklist

- [ ] Add CM6 deps: `@codemirror/state`, `@codemirror/view`, `@codemirror/commands`, `@codemirror/language`, `@codemirror/lang-markdown`, `@codemirror/language-data`, `@lezer/highlight`.
- [ ] New `src/lib/Editor.svelte`: thin Svelte 5 wrapper over a CM6 `EditorView`, the single editing surface for Live + Source.
  - Binds to `handle.doc.body`: CM6 update listener writes back + calls `handle.markEdited()` (autosave path, ADR 0010).
  - Reconciles external buffer changes (changed-on-disk reload, attachment splice) back into the CM6 doc via a guarded dispatch when the incoming value differs from the view doc.
  - Ports attach affordances onto CM6: picker + paste + drop (`filesFrom`, `attachDomFile`, `referenceMarkdown` from `attach.ts`), inserting at the CM6 selection via a transaction.
  - Exposes `insertAtCursor(text)` / `wrapSelection(before, after)` for Briefs 3–4.
  - Extensions: markdown language + highlighting, app theme tokens (light/dark, M8), line wrapping, app font (DEV-601). `mode: "live" | "source"` prop — `live` may equal `source` until Brief 2.
- [ ] `NotePane.svelte`: replace the `<textarea class="edit-body">` (+ its paste/drop handlers) with `<Editor>` for both edit modes; keep title input + meta header. Render by mode.
- [ ] Tri-mode state in `Main.svelte`: `editingLeaves` `Record<string, boolean>` → `Record<string, "live" | "source">` (absence = Read); `paneMode()` helper; `openNote` resets to Read; `toggleEdit` (Alt+E) toggles Read↔Live; `setMode()` for the explicit control; Esc/`leaveEdit` → Read. Thread mode through `Pane.svelte` → `NotePane.svelte`; add a **Read / Live / Source** segmented control to the pane status bar.

## Definition of done

* `npm run check` + `npm run test` green.
* Source mode edits raw markdown; autosave persists; file matches byte-for-byte (no normalisation).
* Two panes on one note still share a buffer (ADR 0010 not regressed).
* Attach via picker/paste/drop inserts the right reference at the CM6 cursor; Read renders it.
* Read/Live/Source switch per pane; Alt+E toggles Read↔Live; Esc → Read; changed-on-disk reload works.

Out of scope (later briefs): Live decorations (2), Insert menu (3), Format menu (4), image resize (5).

---

Linear DEV-687 · M13 - Hybrid Edit Mode · created 2026-06-27 · done 2026-06-28