---
id: 01KZVFP17DYV0WQEF7NJXQSQJM
created: 2026-08-12T17:17:53.77323Z
updated: 2026-08-12T17:17:53.77323Z
type: task
title: Brief 062 — Conformance CLI
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 336
---
## Scope

Build the `redvektor engine verify <image>` CLI that validates an engine container conforms to the spec. This is the gate that decides whether an engine is "well-formed" — without it, community engines will break the dispatcher in creative ways.

## What this brief delivers

* **CLI tool** — `redvektor engine verify <image>` (location TBD: standalone in `packages/` or sub-command of the API CLI)
* **Fixture runner** — invokes the engin…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-269](https://linear.app/stevevine/issue/DEV-269/brief-062-conformance-cli)