---
id: 01KY6Y6NDHKGG36JV3CPX5P1W7
created: 2026-07-23T07:31:53.905401Z
updated: 2026-07-23T07:32:03.144829Z
type: task
title: Scope-driven taxonomy selectors in capture
task_status: done
label: brief
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 16
comments:
- id: 01KY6Y6YE8SADCG0TBN9Z02M5E
  author: Steve Vine
  at: 2026-07-23T07:32:03.144461Z
  text: |-
    Steve Vine · 2026-06-20:

    **Done building — in review.**

    **What was done**
    - **Backend:** `VaultRuntime` loads `TaxonomyRegistry` at vault open. New **`applicable_taxonomies(type)`** command → `applicable_for(type)` minus the Type taxonomy (first IPC surface for the registry, deferred from DEV-483). `NewNote` gains a `values` map written verbatim into frontmatter by `save_note` (reserved core keys protected).
    - **Frontend:** `lib/taxonomy.ts`; `Capture.svelte` fetches applicable taxonomies on Type change and renders per-def controls — fixed-single `<select>`, fixed-multi checkboxes, free-form text (single / comma-separated multi). Selections flow into `save_note`.

    Fresh-vault behaviour: Memo → just Type; Task → + Task Status; Project → + Project Status; switching Type re-renders live.

    **Verification** — `npm run check` (0/0), fmt, clippy `-D warnings` (exit 0), `cargo test` (**34 pass**, 2 new: taxonomy-value save + `applicable_taxonomies` by Type), `npm run tauri build`; app launches. **Interactive selector flow needs your manual sign-off** (GUI automation blocked).

    **Please verify** via `npm run tauri:dev`: capture as **Task** → a Task Status selector appears → pick a value + Save → the note's frontmatter carries it and it's searchable/browsable; switching Type live re-renders selectors.

    **Decisions / scope:** `project` link **deferred to M5** — filed **DEV-512** (it's a relationship, not a taxonomy). Free-form values write to the note only (pool-growth/autocomplete = later). No live taxonomy reload (loaded at vault open). No new ADR.

    **PR:** https://github.com/Steve-vine/notula/pull/16 · commit `cb39b96`
    Holding the merge for your sign-off.
---
Render the per-taxonomy selectors in the capture window, driven by the note's Type (ADR 0005, `brief/ui.md`).

**Checklist**

- [ ] Expose the taxonomy registry to the frontend (a command, e.g. `applicable_taxonomies(type)` / `list_taxonomies`) — the IPC surface deferred from DEV-483
- [ ] Render a selector **per applicable taxonomy** for the current Type, re-evaluated live when Type changes: Memo → `any`-scoped; Task → + Task Status + the `project` link; Project → + Project Status
- [ ] Single vs multi (`multi`); fixed (closed dropdown) vs free-form (text input; full autocomplete/normalisation is a later polish, ADR 0005)
- [ ] Include selected taxonomy values + `project` link in the `save_note` payload → written to frontmatter

**Done when:** the capture window shows the correct selectors for the chosen Type, and selected values are persisted into the note's frontmatter (and indexed).

**Scope:** free-form autocomplete + canonical-display normalisation are deferred (ADR 0005 open items / M7). Depends on DEV-510.

---

Linear DEV-511 · M3 — Capture window · created 2026-06-19 · done 2026-06-20