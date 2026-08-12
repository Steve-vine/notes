---
id: 01KZVFFKRGE3HBF5C2JY6WHMX7
created: 2026-08-12T17:14:23.376773Z
updated: 2026-08-12T17:14:23.376773Z
type: task
title: Playwright smoke can't run on EC2 (Ubuntu 26.04 arm64 unsupported by Playwright 1.60.0)
task_status: done
assignee: steve
priority: medium
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 318
---
Surfaced on the first unattended EC2 Code run (DEV-295 / Brief 069).

`npx playwright install chromium` from `app/frontend/` fails on the EC2 box:

```
Error: ERROR: Playwright does not support chromium on ubuntu26.04-arm64
```

This is **not** a system-deps problem — `--on…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-297](https://linear.app/stevevine/issue/DEV-297/playwright-smoke-cant-run-on-ec2-ubuntu-2604-arm64-unsupported-by)