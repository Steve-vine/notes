---
id: 01KY71W2C1CER555THHDZFXEZT
created: 2026-07-23T08:36:01.025326Z
updated: 2026-07-23T11:03:35.743455Z
type: task
title: API taxonomy write endpoints — create taxonomy, add/update values
assignee: steve
comments:
- id: 01KY71WCRYAVEBNQ8ZKN2Q6FNY
  author: Steve Vine
  at: 2026-07-23T08:36:11.678104Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — built and tested

    **What was done**
    - `POST /taxonomies` — create a user taxonomy with optional type scope and initial pool; `201` + the persisted definition re-read from the registry. System ids refused by core validation (ADR 0009/0023) — test-covered with `type`.
    - `POST /taxonomies/{id}/values` — append a value; id derives from the label when omitted ("In Between" → `in_between`); order continues the pool. Built-in pools like `task_status` accept edits as user overrides (ADR 0012) — test-covered.
    - `PATCH /taxonomies/{id}/values/{value_id}` — label/colour/is_done/hidden in place; value ids stable so frontmatter never changes.

    **Decisions made on the fly**
    - Completed the single-sourcing: taxonomy write rules (value id validation/derivation via `slug_from_label`, the value patch semantics, `named_taxonomy`) moved into `notuvia-core/src/ops.rs`; MCP's three taxonomy impls are now thin delegations. **The full 14-tool MCP surface is now backed by one shared core implementation.**
    - Unknown taxonomy and unknown value id map to 404 (`WriteError::NotFound`); malformed value ids to 400 — same typed-error mapping as the note writes.

    **Problems encountered** — none; all 26 router tests passed first run.

    **Testing** — 4 new router tests: full create→add→patch lifecycle with registry round-trip; system-id rejection; 404/400 error mapping; built-in pool value append. Full workspace green (MCP's 18 tests unchanged against the refactor); clippy `-D warnings` clean.

    PR: [#224](https://github.com/Steve-vine/notuvia/pull/224)
task_status: done
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 245
sprint: s70xwrb
label: null
---
Taxonomy mutation over the HTTP API (ADR 0031, DEV-889), mirroring the MCP tools `create_taxonomy`, `add_taxonomy_value`, `update_taxonomy_value`. Independent of the notes routers — only needs the DEV-894 chassis (but sequence, don't stack, per ways-of-working).

## Scope

- [ ] `POST /taxonomies` — create a user taxonomy: id, name, multi/single-value, free vs fixed pool, optional scope, initial values (user taxonomies only — system taxonomies stay code-authoritative, ADR 0009/0023)
- [ ] `POST /taxonomies/{id}/values` — add a value to a pool: label, optional id/colour/is_done (ADR 0005 value objects)
- [ ] `PATCH /taxonomies/{id}/values/{value_id}` — edit label, colour, done flag, hidden in place
- [ ] Writes go through core so `taxonomies.yaml` stays the on-disk source of truth (ADR 0009) and the registry/index reconcile as in the app
- [ ] Integration tests, including rejection of system-taxonomy edits

## Definition of done

A remote client can create user taxonomies and manage their value pools with parity to MCP, and the app UI reflects the changes.

---

Linear DEV-898 · API Server · created 2026-07-07 · done 2026-07-07