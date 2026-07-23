---
id: 01KY6YBW0H5HJPT3G80YNPG55E
created: 2026-07-23T07:34:44.497348Z
updated: 2026-07-23T12:24:58.802165Z
type: task
title: 'Live editing: shared per-note buffer + autosave'
task_status: done
assignee: steve
comments:
- id: 01KY6YC2YZAN5B87BN6C0PVCDD
  author: Steve Vine
  at: 2026-07-23T07:34:51.61465Z
  text: |-
    Steve Vine · 2026-06-20:

    PR: https://github.com/Steve-vine/notula/pull/23 — In Review.

    Implemented the shared per-note buffer + autosave (ADR 0010 core):
    - New `src/lib/noteDocs.svelte.ts` — reference-counted, per-window store keyed by note id. `acquire`/`release` share one `DocHandle` ($state buffer); `markEdited` debounces (~800ms) an autosave via `update_note`; the last release flushes pending edits.
    - `NotePane.svelte` binds title/body to the shared handle (two panes on the same note share one buffer → live cross-pane reflection), autosaves on input, Save/Cancel removed, read/edit toggle retained.
    - No backend change.

    Local gates all green: `npm run check`, `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings`, `cargo test`, `npm run tauri build`.

    Holding for your manual sign-off (two panes in sync + autosave persists with no Save button; DEV-529 repro shows no clobber) + CI before merge.
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 28
sprint: s6s57kv
---
Core of ADR 0010 and the structural fix for the concurrent-edit data loss (DEV-529). Today each `NotePane` holds its **own** copy of a note and saves the whole thing back (load-modify-write, last-write-wins) → two panes editing the same note clobber. Replace that with **one shared in-memory document per note id** (panes are views, not copies) + **autosave** (no Save/Cancel). Frontend-only — the existing `update_note` command (DEV-515) is the write path.

**Done when:** the same note edited in two panes stays in sync and autosave persists one consistent result (DEV-529 gone); edits persist without a Save button.

## Approach

* **New** `src/lib/noteDocs.svelte.ts` — a per-main-window shared-document manager (Svelte 5 runes module):
  * `class DocHandle { id; doc = $state<NoteDoc>(…); refs; timer }` where `NoteDoc = { id, title, body, note_type, updated, loaded, error }`. On create, loads via `loadNote`.
  * `acquire(id)` — returns the existing handle (shared) or creates + loads one; `refs++`. `release(handle)` — `refs--`; at 0, flushes any pending save then drops from the map.
  * `markEdited(handle)` — debounce ~800 ms → `flush()`. `flush()` → `updateNote(id, title || null, body)`, guarded by `loaded`; surfaces errors onto `doc.error`.
  * Module-level `Map<string, DocHandle>` is the shared store.
* `NotePane.svelte` — bind title/body to the shared handle (two panes on the same id share one $state buffer → live cross-pane reflection). `oninput` → `markEdited`. Keep the per-pane read/edit toggle; **remove Save/Cancel**. Acquire on note change, release (flush) on change/destroy.
* **No backend / Rust change** — `update_note` already writes atomically + reconciles.

## Scope guard

Markdown reading view = DEV-533; external-change reload + "changed on disk" guard + self-write suppression = DEV-534. This brief is shared buffer + autosave only. Supersedes DEV-515's Save/Cancel.

## Verification

`npm run check`; `cargo fmt --check` / `clippy -D warnings` / `cargo test`; `npm run tauri build`. Manual sign-off: two panes on the same note stay in sync + autosave persists with no Save button; DEV-529 repro shows no clobber.

---

Linear DEV-532 · M4 — Main UI · created 2026-06-20 · done 2026-06-20