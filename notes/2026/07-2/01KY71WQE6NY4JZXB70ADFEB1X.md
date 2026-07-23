---
id: 01KY71WQE6NY4JZXB70ADFEB1X
created: 2026-07-23T08:36:22.598038Z
updated: 2026-07-23T09:18:24.268043Z
type: task
title: API documentation + client examples
label:
- brief
task_status: done
assignee: steve
comments:
- id: 01KY71WYFM29S8V9ND7S6Q774G
  author: Steve Vine
  at: 2026-07-23T08:36:29.812504Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — written and cross-checked

    **What was done**
    - `docs/api.md` in the house style of `docs/mcp-server.md`: getting started (key → enable → first `curl`), auth, LAN exposure with the no-TLS caveat, the error envelope + status table, encrypted-note behaviour, and the full 15-route endpoint reference with request/response shapes and worked `curl` examples (patch semantics, sprint replacement, taxonomy value derivation all spelled out).
    - Recipes: a `notuvia-capture` shell script, an iOS Shortcuts phone-capture walkthrough over the LAN binding, and a filtered task-list one-liner.
    - README section pointing at the doc, alongside the MCP one.

    **Decisions made on the fly**
    - **OpenAPI: deferred**, filed as DEV-902 (`follow-up`, parent-linked here) per the brief's instruction not to expand. The markdown reference satisfies the DoD; `utoipa` annotations earn their keep when a generated client or Swagger UI has an actual consumer (Online Version milestone territory).
    - One recipe was corrected against the code: the search parser has no negation syntax (`-status:done` would fall back to free text), so the review recipe uses positive filters with a pointer to `GET /taxonomies` for valid values.

    **Problems encountered** — none.

    **Testing** — docs-only; claims cross-checked against the implementation (query parser, error mapping, endpoint shapes all verified in `api_server.rs` / `ops.rs` / `index.rs`).

    PR: [#225](https://github.com/Steve-vine/notuvia/pull/225)
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 246
sprint: s70xwrb
---
Make the HTTP API usable by someone (or something) that didn't build it (ADR 0031, DEV-889). Mirrors the MCP milestone's "bundling + client docs" step (DEV-882).

## Scope

- [ ] `docs/api.md` — full endpoint reference: auth (bearer key from Settings → API), base URL/port, every endpoint with request/response examples, the error envelope, patch semantics, encrypted-note behaviour
- [ ] Getting-started walkthrough: enable the server, create a key, first `curl`
- [ ] Client examples: `curl` for each operation group; one small end-to-end script (e.g. capture-a-note from the command line); an example for a phone-friendly client (e.g. iOS Shortcuts hitting the LAN binding)
- [ ] Decide whether to also ship an OpenAPI spec (e.g. via `utoipa`) — if deferred, file it as a follow-up rather than expanding this brief

## Definition of done

A new client can go from zero to reading and writing notes using only the docs.

---

Linear DEV-899 · API Server · created 2026-07-07 · done 2026-07-07