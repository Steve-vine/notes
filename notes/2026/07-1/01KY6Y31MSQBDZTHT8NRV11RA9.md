---
id: 01KY6Y31MSQBDZTHT8NRV11RA9
created: 2026-07-23T07:29:55.353732Z
updated: 2026-07-23T11:04:51.834922Z
type: task
title: Taxonomy definitions loader
comments:
- id: 01KY6Y3B0A4P1SNTJ7PM1XZ5HB
  author: Steve Vine
  at: 2026-07-23T07:30:04.937657Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done** — new `src-tauri/src/taxonomy.rs` (`pub mod taxonomy`):
    - `Scope { Any, Type(NoteType) }` (custom (de)serialize), `TaxonomyValue` (id/label/order/colour?/is_done?), `TaxonomyDef`.
    - `system_taxonomies()` — Type / Task Status / Project Status as **code constants** (app-owned, ADR 0009), per data-model.md.
    - `TaxonomyRegistry::load(vault) -> (registry, warnings)` — system from code, merged with user defs parsed **leniently** from `taxonomies.yaml`: bad entries skipped, file `system:` entries ignored, duplicate ids skipped — each with a warning; never hard-fails. Comment-only/absent file → system-only, no warnings.
    - `applicable_for(note_type)` resolves by scope; `get` / `all`.

    **Verification** — verbatim CI commands pass: fmt, clippy `-D warnings`, `cargo test` (**20 lib tests**, 6 new), `npm run tauri build`. Backend-only; nothing interactive.

    **Note (process):** a first test run failed 3 tests — my `\n\`-continuation string literals stripped the YAML indentation. Switched the test fixtures to raw string literals; all green. (note.rs's earlier sample only worked because its keys had no indentation.)

    **Scope guard:** index load = DEV-484; no IPC/UI (M3/M4); `project` link is a relationship (ADR 0006), not a taxonomy. No new ADR (implements ADR 0005 + 0009).

    **PR:** https://github.com/Steve-vine/notula/pull/11 · commit `0589815`
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 8
sprint: svnk3dy
---
Load `taxonomies.yaml` as the definition source of truth and expose it (ADR 0005, `brief/data-model.md`; refined by ADR 0009).

**Checklist**

- [ ] Parse the taxonomy definition schema (id, name, multi, allow_user_values, scope, system, values[])
- [ ] System taxonomies (Type, Task Status, Project Status) guaranteed present — **from code** (ADR 0009), not the file
- [ ] Per-taxonomy value pools, with value objects (id, label, order, colour?, is_done?)
- [ ] Resolve a note's applicable taxonomies by Type/scope; expose definitions to the app

**Done when:** definitions load from `taxonomies.yaml`, system taxonomies are guaranteed present, and the app can resolve which taxonomies apply to a note of a given Type.

---

### Agreed approach (planned 2026-06-19)

* **Malformed entries: lenient** — load valid user taxonomies, skip bad ones, return collected warnings; system taxonomies always load. **Backend library only** (no IPC; selectors are M3/M4).
* **New** `src-tauri/src/taxonomy.rs` (`pub mod`): `Scope { Any, Type(NoteType) }` (custom (de)serialize), `TaxonomyValue`, `TaxonomyDef`, `system_taxonomies()` (the 3 system defs per data-model), `TaxonomyRegistry::load(vault) -> (registry, warnings)` (system from code + per-entry user parse; ignore file `system:true`, skip dup/bad ids with warnings), `applicable_for(note_type)`, `get`, `all`.
* No new deps.

**Scope guard:** index load = DEV-484; `project` link is a relationship (ADR 0006), not a taxonomy; free-form pool growth + key normalisation = M3. No new ADR (implements ADR 0005 + 0009).

---

Linear DEV-483 · M2 — Storage & file handling · created 2026-06-19 · done 2026-06-19