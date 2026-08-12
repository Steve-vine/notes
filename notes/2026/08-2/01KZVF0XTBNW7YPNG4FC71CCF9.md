---
id: 01KZVF0XTBNW7YPNG4FC71CCF9
created: 2026-08-12T17:06:22.155339Z
updated: 2026-08-12T17:07:22.430341Z
type: task
title: Review existing engine display names — align to purpose-oriented convention
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 282
sprint: s0ht2jk
assignee: steve
imported_from: linear
label:
- follow_up
- chore
priority: low
task_status: done
---
**M7 end-of-milestone consistency pass.** The five existing engines carry tool-name `displayName`s in their seed CRs (`Subfinder`, `httpx`, `nuclei`, `cloudflare`, `asset-query`). M7's four new engines adopt **purpose-oriented** display names (Port Scanner, Service Detection, TLS & Certificate Analysis, Web Crawler). Retrofit the existing five to match so the engine picker reads by purpose, not tool.

## Scope (engine-only)

* Edit `displayName`…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-356](https://linear.app/stevevine/issue/DEV-356/review-existing-engine-display-names-align-to-purpose-oriented)