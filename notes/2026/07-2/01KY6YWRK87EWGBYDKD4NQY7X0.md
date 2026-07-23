---
id: 01KY6YWRK87EWGBYDKD4NQY7X0
created: 2026-07-23T07:43:58.056467Z
updated: 2026-07-23T11:03:35.728961Z
type: task
title: Fuzzy, typo-tolerant search ranking (Rust/nucleo)
assignee: steve
imported_from: linear
task_status: done
number: 71
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: s6nm897
label: null
---
The core M9 retrieval win: replace FTS-only ranking with a real fuzzy matcher so typos and partial words still find notes.

Today `search_notes` uses FTS5 MATCH (prefix on the last token only, no typo tolerance, no stemming).

**Plan**

* Add a Rust fuzzy matcher (nucleo-matcher).
* Rank over the existing index corpus: fetch `(note_id, title, body, note_type)` (title+body already live in `notes_fts`), fuzzy-match the query against title and body, weight **title** above body, drop non-matches, sort by score, cap results.
* Keep the FTS table maintained for now (it's the corpus store); just route ranking through the matcher. Smart-case, case/diacritic folding.
* Tests: typo'd query finds the note; title matches outrank body matches; empty/no-match returns nothing.

First M9 issue (chosen: Rust fuzzy engine, fuzzy-first). Filtering comes next.

---

Linear DEV-604 · M9 — Search & retrieval polish · created 2026-06-23 · done 2026-06-24