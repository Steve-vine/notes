---
id: 01KY708QRXEFJ1HFBAC8PAGDWN
created: 2026-07-23T08:07:59.00514Z
updated: 2026-07-23T12:24:58.684739Z
type: task
title: 'Backend: filtered browse queries (multi-axis foundation)'
assignee: steve
label: null
task_status: done
comments:
- id: 01KY708ZQB4B9DQ673GJ4KQJ6X
  author: Steve Vine
  at: 2026-07-23T08:08:07.147273Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/127

    **What was done**
    - `index.rs`: `BrowseFilter { taxonomy_id, value }`; `distinct_values(taxonomy_id, filters)` and `notes_with_summaries(filters)` compile the path to one `note_id IN (SELECT …)` set-intersection clause per nesting level (`filter_clauses` helper + `params_from_iter`). Two new tests cover filtered counts, stacked filters, contradictory paths, and the empty path.
    - `runtime.rs`: wrappers pass filters through and keep registry value labelling; the existing browse test gained a nested-path case.
    - `lib.rs`: `taxonomy_values` / `browse_notes` commands extended in place — no parallel commands, per ADR 0021.
    - `taxonomy.ts`: `BrowseFilter` type + new wrapper signatures; Main's single-axis call sites pass one-element paths.

    **Decisions made on the fly**
    - Changed the existing index methods' signatures rather than adding `_filtered` twins — internal API with a handful of call sites; twins would just be dead weight once DEV-766 lands.
    - Empty-path semantics split deliberately: `distinct_values` with `[]` ≡ today's unfiltered folder list, but `notes_with_summaries([])` returns nothing rather than every note in the vault — an unconstrained expansion is meaningless and the all-notes behaviour would be a footgun.
    - TS `BrowseFilter` keeps snake_case fields (`taxonomy_id`) matching the Rust struct — the codebase's existing IPC convention (`note_type` etc.), no serde renames.

    **Problems encountered**
    - None. cargo 147/147, clippy clean, vitest 102/102, svelte-check 0 errors, gate green. App behaviour is unchanged (single-axis browse identical) — review is mainly the SQL and semantics.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 142
sprint: sa8cznq
---
R5 of the Revamp UI milestone (parent DEV-754). Index-side support for nested browse — no UI change.

* `src-tauri/src/index.rs`: `distinct_values_filtered(taxonomy_id, filters)` and a filtered note-summaries variant — existing SQL plus one `note_id IN (SELECT note_id FROM note_values WHERE taxonomy_id=? AND value=?)` per filter; extend the existing `distinct_values_and_browse_summaries` test coverage.
* `src-tauri/src/runtime.rs`: wrappers applying registry labels (reuse the `label_for` closure).
* `src-tauri/src/lib.rs`: extend the **existing** commands — `taxonomy_values(taxonomy_id, filters: Vec<BrowseFilter>)`, `browse_notes(filters)`, `BrowseFilter { taxonomy_id, value }`. Empty filters ≡ today's behaviour.
* `src/lib/taxonomy.ts`: updated wrapper signatures; existing callers pass `[]`.

Depends on: DEV-761 (R1). Independent of the shell refactor — can land any time after the ADR.

Checklist:

- [ ] Filtered queries + tests in [index.rs](<http://index.rs>)
- [ ] Command signatures extended end-to-end
- [ ] Existing single-axis browse unchanged (callers pass [])

---

Linear DEV-765 · Revamp UI · created 2026-07-02 · done 2026-07-02