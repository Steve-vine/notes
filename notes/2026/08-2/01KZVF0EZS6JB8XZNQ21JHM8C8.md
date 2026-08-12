---
id: 01KZVF0EZS6JB8XZNQ21JHM8C8
created: 2026-08-12T17:06:06.969693Z
updated: 2026-08-12T17:06:06.969693Z
type: task
title: Engine-roster tests are count-locked — make seed validation roster-driven
assignee: steve
task_status: done
imported_from: linear
label: chore
priority: urgent
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 279
---
**M7 surfaced backend miss (blocks** DEV-113**/117/354/355).** The engine-roster tests are count-locked to the original five engines, so every new engine seed fails CI.

## Root cause

`app/backend/tests/test_engine_controller.py`:

* `_SEED_NAMES = ["subfinder", "httpx", "nuclei", "cloudflare", "ass…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-360](https://linear.app/stevevine/issue/DEV-360/engine-roster-tests-are-count-locked-make-seed-validation-roster)