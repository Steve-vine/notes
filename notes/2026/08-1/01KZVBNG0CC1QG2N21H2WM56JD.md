---
id: 01KZVBNG0CC1QG2N21H2WM56JD
created: 2026-08-12T16:07:41.836956Z
updated: 2026-08-12T16:07:41.836956Z
type: task
title: '`tls.issuer` not surfaced in httpx meta'
assignee: steve
task_status: backlog
imported_from: linear
priority: medium
label:
- follow_up
- tech_debt
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 129
---
During PR #18's smoke against `example.com`, the httpx asset's `meta.tls` block contained `subject_cn`, `subject_an`, and `not_after` — but NOT `issuer`, which is in the runner's whitelist. Either (a) httpx emits the field under a different key (e.g. `issuer_cn`/`issuer_dn`) and the whitelist needs renaming, or (b) httpx returned `issuer: ""` and the runner's empty-value drop ate it. Verify with: `docker run --rm --entrypoint=/usr/local/bin/httpx redvektor/httpx:local -u https://example.com -json -tls-grab | jq '.tls'`. Worth a contract test in `redvektor-scanner-common` that cross-checks each scanner's whitelist against real fixture output.

Source: Obsidian To Do § From Brief 009.

---

Imported from Linear [DEV-54](https://linear.app/stevevine/issue/DEV-54/tlsissuer-not-surfaced-in-httpx-meta) · parent DEV-15