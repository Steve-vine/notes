---
id: 01KY6Y86T7CCCMP9XDVT59RQZ1
created: 2026-07-23T07:32:44.487177Z
updated: 2026-07-23T11:03:34.86897Z
type: task
title: Browse by taxonomy (Tab 1)
task_status: done
imported_from: linear
comments:
- id: 01KY6Y8FEVC6GHV73J2DHQRJ05
  author: Steve Vine
  at: 2026-07-23T07:32:53.339214Z
  text: |-
    Steve Vine · 2026-06-20:

    **Done building — in review.**

    **What was done**
    - **Backend:** indexed the note **Type into `note_values`** so every axis (incl. Type) browses through one generic path. New index queries `distinct_values` (value + count) + `notes_with_summaries`. Runtime `list_taxonomies` (axes), `taxonomy_values` (folders w/ counts, labels via the registry → raw value for free-form), `browse_notes`. Commands wired.
    - **Frontend:** `taxonomy.ts` browse wrappers; `Main.svelte` Browse tab — axis dropdown + filter; value folders (label + count) that expand to their notes; click → shared viewer.

    **Verification** — `npm run check` (0/0), fmt, clippy `-D warnings` (exit 0), `cargo test` (**39 pass**, 2 new), `npm run tauri build`. (Couldn't run the release-bundle smoke test — your `tauri:dev` session was up, and single-instance bounces a second copy; not an issue.) **Interactive browse needs your manual sign-off.**

    **Please verify** (you have a dev session running — restart it to pick up the new Rust commands): Browse tab → pick an axis (e.g. **Type**) → values with counts → expand → notes → click → opens in the viewer.

    **Decisions/scope:** browse shows values **that have notes** (empty fixed values hidden until used — MVP choice). Editing = DEV-515; splits = DEV-516; Open-in-UI = DEV-517. The Type-in-note_values index addition is preserved across reconcile/rebuild (DEV-508 guarantee intact). No new ADR.

    **PR:** https://github.com/Steve-vine/notula/pull/18 · commit `2877bf0`
    Holding the merge for your sign-off.
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 19
sprint: s6s57kv
---
Sidebar **Tab 1 — Browse by taxonomy** (`brief/ui.md`): the "many ways to organise, none of them folders" tree.

**Checklist**

- [ ] A taxonomy-axis dropdown (which taxonomy to browse) + a filter box
- [ ] The chosen axis's values render as a folder-like list; expanding a value shows the notes carrying it (the same note appears under every value it holds)
- [ ] Read IPC: list taxonomies (axes) and their values (fixed values from the registry; free-form values as distinct `note_values` from the index), and reuse `notes_with(taxonomy, value)` → note summaries
- [ ] Clicking a note opens it in the viewer (reuse DEV-513's viewer)

**Done when:** picking an axis shows its values, expanding a value lists the notes carrying it, and clicking one opens it.

**Scope:** editing, split panes, Open-in-UI are separate M4 briefs. Depends on DEV-513.

---

Linear DEV-514 · M4 — Main UI · created 2026-06-20 · done 2026-06-20