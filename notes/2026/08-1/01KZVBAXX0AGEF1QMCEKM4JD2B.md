---
id: 01KZVBAXX0AGEF1QMCEKM4JD2B
created: 2026-08-12T16:01:55.616298Z
updated: 2026-08-12T16:01:55.616298Z
type: task
title: Widen AssetQuerySelectorOpts.kinds from Literal to dynamic kinds
imported_from: linear
assignee: steve
priority: low
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 112
---
Follow-up from Brief 060a (DEV-267). After the dynamic asset-kinds port, the runtime ingest/query path for asset-query is string-based against the VARCHAR `assets.kind` column, but `AssetQuerySelectorOpts.kinds` in `core/scan_engines.py` is still a Pydantic `Literal` of the five bootstrap kinds — it drives the JSON Schema for the workflow composer form.

**Effect:** asset-query can't be configured (via the UI form) to target a controller-added, non-bootstrap kind, even though the runtime path would handle it. No functional regression today (no non-bootstrap kinds exist in prod).

**Fix:** widen `AssetQuerySelectorOpts.kinds` from the `Literal` to `list[str]` (or validate against the asset-kind registry), and regenerate the asset-query `paramsSchema` fixture. Likely folds naturally into the asset-query CR-sourced param validation work in Brief 063 (DEV-270) — check there before doing it standalone.

Source: session summary `docs/sessions/060a-dynamic-asset-kinds-backend.md`, "Decisions made mid-session".

---

Imported from Linear [DEV-300](https://linear.app/stevevine/issue/DEV-300/widen-assetqueryselectoroptskinds-from-literal-to-dynamic-kinds)