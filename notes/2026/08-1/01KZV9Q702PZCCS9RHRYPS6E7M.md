---
id: 01KZV9Q702PZCCS9RHRYPS6E7M
created: 2026-08-12T15:33:40.994765Z
updated: 2026-08-12T15:35:20.75328Z
type: task
title: SDK package has no CI gate — ruff format drift uncaught (flagged in DEV-315)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 4
sprint: sw9wx5e
assignee: steve
imported_from: linear
label: null
priority: low
task_status: backlog
---
The `redvektor-engine` SDK package (`packages/redvektor-engine-python/`) has no CI job in `test.yml` (CI covers backend + frontend only), so `ruff format` drift goes uncaught. Code flagged during DEV-315 (session 315) that `uv run ruff format --check .` in the SDK reports pre-existing drift in files this brief didn't touch: `evidence.py`, `runner.py`, `transport.py`, `test_transport.py`. Baseline on `main`, not introduced by DEV-315.

**Two parts:**

1. `ruff format` the SDK package (the drifted files above) in one formatting-only PR.
2. Add an SDK gate to CI (lint + format-check + mypy + pytest for `packages/redvektor-engine-python/`) so this can't recur — the SDK is the cross-cutting contract package; it should not be the one component without CI.

Small/cosmetic for part 1; part 2 is a CI-config change (`.github/workflows/test.yml`). Candidate to fold into the DEV-308 close-out or take standalone. No brief needed for part 1 (single formatting pass); part 2 is a small CI addition.

---

Imported from Linear [DEV-316](https://linear.app/stevevine/issue/DEV-316/sdk-package-has-no-ci-gate-ruff-format-drift-uncaught-flagged-in-dev)