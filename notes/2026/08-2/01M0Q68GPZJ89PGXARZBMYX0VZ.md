---
id: 01M0Q68GPZJ89PGXARZBMYX0VZ
created: 2026-08-23T11:31:57.791032Z
updated: 2026-08-25T15:27:39.377032Z
type: task
title: Devices join the Access Graph — a new node kind over the device edges
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 389
sprint: s5gwx0s
blocked_by:
- 01M0Q67QE392HEGF8CPFXV4771
- 01M0Q67YJ52N1TR8GAVSX7V20E
- 01M0Q68ADDRCXA6EKT3VTV0VK2
comments:
- id: 01M0QG1BFQRVKVT8SGXSJDV4CJ
  author: Steve Vine
  at: 2026-08-23T14:22:48.823647Z
  text: |-
    Done — PR #391 (feature/com-389-device-graph), stacked on #390 (COM-388). Top of the device chain.

    Worth recording: ADR 0048 §6 explicitly cut the graph to "users and groups only", so this needed an amendment rather than just code. The cut's stated *reason* was that apps and service principals are live Graph reads, not mirrored, and the graph reads only the mirror (§3) — COM-386 mirrored devices, so that reason stopped excluding them. The cut still stands for apps and service principals, and the amendment says so.

    Backend:
    - `device` joins user/group/role. `_up_step` walks device→group membership (this is what makes re-rooting on a device explore its groups); `_down_step` reaches a group's device members. A device is a **leaf** — it expands nothing downward, like a user.
    - A device can be the root. Resolved *last* of the three kinds, because user and group ids are what every existing `?root=` deep link carries.
    - `edges_within` draws group→device edges among on-canvas nodes, and a device reached transitively still gets no invented edge to the far group — reachability and drawing stay different questions.
    - The ceiling counts devices identically. `test_traversal_node_ceiling_truncates_deterministically` now truncates *at a device*, which is the brief's "a 500-device group must truncate, not wallpaper the canvas" turned into a live assertion rather than a comment.
    - Vanished devices: off the canvas, and 404 as a root.

    Frontend appearance — the one judgement call. COM-322's rule is "shape says the category, colour and glyph say the kind". A device is a leaf identity object exactly as a user is (belongs to groups, contains nothing), so it takes the **pill**, with its own indigo and its own laptop glyph — the same relationship the four group types have to the shared box. Giving it a fourth distinct silhouette would have made shape say something the rule doesn't. I also strengthened the registry test: it now asserts *every* node kind's colour and glyph are unique and clear of the group-type palette, where before only the group types were checked against each other.

    Devices are hideable in the object filter (which is this canvas's legend — there's no separate legend component). That earns its keep: a managed-workstation group is mostly devices, and someone tracing who reaches what can put them aside without leaving the graph.

    Effective-membership expansion needed no new work — devices reached through a nested group already land a ring further out, because the BFS and COM-388's closure are the same walk over the same edges.

    201 unit + 757 integration + 617 frontend, all green.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The Access Graph tab shows devices as first-class nodes, read-only like everything else on the canvas.

- [ ] Backend BFS (`/directory/graph`, ADR 0048) walks the group→device edges: a `device` object kind in `DirectoryGraphOut` nodes, `member` edges from groups to their device members; re-rooting on a device explores its groups.
- [ ] `nodeAppearance` (`graph/graphMeta.ts`, COM-322 idiom: shape says the category, colour and glyph say the kind) gets a device shape/colour/glyph distinct from users and groups; legend updated.
- [ ] The kind-icon opens the device detail modal (from the View Devices task), matching "open this object" vs "explore from here" on user/group nodes.
- [ ] Fan-out truncation ("more" nodes) counts devices the same way as users — a 500-device group must truncate, not wallpaper the canvas.
- [ ] Effective-membership expansion on a group node includes inherited device members, reusing the closure from the group-members task.

Refs: ADR 0048, COM-303 (graph endpoint), COM-322 (node appearance).