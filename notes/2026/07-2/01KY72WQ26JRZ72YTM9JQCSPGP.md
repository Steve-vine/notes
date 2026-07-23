---
id: 01KY72WQ26JRZ72YTM9JQCSPGP
created: 2026-07-23T08:53:50.790273Z
updated: 2026-07-23T11:03:35.450008Z
type: task
title: First-run prompt to connect AI assistants
assignee: steve
number: 318
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: segj1dz
---
DEV-888 added one-click MCP registration in Settings › MCP › Connect AI assistants. The issue also floated an **optional first-run prompt** — surfacing the same registration rows right after vault creation, so an installed-from-dmg user connects Claude/VS Code without discovering the Settings section.

Scope sketch:

* After `FirstRun.svelte` creates the vault (it's currently a single screen), offer a small optional step listing the detected clients (`mcp_clients`) with the same Register buttons — skippable, never blocking.
* Reuse the Settings rows' logic/backing commands verbatim; consider extracting the row component if duplication warrants it.
* Only show the step when at least one client is detected and the sidecar binary exists (i.e. an installed build, not a dev checkout).

---

Linear DEV-971 · Enhancements · created 2026-07-12 · done 2026-07-14