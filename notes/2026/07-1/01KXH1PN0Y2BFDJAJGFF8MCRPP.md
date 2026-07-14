---
id: 01KXH1PN0Y2BFDJAJGFF8MCRPP
created: 2026-07-14T19:29:46.014717979Z
updated: 2026-07-14T19:29:46.014717979Z
type: task
title: 'Chore: bump pillow to 12.3.0 (PYSEC-2026-2253…2257, deps-scan red)'
label: chore
task_status: active
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 165
---
CI deps-scan (pip-audit) is failing on every branch since 2026-07-14: pillow 12.2.0 (transitive via reportlab, ADR 0024 PDF exports) has 5 new advisories — PYSEC-2026-2253, -2254, -2255, -2256, -2257 — all fixed in 12.3.0.

- [ ] `uv lock --upgrade-package pillow` in app/backend (lockfile-only; pillow is not a direct dependency)
- [ ] PR CI green (deps-scan in particular), merge to main

Blocks COM-164's PR #155 (deps-scan is a required check on main).