---
id: 01KXH1PN0Y2BFDJAJGFF8MCRPP
created: 2026-07-14T19:29:46.014717979Z
updated: 2026-07-19T21:30:27.333662255Z
type: task
title: 'Chore: bump pillow to 12.3.0 (PYSEC-2026-2253…2257, deps-scan red)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 165
comments:
- id: 01KXH1SM8CHGEA2BXC8AS0X61Z
  author: Steve Vine
  at: 2026-07-14T19:31:23.532773573Z
  text: 'Development complete on feature/com-165-pillow-12-3-0. PR #156: https://github.com/Steve-vine/compass/pull/156. Lockfile-only: uv lock --upgrade-package pillow==12.3.0 (transitive via reportlab). pip-audit verified clean locally. Merged to staging; awaiting PR CI, then merges ahead of COM-164''s #155 which it unblocks.'
- id: 01KXH27AXVD4RYPE4B89Y14HNA
  author: Steve Vine
  at: 2026-07-14T19:38:52.731236162Z
  text: 'PR #156 merged to main (squash), branch deleted. Full PR CI green including deps-scan (pip-audit clean with pillow 12.3.0). Done.'
task_status: done
---
CI deps-scan (pip-audit) was failing on every branch since 2026-07-14: pillow 12.2.0 (transitive via reportlab, ADR 0024 PDF exports) had 5 new advisories — PYSEC-2026-2253, -2254, -2255, -2256, -2257 — all fixed in 12.3.0.

- [x] `uv lock --upgrade-package pillow` in app/backend (lockfile-only; pillow is not a direct dependency)
- [x] PR CI green (deps-scan in particular), merge to main

Unblocked COM-164's PR #155 (deps-scan is a required check on main).