---
id: 01KY71XXY3YVG5QYQBAQ59PW85
created: 2026-07-23T08:37:02.01983Z
updated: 2026-07-23T09:18:29.642534Z
type: task
title: OpenAPI spec for the HTTP API
comments:
- id: 01KY71Y5AMV201A8J0K9R3CBNT
  author: Steve Vine
  at: 2026-07-23T08:37:09.587585Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — built and tested

    **What was done**
    - `GET /openapi.json` serves an OpenAPI 3.1 document covering all 15 routes: `#[utoipa::path]` annotations on every handler (params, request bodies, per-status responses, bearer security), a `Modify` hook registering the bearer scheme, and a "Machine-readable spec" section in `docs/api.md`.

    **Decisions made on the fly**
    - **Schemas live in the shell, not core.** The issue sketched annotating the `ops` DTOs, but that would put a `utoipa` dependency in the deliberately Tauri-free core, and the response types don't derive cleanly anyway (`Scope`'s custom `"any"`-or-list serde, the grafted `NoteView` fields, `SearchHit`'s tuple ranges). Instead a new `api_spec.rs` holds documentation-mirror schemas — `Scope` as an untagged oneOf, the grafts as optional fields — with the drift contract stated in the module doc: the router tests pin the real wire shapes the mirrors must match.
    - The spec endpoint is unauthenticated like `/health` — it reveals shapes, never vault data, and keyless access is what makes pointing Swagger UI/codegen at it painless.
    - No `utoipa-axum`/`utoipa-swagger-ui` integration features — the document is just serialized by a plain axum route; an embedded Swagger UI would be a separate choice.

    **Problems encountered** — none; compiled and passed first run.

    **Testing** — new spec test asserts: document parses as OpenAPI 3.x, version matches the crate, every router route+method appears in `paths` (so adding an endpoint without annotating it fails CI), bearer scheme registered and referenced, key schemas present. 27 router tests total; full workspace green; clippy `-D warnings` clean.

    PR: [#226](https://github.com/Steve-vine/notuvia/pull/226)
label:
- follow_up
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 249
sprint: sx9znt9
---
Deferred from DEV-899: ship a machine-readable OpenAPI spec for the HTTP API (ADR 0031), e.g. via `utoipa` derive annotations on the handlers and DTOs in `src-tauri/src/api_server.rs` and `notuvia-core/src/ops.rs`, served at `/openapi.json`.

Deferred because the hand-written `docs/api.md` already satisfies the milestone's definition of done (a new client can go from zero to reading and writing notes), and annotating every handler/DTO is a non-trivial dependency and maintenance surface for a personal API. Worth picking up if/when a generated client or interactive explorer (Swagger UI) becomes useful — e.g. for the Online Version milestone.

---

Linear DEV-902 · Backlog · created 2026-07-07 · done 2026-07-07