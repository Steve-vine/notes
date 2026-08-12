---
id: 01KZVFXZD4WW3ZKT2C8GFAEQYS
created: 2026-08-12T17:22:14.052251Z
updated: 2026-08-12T17:22:14.052251Z
type: task
title: Scanner chaining issue
label: bug
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 361
---
If I create a 2 step workflow with a Cloudflare selector and httpx scanner I get the following results.
With CF selector set to moneypenny.com - 
cloudflare - 411 assets
httpx - 346 assets

If I change the cloudflare selector to voicenation.com
cloudflare - 73 assets
httpx - 34 assets

If I create a workflow with 3 steps, two Cloudflare selectors (one for voicenation.com and one for moneypenny.com), I tget these results.
cloudflare (moneypenny.c…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-233](https://linear.app/stevevine/issue/DEV-233/scanner-chaining-issue)