---
id: 01KY72RHQVYWR6YRNK6AQGY396
created: 2026-07-23T08:51:34.267943Z
updated: 2026-07-23T08:51:34.267943Z
type: task
title: 'Settings consistency pass: Appearance, Shortcuts, Storage, API'
priority: medium
assignee: steve
task_status: done
imported_from: linear
project: 01KY6W9951TW0904DT0GGJVGE7
number: 309
---
## Context

The four non-taxonomy sections grew one at a time inside `src/lib/Settings.svelte` and it shows: Appearance and Shortcuts are bare `.rows` lists with no framing; Storage and API use a different stacked `.storage` layout with their own subsection headers; only Shortcuts has a footer (hint + "Reset to defaults"); controls are a mix of segmented pills, native selects (trash retention), native checkboxes (LAN access, git sync) and free inputs (port). Nothing is wrong per se, but side by side the sections feel like four different apps.

## Change

With the new shell (DEV-957) providing section title/description chrome, bring the four sections onto one visual system:

* **One settings-row primitive**: label + optional help line on the left, control on the right, consistent height/spacing — used by all four sections. Storage/API keep their subsection groupings ("Git sync", "API keys") as titled groups of those rows.
* **One control per input shape**: segmented pills for small enumerations (theme, font, view mode — as today), a consistently-styled select for longer enumerations (trash retention), a consistent toggle for booleans (git sync, LAN access, server enable) instead of bare checkboxes.
* **Footers**: section-level actions like "Reset to defaults" use the shared footer slot; destructive/recovery affordances (revoke key, git conflict recovery) keep their current two-click patterns but styled consistently.
* Purely visual/structural — no behaviour changes to vault relocation, git sync, retention, API server or key management.

## Acceptance

* Switching between the five sections feels like one app: same row rhythm, same label/help typography, same control styling in both themes.
* Every existing setting still works and reads its current value correctly on open.

---

Linear DEV-962 · Settings Window · created 2026-07-12 · done 2026-07-12