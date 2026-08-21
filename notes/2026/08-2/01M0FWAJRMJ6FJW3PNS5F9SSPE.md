---
id: 01M0FWAJRMJ6FJW3PNS5F9SSPE
created: 2026-08-20T15:23:38.644314Z
updated: 2026-08-21T08:41:26.129014Z
type: task
title: Object filter — a checklist to show or hide users, security groups, M365 groups and DLs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 323
sprint: sar11t4
blocked_by:
- 01M0FW84JE7VTEF8FVF44S8HWQ
comments:
- id: 01M0GNXG08TDWCM4CB1RHF5TVY
  author: Steve Vine
  at: 2026-08-20T22:50:52.808389Z
  text: |-
    Done — PR #313 merged to main (rebased onto COM-322's merge first), CI green.

    The explorer grew an "Objects" popover checklist — Users · Security groups · Microsoft 365 groups · Distribution lists · Mail-enabled security — all on by default, persisted with the other reading preferences (prefs saved before the field existed still parse), and the button reads "Objects (N hidden)" while filtering.

    The filter lives in the model layer, not the server: buildElements resolves each node to a token (user, role, its group_type, or a generic 'group' for a type the payload doesn't carry — never guessed, never hideable) and drops hidden tokens; the subtree folds away through the existing rendered-parent cascade, edges follow the existing honest-skip rule, and the root always survives. Business roles stay governed by the overlay toggle — no duplicate control. The path-highlight pickers offer only nodes that survive the filter, since a hidden endpoint would highlight nothing.

    Tests: model filter + cascade + never-hidden tokens + objectToken resolution; a registry test pinning the checklist's entries to the model layer's hideable-token list; a page test hiding DLs and asserting the persisted preference. Full frontend suite green (481).

    Housekeeping note: mid-task this branch's uncommitted edits were autostashed by the sprint-37 session switching the primary checkout; everything was recovered intact from the stash into this session's own worktree — flagged here only so the odd-looking git reflog on the primary checkout has an explanation.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Sprint 36 follow-up (graph improvements, 2026-08-20). A busy canvas needs pruning by *what things are*, not just by edge kind: hide the users to see pure group structure, hide the M365/distribution noise to see the security posture. Add an object-kind filter to the explorer.

* **The control**: a checklist on the explorer's control row (Mantine `Menu` of `Checkbox`es or a `Chip.Group` — pick whichever reads best beside the edge chips): Users · Security groups · Microsoft 365 groups · Distribution lists · Mail-enabled security. All on by default; persisted with the other reading preferences. Business roles stay governed by the overlay toggle — no duplicate control.
* **Model layer, not the server**: `buildElements` gains an object-kind filter alongside the edge-type one. Each node resolves to a token — `user`, `role`, or its `group_type` (from COM-322's payload change); a group with no type on the wire resolves to a generic `group` token that no checklist entry hides — the honest fallback, never guessing a kind. A hidden node folds its subtree away through the existing rendered-parent cascade, and edges touching hidden nodes are skipped by the existing honest-skip rule. The root always survives (it is the thing being looked into).
* **Never silently empty**: unchecking everything the canvas contains leaves only the root — fine; the checklist's own state is what says kinds are hidden.
* Path-highlight pickers list only nodes that survive the filter — offering a hidden node as a path endpoint would highlight nothing.
* Tests: model-layer filter + cascade tests per token (including the group_type fallback); a page test that unchecking Users removes user nodes and their edges, and that the preference persists.

Blocked by COM-322 (needs `group_type` on the graph payload).

Refs: ADR 0048 §1; `src/access/graph/graphLayout.ts` (`buildElements`), `AccessGraphPage.tsx`, COM-322.