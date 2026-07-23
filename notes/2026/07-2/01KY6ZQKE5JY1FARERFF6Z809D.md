---
id: 01KY6ZQKE5JY1FARERFF6Z809D
created: 2026-07-23T07:58:37.509987Z
updated: 2026-07-23T11:00:29.424545Z
type: task
title: 'Live preview: viewport-scoped decorations for large notes'
task_status: done
number: 111
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: st23znm
label: null
---
DEV-688's live-preview `StateField` (`src/lib/livePreview.ts`) decorates the **whole document** on every doc/selection change. This is fine for Notula's premise (atomic, one-or-two-line notes) but is O(doc) per keystroke, so a very long note could feel sluggish.

If/when large notes become a real case, scope decoration building to the visible range. The wrinkle: block decorations (table/hr widgets) must still come from a `StateField` (not a `ViewPlugin`), so a viewport-aware version needs the field to read the view's `visibleRanges` — e.g. a companion `ViewPlugin` that triggers field recompute on `viewportChanged`, or a `StateField` that tracks viewport via a transaction effect.

Deliberate compromise for now, not a bug. No action unless perf is observed.

---

Linear DEV-696 · M13 - Hybrid Edit Mode · created 2026-06-28 · done 2026-06-28