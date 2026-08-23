---
id: 01M0Q68GPZJ89PGXARZBMYX0VZ
created: 2026-08-23T11:31:57.791032Z
updated: 2026-08-23T14:05:56.274318Z
type: task
title: Devices join the Access Graph — a new node kind over the device edges
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 389
sprint: s5gwx0s
blocked_by:
- 01M0Q67QE392HEGF8CPFXV4771
- 01M0Q67YJ52N1TR8GAVSX7V20E
- 01M0Q68ADDRCXA6EKT3VTV0VK2
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The Access Graph tab shows devices as first-class nodes, read-only like everything else on the canvas.

- [ ] Backend BFS (`/directory/graph`, ADR 0048) walks the group→device edges: a `device` object kind in `DirectoryGraphOut` nodes, `member` edges from groups to their device members; re-rooting on a device explores its groups.
- [ ] `nodeAppearance` (`graph/graphMeta.ts`, COM-322 idiom: shape says the category, colour and glyph say the kind) gets a device shape/colour/glyph distinct from users and groups; legend updated.
- [ ] The kind-icon opens the device detail modal (from the View Devices task), matching "open this object" vs "explore from here" on user/group nodes.
- [ ] Fan-out truncation ("more" nodes) counts devices the same way as users — a 500-device group must truncate, not wallpaper the canvas.
- [ ] Effective-membership expansion on a group node includes inherited device members, reusing the closure from the group-members task.

Refs: ADR 0048, COM-303 (graph endpoint), COM-322 (node appearance).