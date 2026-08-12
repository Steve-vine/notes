---
id: 01KZV9QHJR9791R52BBSQ87ADK
created: 2026-08-12T15:33:51.832326Z
updated: 2026-08-12T15:34:36.389358Z
type: task
title: Test coverage for internal-inputs endpoint accepts_asset_kinds routing
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 6
sprint: s1hm0kb
assignee: steve
imported_from: linear
priority: medium
task_status: backlog
---
Follow-up from Brief 061 (DEV-268). During 061, Code rerouted `api/v1/routes/internal_inputs.py` — the file-mount inputs endpoint feeding **external scanner Jobs** — from `engine.supported_target_kinds` to `resolve_engine_metadata(...).accepts_asset_kinds`, fixing a latent DEV-188-style mismatch on that path. The change was outside Brief 061's scope (the brief only specified `_build_next_inputs_from_outputs`) and is **not covered by the chaining regression tests**, which exercise the chaining path, not the inputs endpoint.

**Fix:** add a focused test for the internal-inputs endpoint asserting it mounts only assets whose `kind` ∈ the engine's `accepts_asset_kinds` (incl. the empty-accepts → no inputs case, and a multi-kind case), mirroring the chaining-path coverage.

Accepted at review as a sound change; this backfills the missing test coverage. Source: session summary `docs/sessions/061-route-on-io-declarations.md`.

---

Imported from Linear [DEV-301](https://linear.app/stevevine/issue/DEV-301/test-coverage-for-internal-inputs-endpoint-accepts-asset-kinds-routing)