---
id: 01M0FWAJRMJ6FJW3PNS5F9SSPE
created: 2026-08-20T15:23:38.644314Z
updated: 2026-08-20T15:33:24.152919Z
type: task
title: Object filter — a checklist to show or hide users, security groups, M365 groups and DLs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 323
sprint: sar11t4
blocked_by:
- 01M0FW84JE7VTEF8FVF44S8HWQ
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Sprint 36 follow-up (graph improvements, 2026-08-20). A busy canvas needs pruning by *what things are*, not just by edge kind: hide the users to see pure group structure, hide the M365/distribution noise to see the security posture. Add an object-kind filter to the explorer.

* **The control**: a checklist on the explorer's control row (Mantine `Menu` of `Checkbox`es or a `Chip.Group` — pick whichever reads best beside the edge chips): Users · Security groups · Microsoft 365 groups · Distribution lists · Mail-enabled security. All on by default; persisted with the other reading preferences. Business roles stay governed by the overlay toggle — no duplicate control.
* **Model layer, not the server**: `buildElements` gains an object-kind filter alongside the edge-type one. Each node resolves to a token — `user`, `role`, or its `group_type` (from COM-322's payload change); a group with no type on the wire resolves to a generic `group` token that no checklist entry hides — the honest fallback, never guessing a kind. A hidden node folds its subtree away through the existing rendered-parent cascade, and edges touching hidden nodes are skipped by the existing honest-skip rule. The root always survives (it is the thing being looked into).
* **Never silently empty**: unchecking everything the canvas contains leaves only the root — fine; the checklist's own state is what says kinds are hidden.
* Path-highlight pickers list only nodes that survive the filter — offering a hidden node as a path endpoint would highlight nothing.
* Tests: model-layer filter + cascade tests per token (including the group_type fallback); a page test that unchecking Users removes user nodes and their edges, and that the preference persists.

Blocked by COM-322 (needs `group_type` on the graph payload).

Refs: ADR 0048 §1; `src/access/graph/graphLayout.ts` (`buildElements`), `AccessGraphPage.tsx`, COM-322.