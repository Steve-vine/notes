---
id: 01M0AJ8YP555JCBEAF02KF41D4
created: 2026-08-18T13:51:47.397507Z
updated: 2026-08-19T10:01:48.311235Z
type: task
title: Role matrix — group pills open the group detail modal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 257
order: 2.90625
sprint: s5gwx0s
blocked_by:
- 01M0AH2VRZ4F1Z8C778TP8X0NG
comments:
- id: 01M0BKH1VHC5ERVK0N0K4SKQBT
  author: Steve Vine
  at: 2026-08-18T23:32:55.793453Z
  text: |-
    Built and merged to main (PR #264, CI green).

    The mapped-group pills on the Role matrix list are now real affordances — cursor/hover, role=button, keyboard-activatable (Enter/Space), with stopPropagation so the row's navigate doesn't fire — opening the shared access/GroupDetailModal in place: description, owners, members, nesting, the directory-role badge and the Azure Portal link, without leaving the matrix.

    The extraction had already paid for itself: COM-253 shipped the modal as a shared component from day one, and COM-255's user modal is the third consumer — one component, no drift, exactly as the task hoped. The vanished-pill case opens the modal's "no longer in the directory" presentation rather than erroring (the detail endpoint resolves vanished groups by design). COM-253 did not land route-addressable modal state, so none was invented here.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
On the Role matrix list (COM-238), the mapped-group pills are currently inert labels. Make each pill a link that opens the group in the **COM-253 group detail modal** — description, owners, members, nested membership, the directory-role badge and the Azure Portal link — without leaving the matrix.

* Extract the COM-253 modal into a shared component (`access/GroupDetailModal` or similar) driven by group object id, so View Groups and the matrix render the identical modal — one component, no drift. COM-255's user-modal Groups panel wants the same component (its body already links "through to the View Groups modal"), so the extraction pays three times.
* Pills get link affordance (hover/focus states, keyboard-activatable) — visibly clickable, not a surprise.
* Matrix-mapped groups are managed security groups and therefore always in the inventory, but handle the vanished-group case: a pill whose group has dropped from the mirror already renders the COM-238 warning state — clicking it opens the modal's "no longer in the directory" presentation rather than erroring.
* If COM-253 lands the modal as route-addressable state (`?group=<id>`), reuse that here so a matrix-opened modal is shareable/deep-linkable the same way; if not, don't invent it just for this.

Refs: COM-238 (the pills), COM-253 (the modal being reused), COM-255 (third consumer); ADR 0022 interaction patterns.