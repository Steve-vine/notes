---
id: 01M1020Q245SDPMV450SBPVTWE
created: 2026-08-26T22:10:57.732642Z
updated: 2026-09-01T13:55:52.072789Z
type: task
title: Detection learns two changes it cannot see today — an unprocessed leaver, and a directory role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 453
sprint: snq23hz
comments:
- id: 01M12XVB6E28XGM2E25RBX1PEM
  author: Steve Vine
  at: 2026-08-28T00:55:50.734533Z
  text: |-
    Done — merged to main as fbc6cc2 (PR #469). Full CI green first time.

    **The unprocessed leaver.** `user_created` had no opposite. `_upsert_users` / `_apply_user_deltas` now also report **newly-departed** ids — enabled → disabled, or stopped appearing at all — and a departure with no `user_disabled` ledger row behind it raises an item. Always `needs_validation`: an unprocessed departure is a decision, never something to file quietly.

    **The directory role.** `_direct_role_assignments` snapshots (role, principal) for active *user* principals before the reconcile; `_reconcile_and_watch_roles` banks the snapshot, diffs against it, then checks whether any instructed reversal has come true. The item names the role *and* the holder — a validator cannot judge "a role changed" without both.

    **The ending with no execution.** Flag-for-reversal on a directly-assigned role takes no `request_id`, because no request could execute it. It records what a human must do —

    > Compass cannot revoke a directory role assigned straight to a person. Remove 'Global Administrator' from this account in the Entra admin centre. This item stays open until a sync confirms the role has gone.

    — and leaves the item **open**. Only the sync closes it, by observing the role has gone.

    Making "still open" real rather than decorative touched four places, which is the part worth knowing about: `reversal_instructed` is not terminal in the transitions map; `OPEN_UNREQUESTED_STATUSES` is what the queue, the action list and every mail derived from it read (not `pending_validation` alone); the dedupe key uses the open set so a second pass raises no duplicate beside an instructed item; and the row offers no second **Decide** — the decision was made, the doing is elsewhere.

    Membership of a role-assignable *group* is unaffected: it is governable and reversible normally since COM-451, and `_human_reversal_instruction` returns nothing for it. Only the direct-to-person assignment has the dead end, exactly as the brief said.

    One small thing found on the way: a directory-role item is tenant-wide (no company), so it does not appear in a *company-filtered* action list — the same as `user_created` and `group_created` have always been. Pre-existing and out of scope here, but worth knowing if the action list is ever scoped differently.

    Migration 0133 appends three kinds and two statuses; the `ALTER TYPE` statements are written out rather than looped, since an f-string into a DDL string is the shape the SAST gate refuses.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Stacks on COM-452. Part 6 of COM-446, the new kinds.

Detection knows five kinds of change: a user created, a group created, a group deleted, a member added, a member removed. Two things that matter are missing entirely.

## What changes for the reader

**A departure Compass did not process gets noticed.** Somebody disabled in Entra and never run through a leaver is exactly the account that keeps its access, and today it leaves no trace here.

**A directory role changing hands gets noticed.** Today this is invisible in principle, not just in practice — a role assigned straight to a person is not a group membership, so no existing kind could ever catch it.

## Scope

**Unprocessed leaver.** An account disabled or deleted in the tenant with no executed leaver behind it. `user_created` exists; its opposite does not. Same dedupe and lookback idiom.

**Directory role gained or lost.** Needs COM-444, which mirrors directory roles and their assignments — with those records, diffing them pass over pass is the same shape as the membership diff that already exists. If COM-444 has not landed, this half waits; the leaver half does not depend on it.

**One ending has no execution.** "Flag for reversal" normally means Compass raises a corrective request and executes it. It cannot revoke a directory role assigned directly to a person — that is not a write it has. There, the honest ending is an instruction to a human to undo it in Entra, and the item stays open until reality agrees. Do not fake a resolution; an item that closes itself while the privilege is still held is the worst outcome this feature could produce.

Note that once COM-451 lands, membership of a role-assignable *group* is governable and reversible normally. Only the direct-to-person assignment has the dead end.

## Tests

Integration tests: an account disabled outside Compass raises an item; one disabled by an executed leaver does not; a role gained raises an item naming the role and the holder; flag-for-reversal on a direct assignment produces the human instruction and leaves the item open; the item closes when the next sync shows the role gone.