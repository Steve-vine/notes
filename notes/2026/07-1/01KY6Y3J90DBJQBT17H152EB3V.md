---
id: 01KY6Y3J90DBJQBT17H152EB3V
created: 2026-07-23T07:30:12.384753Z
updated: 2026-07-23T11:00:28.783797Z
type: task
title: SQLite + FTS5 index with rebuild
comments:
- id: 01KY6Y3TR23P3CCZ34PPBDWC9A
  author: Steve Vine
  at: 2026-07-23T07:30:21.057922Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done** — new `src-tauri/src/index.rs` (`pub mod index`):
    - Disposable SQLite/FTS5 index at `vault/.notula/index.sqlite`. **Schema:** `notes`, `note_values` (applied taxonomy values), `edges` (`project` link), `notes_fts` FTS5 over title+body.
    - `rebuild` drops+recreates the schema, walks `notes/` recursively, `Note::parse`s each (bad files skipped + warned), repopulates in a transaction.
    - Queries: `search` (FTS5 ranked), `notes_with(taxonomy, value)` (browse), `children_of(project)` (edge).
    - Title read from frontmatter `title:` (added to `brief/data-model.md`); added `Note::frontmatter_entries()` so the indexer can walk taxonomy keys.

    **Verification** — verbatim CI commands pass: fmt, clippy `-D warnings`, `cargo test` (**25 lib tests**, 5 new), `npm run tauri build`. Tests: title+body search, taxonomy filter, project edge, malformed file skipped with warning, and the **rebuild-from-files guarantee** (delete DB → rebuild → identical results). Backend-only; nothing interactive.

    **Scope guard:** no definition storage (registry serves those, M4); **file-watch reconcile deferred to a follow-up** (will file after merge); fuzzy ranking = M7; only `project` edge. No new ADR (implements ADR 0003).

    **PR:** https://github.com/Steve-vine/notula/pull/12 · commit `c98c744`
    Per your instruction I'll merge once CI is green, then file the file-watcher follow-up.
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 9
sprint: svnk3dy
---
Build the derived index and the load-bearing rebuild path (ADR 0003, `brief/storage-architecture.md`).

**Checklist**

- [ ] SQLite schema: notes, taxonomy values, edges, FTS5 virtual table
- [ ] Indexer walks the tree and populates from frontmatter + body
- [ ] Full rebuild (delete `.notula/index.sqlite` + repopulate)
- [ ] FTS5 search query path (titles + bodies)
- [ ] Taxonomy-filter query (powers the Tab 1 browse tree)

**Done when:** deleting the DB and rebuilding reproduces full search + taxonomy-browse results from the files alone.

Depends on: DEV-482, DEV-483.

---

### Agreed approach (planned 2026-06-19)

* **Title** = frontmatter `title:` key (also added to `brief/data-model.md`).
* **Index scope:** notes + applied taxonomy values + edges + FTS5 — **not** taxonomy definitions (registry serves those until M4).
* **File-watch incremental reconcile deferred** to a parent-linked follow-up; this brief delivers the full rebuild.
* **Dep:** `rusqlite` (bundled, FTS5). New `src-tauri/src/index.rs` (`pub mod`): schema (`notes`, `note_values`, `edges`, `notes_fts`), `Index::open/rebuild` (walk `notes/`, `Note::parse` each — bad files skipped with warnings — populate in a transaction), queries `search` / `notes_with` / `children_of`.
* Backend library + tests (no IPC/UI; search/browse wired in M4).

**Scope guard:** no definition storage, no file watcher, no fuzzy ranking (M7), only the `project` edge. No new ADR (implements ADR 0003).

---

Linear DEV-484 · M2 — Storage & file handling · created 2026-06-19 · done 2026-06-19