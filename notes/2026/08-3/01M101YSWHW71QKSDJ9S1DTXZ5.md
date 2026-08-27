---
id: 01M101YSWHW71QKSDJ9S1DTXZ5
created: 2026-08-26T22:09:55.089169Z
updated: 2026-08-27T21:54:59.462677Z
type: task
title: 'A sixth request kind: these principals join or leave these groups, for this reason'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 449
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: todo
---
Stacks on COM-448. Part 4 of COM-446, backend half.

Access requests come in five kinds, every one of them role-derived. Anything the role matrix cannot express happens in Entra, outside approval and outside detection. This adds the kind that closes that: an explicit membership change.

## What changes for the reader

**You can grant or remove one group without inventing a business role for it** — and it is approved, executed and audited exactly like everything else.

## Scope

**The request.** Principals joining and leaving named groups, with a reason. A mover already does this mechanically; this one is handed its group list rather than deriving it from roles.

**A principal can be a group.** "Including sub-groups" is genuinely new plumbing: the mirror has known about nested groups since COM-388, but execution has only ever written *users* into groups. Putting a group inside a group is a Graph write Compass has never made — new call, new failure modes, and a nesting cycle is now something the API has to refuse.

**Provenance on the write.** Everything executed here lands as **exception** provenance (COM-447), carrying the request, the requester, the approver and the reason. That is what stops COM-448's mover from removing it and what makes detection recognise it as requested.

**Everything else is reuse, deliberately.** Same approval by a second person, same standard/expedited orderings, same single write path in `tasks/access_execute.py`, same ledger, same per-subject result rows. The one write path is grep-provable today (ADR 0045 §5.1) and must stay that way — no API handler calls Graph.

**Removing an exception** is the same request in reverse, and clears the provenance record rather than leaving it dangling.

**Privileged groups stay refused here.** COM-451 opens them, behind the Access Admin gate. Until it lands, `_writable_group_ids` refuses them exactly as it does now.

## Tests

Integration tests: an exception grant executes and records exception provenance; a revoke clears it; a nested group is added; a cycle is refused; a role-assignable group is refused; approver ≠ requester still binds. The existing execution tests should keep passing untouched — if they do not, the shared path has been forked, which is the thing to avoid.