---
id: 01KZVFFZ60EHKJSYKNRP27YEXT
created: 2026-08-12T17:14:35.072997Z
updated: 2026-08-12T17:14:35.072997Z
type: task
title: 'Playwright smoke: ownership lifecycle (lands with first real Scan engine in M6)'
priority: medium
assignee: steve
task_status: done
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 321
---
Follow-up from Brief 067 second pass. The original brief assumed asset-query would produce a Finding so the ownership flow could be exercised against a real workflow-produced Finding; in practice asset-query is a Selector (emits Assets only) and no Scan engine path was in scope. The ownership smoke is deferred until a Scan engine is wired up enough to produce a Finding in the smoke harness.

**Scope when this brief lands**

* Spec name: `app/fro…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-293](https://linear.app/stevevine/issue/DEV-293/playwright-smoke-ownership-lifecycle-lands-with-first-real-scan-engine)