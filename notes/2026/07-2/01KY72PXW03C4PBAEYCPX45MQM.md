---
id: 01KY72PXW03C4PBAEYCPX45MQM
created: 2026-07-23T08:50:41.152234Z
updated: 2026-07-23T12:25:00.267603Z
type: task
title: 'Settings shell: left-nav layout in a larger panel'
label: null
task_status: done
assignee: steve
priority: high
project: 01KY6W9951TW0904DT0GGJVGE7
number: 304
sprint: sf9yevt
---
## Context

Settings (`src/lib/Settings.svelte`, ~1,150 lines) is a fixed modal of `min(42rem, 94vw) × min(34rem, 82vh)` — about 672×544 px — with five top tabs (Appearance, Shortcuts, Taxonomies, Storage, API). The panel is too small for its densest content (the taxonomy value grid), the top-tab row is running out of horizontal room as sections accumulate, and each tab handles headers/footers differently. The taxonomy popovers even use `position: fixed` hacks (DEV-805) partly because the panel clips everything.

## Change

Restyle the settings shell to the Linear/Obsidian settings shape, consistent with the M8 "sleek modern, similar to Linear" direction:

* **Left nav sidebar** inside the panel replacing the top tab row: one entry per section with an icon, active state matching the main sidebar convention. Room to grow (future sections just add a nav item, not a shrinking tab).
* **Larger panel**: something like `min(58rem, 94vw) × min(44rem, 88vh)`, still fixed per DEV-595 (no reflow on section switch), body scrolls internally.
* **Consistent section chrome**: every section gets a title + one-line description header; the footer area (currently only the Shortcuts tab has one) becomes a shared slot any section can use.
* Keep it a modal in the main window (a separate Tauri window adds state-sync complexity for no real gain); keep the Escape-guard coordination with TaxonomySettings (DEV-708) intact.

This is layout/chrome only — section contents move across as-is; their redesigns are follow-up issues.

## Acceptance

* All five sections reachable via the left nav; active section clearly indicated.
* Panel size fixed across section switches; no horizontal scroll in any section at default size.
* Escape and unsaved-taxonomy-edit guards behave exactly as today.
* Light and dark themes both look right.

---

Linear DEV-957 · Settings Window · created 2026-07-12 · done 2026-07-12