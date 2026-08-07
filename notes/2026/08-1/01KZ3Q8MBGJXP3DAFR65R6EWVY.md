---
id: 01KZ3Q8MBGJXP3DAFR65R6EWVY
created: 2026-08-03T11:48:36.848493Z
updated: 2026-08-07T23:15:58.213643Z
type: task
title: Pack upload, validation and management screen
project: 01KX671DATY39VW6GWK3M2T3DN
number: 501
sprint: s1mg25q
comments:
- id: 01KZF863456N6M1QE5S20XJ68K
  author: Steve Vine
  at: 2026-08-07T23:15:58.213484Z
  text: |-
    Done — PR #536 (branch feature/ise-501-pack-management, stacked on #535).

    Upload a pack YAML in Settings → Integration packs and it becomes an Integration Type the add-integration picker offers, with its credential form generated from the document. No module, no migration, no deploy.

    **Backend**
    - `packs/paths.py` — the restricted JSONPath (addressing only). Recursive descent, filters, slices, unions and script expressions are each rejected *by name*: an author who typed `$.items..id` needs to be told which feature is missing, not that "the path is invalid".
    - `packs/schema.py` — the v1 document. The cross-reference checks live OUTSIDE the pydantic model deliberately: a model validator can raise exactly one error and reports it at the model, so a pack with both a bad endpoint reference and an undeclared credential would surface one of them, located at `document`, and you'd fix it and upload again to find the other. As a pass over the parsed document they all come back at once, each at its own field (`entities[0].type`, `http.auth.value`, `endpoints[1].pagination.next`). Same reason the vocabulary checks are `AfterValidator`s on the field rather than model validators.
    - `packs/connector.py` — one Connector whose identity comes from a row rather than a class. `action_catalogue()` returns `[]` unconditionally, `credential_use().write` is False, and capabilities are *derived* from the mappings rather than declared — two places to state the same fact is one place for them to disagree, and the disagreement an operator sees is a Type advertising Entities whose System never joins the estate.
    - `packs/store.py` + a registry pack provider. Built-ins resolve first, always, so `pack:<key>` can never shadow one.
    - Migration 0108 (`integration_pack`) — the only migration packs will ever need.
    - `/api/v1/packs`: admin writes (installing a pack decides what ISE can connect to at all — above the operator writes that register a document), viewer reads, plus `POST /packs/validate` which runs the identical check and stores nothing.

    **Frontend** — Settings → Integration packs: install/replace with a paste box or a file, Check before Install, the located errors rendered with the field path scannable down the left, and each row showing version, what it provides, and how many Integrations depend on it (which is exactly why a delete refuses, shown before anyone tries).

    Two decisions worth recording:

    1. **The overlay cache backs off on FAILURE, not just on success.** `pack_connectors()` runs inside `get_connector`, which a single sync pass calls dozens of times. Without stamping the clock on the failure path, a merely-unreachable database would retry — and emit a Platform Log warning (ADR 0077) — on every one of those calls. The TTL is what makes an outage cost one line every 30 seconds instead of thousands.

    2. **Health is `degraded`, not `connected`, until ISE-502.** The live probe needs the interpreter. Reporting `connected` in the meantime would be an assertion nothing had checked; ISE-502 deletes that branch.

    Also: a pack whose Integrations still exist refuses to be uninstalled *or* disabled, and the refusal names them — otherwise those Systems resolve to no connector and fail every sync cycle with an unregistered-type error, which is a confusing way to learn what you did.

    Tests: 38 unit (every rejection asserted on its message, not just on raising), 9 integration against a real app + Postgres, 5 vitest. The load-bearing integration test is that an uploaded document becomes a resolvable Type a System can be created against — that spans the overlay, the cache and the connectors API, and none of them prove it alone. Trap avoided: the module-scoped test DB plus pytest-randomly meant per-test pack keys were needed, or the tests would pass or fail on ordering.
assignee: steve
label: null
priority: medium
task_status: active
---
The pane-of-glass slice first: upload a pack YAML in Settings, schema-validate it server-side (errors shown inline), list installed packs with version + status. Installed packs appear as Integration Types in the existing add-integration picker (registry-backed, like `mcp_evidence`); an instance then gets credentials via the generated form for free. Storage in the DB (packs are runtime artefacts, not release artefacts).