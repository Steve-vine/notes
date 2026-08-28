---
id: 01M101YSWHW71QKSDJ9S1DTXZ5
created: 2026-08-26T22:09:55.089169Z
updated: 2026-08-28T07:08:27.659633Z
type: task
title: 'A sixth request kind: these principals join or leave these groups, for this reason'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 449
sprint: snq23hz
comments:
- id: 01M12S19NP91HMS2WYP2F7XBNF
  author: Steve Vine
  at: 2026-08-27T23:31:42.902163Z
  text: |-
    Done — merged to main as ea44d64 (PR #465). Full CI green (one `npm ci` "Exit handler never called" on the frontend job; rerun clean — infrastructure, not a real failure).

    **The kind.** `membership_change`: one subject = one principal plus the groups it joins and leaves. A revoke is the same request in reverse, which is why both lists live on one subject. `directory_user_id` **or** `principal_group_id`, exactly one — kept apart from `group_id` (what a group_delete removes) because ADR 0045 §1's vocabulary rule is what keeps three meanings of "group" legible.

    **A reason is required in both orderings.** An exception with no stated reason is not an exception; it is an unexplained membership with an approval attached.

    **Provenance is the point.** Everything granted lands as `exception` carrying the request; a revoke clears the record rather than leaving it dangling. There is a test for the meeting-point that the sprint ordering exists to protect: grant an exception, then run a mover that drops the role — the membership survives and is *still* an exception afterwards, not silently re-attributed to a role that happens to grant the same group.

    **A principal may be a group.** `memberOf` hangs off `directoryObject`, so `_memberships_of` answers for a group exactly as for a user and the idempotent diff is unchanged. A nesting cycle is refused using `nested_group_closure`'s existing BFS — at raise time against the mirror and again at execution, since the nesting can change in between. `access_changes` gained `principal_group_id`: a nested add recorded against a null user would read as a change to nobody.

    **Reuse held.** No new approval path, no new ordering, no new write path. The one change to shared code was extracting `_execute_subject`'s dispatch into `_dispatch_kind` — the branch count crossed ruff's ceiling. **The existing execution tests pass untouched**, which is the check that the shared path has not been forked.

    **Privileged groups stay refused** exactly as ADR 0045 §5.3 wrote it, at raise time with a sentence naming the reason. COM-451 lifts it.

    Frontend is read-side only here: the kind label, and the request detail page rendering principal / Joining / Leaving with resolved group *names* — an approver reading GUIDs cannot judge a membership change. The raise affordances are COM-450.

    Migration 0130 appends the enum value in place (the 0093 precedent, no type rebuild). The downgrade drops the columns and **leaves the enum value**: rebuilding would mean deciding what to do with executed rows that record real tenant writes.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: done
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