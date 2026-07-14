---
id: 01KXGRHCVH87NP7PFNNVGQZWQF
created: 2026-07-14T16:49:36.625871855Z
updated: 2026-07-14T16:49:36.625871855Z
type: task
title: Controls flat index (searchable)
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 14
---
A flat, searchable Core control library complementing the domain-led browse (ADR 0017). The index UI shipped in <issue id="eba6e737-9bfc-4229-b4aa-8550996f7d30" href="https://linear.app/stevevine/issue/DEV-399/domains-and-controls-browse-ui">DEV-399</issue> (client-side filter) and the controls API in <issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue> (?domain); this makes **search a first-class API capability** and drives the UI from it.

**Agreed approach (plan-mode, 2026-06-14):**

* **Backend** `api/v1/controls.py`: add `?q=` — case-insensitive substring (ILIKE, wildcards escaped) across `ref`/`title`/`description`, combined with the existing `?domain=`; ordered by ref.
* **Frontend** `ControlsPage`: switch from the client-side filter to **server-driven search** (debounced `?q=`) + a **domain dropdown** (`Select` from `/domains`). Regenerate `schema.d.ts` for the new param.
* **Tests:** backend (`?q=ACC`, description match, q+domain combine, no-match, `%` escaped); frontend (server-driven refetch narrows rows).

**Resolved forks:** (1) server search API + upgrade UI (not API-only); (2) substring ILIKE (not full-text).

No chart/migration changes. Refs: ADR 0017.

---
*Migrated from Linear [DEV-400](https://linear.app/stevevine/issue/DEV-400/controls-flat-index-searchable) · created 2026-06-13 · completed 2026-06-14*