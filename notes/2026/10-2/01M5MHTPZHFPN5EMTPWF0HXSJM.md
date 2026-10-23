---
id: 01M5MHTPZHFPN5EMTPWF0HXSJM
created: 2026-10-23T14:14:54.193456Z
updated: 2026-10-23T14:15:00.173934Z
type: task
title: brotli 1.2.0 — a new advisory (PYSEC-2026-4322) fails the dependency scan on every PR
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1272
sprint: s5uw2fz
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found while shipping sprint 84 (COM-1262, #1279): `deps-scan` fails with brotli 1.2.0 PYSEC-2026-4322, fixed in 1.2.1 (published 2026-10-22). Not caused by the PR — every PR fails until fixed.

brotli isn't used directly: fonttools[woff] (WeasyPrint, uploaded fonts) brings it. Fix as COM-815/COM-1187 did: a floor `brotli>=1.2.1` in the backend dependencies with a comment, and the lock moved to 1.2.1 (wheels exist for x86_64 and aarch64 on 3.12).

**Chain:** independent (no migration, no API change)

**Done when:** deps-scan is green on main and the stacked sprint-84 PRs pass it.