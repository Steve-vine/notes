---
id: 01M0AQN91FKTN3996PW5VY3N1A
created: 2026-08-18T15:25:54.095757Z
updated: 2026-08-19T00:59:14.379527Z
type: task
title: Delete group — a new change kind through the request path
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 261
sprint: s5gwx0s
comments:
- id: 01M0BRF31ENZ9C4VWY5HXDHRYM
  author: Steve Vine
  at: 2026-08-19T00:59:14.35041Z
  text: |-
    Built and merged to main (PR #267, CI green; migration 0077).

    group_delete joined the request kinds through the one write path — never a direct button — in both approval modes. Guard rails land server-side at raise and are re-checked at execution: a group still mapped in the role matrix is a 409 naming the roles ("unmap it first"); role-assignable groups (they grant Entra directory roles, the COM-252 detection) are refused outright — privilege infrastructure, not housekeeping, and this is also the ADR 0045 protected-objects mechanism applied with full force; only assigned security groups are deletable.

    Execution Graph-deletes, writes a group_deleted ledger row, and the outcome records the deleted object id with the note that Entra keeps groups restorable from deleted items for ~30 days. The mirror row is marked vanished immediately — never erased, so recert snapshots keep resolving — and the display name is snapshotted onto the subject so the request keeps reading after the group is gone.

    Detection symmetry (the "if cheap" question — it was): an out-of-band deletion of a managed group now raises an unrequested-change item in the same sync pass (group_deleted joined the detection vocabulary), suppressed when a recent Compass ledger row explains it; unmanaged vanishings stay quiet, so the validation queue gains signal without noise.

    UI: "Delete a group" in the raise menu with a mirror-fed picker; a "Delete group…" action on the shared group modal that opens the pre-filled request (not a shortcut around approval); and the approval view shows the blast radius — "deleting removes this access from N members" plus the restorability note.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Group deletion joins the change kinds — through the one write path, never a direct button. `kind = group_delete` on the COM-239 request entity, both approval modes (standard maker-checker; expedited for `access_engineer`, validated after the fact like any other break-glass change).

* **Raise**: from the raise forms (group picker fed by the mirror) and as a "Delete group…" action on the group detail modal / role-matrix context once COM-253's shared modal exists — both routes just open a pre-filled request, the modal action is not a shortcut around approval.
* **Guard rails** (refusals server-side, mirrored in the UI):
  * A group still **mapped in the role matrix** can't be deleted — unmap it first (409 naming the roles), otherwise JML/recert semantics dangle.
  * The ADR 0045 **protected-groups list** applies with full force.
  * A group **granting Entra directory roles** (COM-252 detection) is refused outright, or at minimum demands the heavy-confirmation treatment — deleting one is a privilege-infrastructure change, not housekeeping.
* **Approval view shows the blast radius** (COM-260 synergy): full group details plus **member count** — "deleting removes this access from N members" — and the directory-role badge if applicable. The approver should see what the deletion actually does, not just a name.
* **Execution + evidence**: Graph delete; note in the result that Entra soft-deletes groups (restorable from deleted items for ~30 days — record the deleted object id so an oops is recoverable by an admin in the portal). Mirror marks the group vanished on the next pass; recert snapshots keep resolving by design (they reference the mirror row, which is marked, not erased).
* **Detection symmetry** (small, decide in the PR): COM-244 detects out-of-band *creations*; an out-of-band **deletion** of a managed group is at least as significant — worth surfacing as an unrequested-change item in the same pass if cheap, or logging as its own follow-up if not.

Refs: ADR 0045 (write path, protected groups, expedited model), COM-239/240 (request machinery), COM-252/253 (role detection + modal entry point), COM-260 (approval detail view).