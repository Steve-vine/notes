---
id: 01KZVF9G8HM8JZH7NS0NWCEDGC
created: 2026-08-12T17:11:03.185869Z
updated: 2026-08-12T17:11:54.230672Z
type: task
title: 'ADR 035: Asset/Finding are company-scoped; project is a lens (fixes DEV-317 orphan-drop)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 303
sprint: syc8wmf
assignee: steve
imported_from: linear
label: null
priority: high
task_status: done
---
**Root cause:** DEV-317 found that asset identity is Company-scoped (`UNIQUE (company_id, fingerprint)`) while ingest/resolution/list code is Project-scoped — they disagree, so a second project re-discovering an asset value silently UPDATEs the first project's row (no row i…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-318](https://linear.app/stevevine/issue/DEV-318/adr-035-assetfinding-are-company-scoped-project-is-a-lens-fixes-dev)