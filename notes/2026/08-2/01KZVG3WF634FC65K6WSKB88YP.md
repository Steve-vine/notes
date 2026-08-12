---
id: 01KZVG3WF634FC65K6WSKB88YP
created: 2026-08-12T17:25:27.654578Z
updated: 2026-08-12T17:25:27.654578Z
type: task
title: ADR 020 — Workflow as the unit of execution
label: chore
assignee: steve
priority: high
task_status: done
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 377
---
Standalone ADR captures the architectural shift away from "engine" as the user-facing picker unit, towards Workflows composed of typed Steps configured at runtime.

## Why now

DEV-158 surfaced that the engine picker doesn't scale. Investigation in the same chat session revealed the deep…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-177](https://linear.app/stevevine/issue/DEV-177/adr-020-workflow-as-the-unit-of-execution)