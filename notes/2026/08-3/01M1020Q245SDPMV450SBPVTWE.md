---
id: 01M1020Q245SDPMV450SBPVTWE
created: 2026-08-26T22:10:57.732642Z
updated: 2026-08-27T21:55:03.196304Z
type: task
title: Detection learns two changes it cannot see today — an unprocessed leaver, and a directory role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 453
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: todo
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