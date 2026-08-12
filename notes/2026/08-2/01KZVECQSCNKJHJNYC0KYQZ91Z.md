---
id: 01KZVECQSCNKJHJNYC0KYQZ91Z
created: 2026-08-12T16:55:20.620872Z
updated: 2026-08-12T16:56:05.578869Z
type: task
title: Finding-minted URL assets lack a host-anchor edge (graph lineage)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 233
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- follow_up
priority: low
task_status: done
---
## Context

DEV-445 makes finding-ingest **mint the target URL asset** when a finding references a URL no upstream step produced (e.g. a redirect target `https://www.moneypenny.com`), so the finding persists instead of being dropped. To keep that fix contained, the minted URL is cr…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-447](https://linear.app/stevevine/issue/DEV-447/finding-minted-url-assets-lack-a-host-anchor-edge-graph-lineage) · parent DEV-445