---
id: 01KY6YKXQETY4RFWCYRKPQ78KP
created: 2026-07-23T07:39:08.398165Z
updated: 2026-07-23T11:00:28.744438Z
type: task
title: Taxonomy value rename / merge with reindex
assignee: steve
comments:
- id: 01KY6YM3V1P58KNY64ADYX9R52
  author: Steve Vine
  at: 2026-07-23T07:39:14.656726Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/40 — In Review.

    Rename/merge a taxonomy value, rewriting every referencing note + the pool + browse, with a touched-note count. Backend `repoint_value` (via `Index::notes_with`, scalar/sequence + dedupe, per-note atomic write + self-write guard + reconcile) under `rename_taxonomy_value`/`merge_taxonomy_value` (validate, update pool, persist/reload; system + unknown rejected). UI: a ⋯ menu per existing value (Rename… / Merge into …) acting immediately then reopening the editor with "N notes updated".

    Gates green: 49 cargo tests (rename/merge: rewrite, dedupe, pool, count, rejects), 47 vitest, `npm run check` clean, `clippy -D warnings`, `npm run tauri build`.

    Holding for your manual sign-off + CI before merge. That's the last core M6 brief — remaining are DEV-552 (validation surfacing) and DEV-553 (hand-edit reload).
imported_from: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 42
sprint: sdge8g4
---
The ADR 0005 "bulk rename" concern: renaming or merging a taxonomy **value** must rewrite the notes that reference it (frontmatter) and reindex — links between notes are by id and untouched (ADR 0006), only taxonomy keys/labels need rewriting.

**Checklist**

- [ ] Rename a value id across all notes carrying it (rewrite frontmatter, format-preserving where possible) + update the value pool + reindex.
- [ ] Merge value A into B: repoint all notes from A→B (dedupe within a note), drop A from the pool, reindex.
- [ ] Report how many notes were touched; atomic-ish (per-note atomic writes; tolerate partial completion + resumable, or do it in one pass with clear error reporting).
- [ ] Rust tests over a small vault.

**Done when:** renaming/merging a taxonomy value updates every referencing note and the browse tree, with a count of affected notes. Depends on DEV-548. Implements ADR 0005's rename concern (no new ADR).

---

Linear DEV-551 · M6 — Taxonomy · created 2026-06-21 · done 2026-06-21