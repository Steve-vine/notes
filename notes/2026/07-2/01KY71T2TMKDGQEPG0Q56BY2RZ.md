---
id: 01KY71T2TMKDGQEPG0Q56BY2RZ
created: 2026-07-23T08:34:55.956122Z
updated: 2026-07-23T11:03:34.812798Z
type: task
title: API read endpoints — search, get note, list taxonomies
task_status: done
assignee: steve
comments:
- id: 01KY71TCRMHQMN42G67GK04NC4
  author: Steve Vine
  at: 2026-07-23T08:35:06.132182Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — built and tested

    **What was done**
    - `GET /notes?query=<q>` — delegates to `VaultRuntime::search` (core FTS5 + fuzzy ranking, inline `key:value` filters), returning the `SearchHit` list exactly as MCP's `search_notes` does.
    - `GET /notes/{id}` — the full `NoteView` with comments and blocked_by/blocks grafted onto the JSON, mirroring MCP's `get_note` implementation line for line. Malformed ULID → 400, unknown id → 404.
    - `GET /taxonomies` — parity with MCP `list_taxonomies`.
    - Sealed notes (ADR 0028): view reports `encrypted: true, locked: true` with empty body; search snippets are empty by construction — covered by a dedicated leak test.

    **Decisions made on the fly**
    - `AppState` in core now wraps the runtime slot in an `Arc` (`Arc<Mutex<Option<VaultRuntime>>>`) so the router holds the very slot the Tauri commands use — the API tracks vault relocations automatically. All existing usage sites compile unchanged via deref.
    - The scope's DEV-891 dirty-flag item turned out unnecessary: the app's watcher already reloads the registry into this shared runtime in-process (DEV-553), so taxonomy freshness comes free. Noted in a code comment.
    - Handlers run core calls on the blocking pool via a `with_runtime` helper; a no-vault state maps to a new `503 unavailable` envelope (retryable, unlike a 500) — a small addition to the DEV-894 status contract.
    - Search-hit taxonomy values: `SearchHit` doesn't carry them and MCP doesn't return them either — parity kept; adding them would be a core change for both surfaces (follow-up if wanted).

    **Problems encountered** — one test assumption: the seeded registry has no `tags` taxonomy (it's `type`/`task_status`/`project_status`/`priority`/`assignee`); assertion fixed.

    **Testing** — 10 router tests (6 new): search hit, full view with comments, 400/404 mapping, sealed-note leak test, seeded registry, 503 without a vault. Full workspace green; clippy `-D warnings` clean.

    PR: [#221](https://github.com/Steve-vine/notuvia/pull/221)
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 242
sprint: s70xwrb
---
The retrieval surface of the HTTP API (ADR 0031, DEV-889), mirroring the MCP read tools (`search_notes`, `get_note`, `list_taxonomies`) on the DEV-894 chassis.

## Scope

- [ ] `GET /notes?query=<q>` — same fuzzy/typo-tolerant search as the app and MCP (core FTS5 + ranking, inline `key:value` filters supported); returns hits with id, title, type, snippet, taxonomy values
- [ ] `GET /notes/{id}` — full note view: title, body, type, dates, taxonomy values, relationships, comments, dependencies (parity with MCP `get_note`)
- [ ] `GET /taxonomies` — taxonomy registry: id, labels, allowed values, scope (parity with MCP `list_taxonomies`); picks up external `taxonomies.yaml` changes like the MCP server does (DEV-891 dirty-flag pattern)
- [ ] **Encrypted bodies stay sealed** (ADR 0028/0030): searchable/retrievable by title and metadata only, body omitted with an `encrypted: true` marker
- [ ] Integration tests against a temp vault (spin up router with a test `VaultRuntime`)

## Definition of done

`curl` with a key can search the vault, fetch a full note, and list taxonomies; responses match what MCP returns for the same vault; sealed notes leak nothing.

---

Linear DEV-895 · API Server · created 2026-07-07 · done 2026-07-07