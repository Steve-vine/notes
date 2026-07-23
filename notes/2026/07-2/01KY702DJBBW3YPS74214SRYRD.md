---
id: 01KY702DJBBW3YPS74214SRYRD
created: 2026-07-23T08:04:31.947067Z
updated: 2026-07-23T09:08:57.861863Z
type: task
title: Rename .notula index dir & localStorage keys (with migration)
label: chore
number: 133
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Rename the vault-local index directory and the browser-local UI-state keys, with one-time migration so nothing visibly resets. Follows the migration policy in the ADR (DEV-734 / ADR 0020).

## Index dir `.notula/` → `.notuvia/`

The index is a disposable, rebuildable SQLite/FTS5 cache (ADR 0003), so this is low data-risk. Update the hardcoded path in: `src-tauri/src/vault.rs` (created ~26; asserted 49/95), `src-tauri/src/index.rs` (`vault.join(".notula")` ~147; create ~156), `src-tauri/src/git.rs` (gitignore entry ~182/190 + tests), `src-tauri/src/watcher.rs` (ignore-loop comments ~49/60/161), `src-tauri/src/runtime.rs` (import skip ~1359/1803).

* **Migration:** on startup, if `.notula/` exists and `.notuvia/` doesn't, rename it (or just create `.notuvia/` and rebuild — index is disposable). Leave no orphaned `.notula/` if cheap to remove; harmless if left.

## Coupled code identifiers moved here from DEV-736

Because they are tied to the `.notula` dir string (kept in one PR to avoid a split):

* `src-tauri/src/git.rs` — fn `ensure_notula_ignored` → `ensure_notuvia_ignored` (def ~176, tests ~440/455/468, and the `bare_notula_entry` test scenario) + the call site in `src-tauri/src/lib.rs` (~201).
* `src-tauri/src/runtime.rs` — local bindings / param named `notula` in `collect_importable_markdown` (~1359/1361/1569/1570/1585), renamed alongside the `.notula` path string they hold.

## localStorage `notula:*` → `notuvia:*`

Renaming silently wipes prefs unless migrated. Keys: `notula:theme` (`app.html:11`, `theme.svelte.ts:10`), `notula:paneTree` (`Main.svelte:102`, `Settings.svelte:125-126`), `notula:leftCollapsed`/`notula:rightCollapsed` (`Main.svelte:141-142`), `notula:keymap` (`keymapStore.svelte.ts:13`).

* **Migration:** one-time migrate-on-read — if a `notuvia:*` key is absent but the `notula:*` equivalent exists, copy it over (then optionally delete the old). Idempotent.

## Done when

* Fresh `.notuvia/` index built/used; existing index data not lost on upgrade.
* Theme, pane layout, panel collapse state, and keymap all survive the rename with no manual reset.
* `cargo test` + `npm run test`/`check` green.

---

Linear DEV-738 · Rebrand · created 2026-06-30 · done 2026-06-30