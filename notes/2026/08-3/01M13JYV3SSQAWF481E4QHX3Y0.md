---
id: 01M13JYV3SSQAWF481E4QHX3Y0
created: 2026-08-28T07:04:45.433279Z
updated: 2026-08-28T07:04:49.010936Z
type: task
title: Add several people to a group in one request, not one request each
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 478
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- follow_up
priority: medium
task_status: todo
---
Follow-up from COM-449 / COM-450.

The membership-change form takes **one principal per request**, so adding five people to a group is five requests and five approvals. The request entity is already batch-aware — `access_requests` holds one-to-many subjects and the API accepts as many as you send — so this is a gap in the raise form alone, not in the model underneath it.

Nesting a group inside the target group already covers the case where the people happen to share a group. This is for when they do not.

## What changes for the reader

**You pick the people, not the person.** Add a row per person, say why once, and one approval covers the lot — the same shape a joiner batch already has.

## Scope

- **`access/RaiseRequestModal.tsx`** — the membership-change fields emit one subject per person instead of one subject full stop. `JoinerRows` in the same file is the pattern: a row per subject with an add/remove affordance, and the last row cannot be removed.
- **One reason for the batch**, not one per person. The reason is why the *change* is being made; asking five times for the same sentence is how a form teaches people to paste.
- **The group principal stays single.** Nesting a group inside a group is a different act with different consequences (everyone in it inherits, and removal means editing the nested group) — batching it would blur two things that already read differently on the members list.
- **Per-subject outcomes already work.** Execution reports per subject, so one refusal in a batch does not poison the rest; nothing needs to change there.

## Not in scope

The gate editor. It already round-trips `join_group_ids` / `leave_group_ids` per subject, and correcting a batch at the gate is the same code path.

## Tests

Component: several rows produce several subjects on one request; removing a row; the last row cannot be removed; one reason gates Submit for the whole batch. Integration: a two-person membership change executes both, records exception provenance against each, and one approval covers both.
