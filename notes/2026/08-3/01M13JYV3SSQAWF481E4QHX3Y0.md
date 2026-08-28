---
id: 01M13JYV3SSQAWF481E4QHX3Y0
created: 2026-08-28T07:04:45.433279Z
updated: 2026-08-28T18:34:44.00031Z
type: task
title: Add several people to a group in one request, not one request each
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 478
sprint: snq23hz
comments:
- id: 01M14JM9F2PCX97QJF62JN91P4
  author: Steve Vine
  at: 2026-08-28T16:18:14.114343Z
  text: |-
    Done — merged to main as e235ea0 (PR #477). Full CI green.

    The person picker is a list, and the form emits one subject per person. Each still gets its own recorded outcome and its own provenance row pointing at the one request that decided them — nothing about the evidence trail is shared, only the asking. The reason is asked once for the batch.

    A group principal stays a single subject, with a test pinning it: nesting a group inside a group has different consequences (everyone in it inherits, removal means editing the nested group), and batching it would blur two things the members list already shows differently.

    **One deviation from this task as written.** It specified "a row per person, `JoinerRows` is the pattern"; I used a multi-select. A joiner row carries three fields so it genuinely needs rows; here a subject is one person and the groups and reason are shared, so rows would be ceremony around a list. Same subjects on the wire.

    **Worth recording, because it cost time.** The first two PRs for this (#476, #477 pre-rebase) sat with **no checks at all** and I misdiagnosed it as GitHub dropping `pull_request` events — I said so twice, and Steve was right to push back on it. The actual cause was a **merge conflict**: this branch and COM-481 both appended tests to the end of `tests/test_access_requests.py`. CI checks out `refs/pull/N/merge`, GitHub cannot produce that ref for a conflicting PR, and so no run is ever created — which from the outside is indistinguishable from a dropped event.

    The tell was `mergeable_state: dirty` on the PR, which I should have checked before reaching for an outage explanation. Runners were healthy and idle throughout; nothing was wrong with GitHub or the ARC scale set.

    Rebased onto main, kept both test blocks, 48 tests in that file pass. One npm registry timeout on the frontend job, rerun clean.
assignee: steve
company:
- moneypenny
label:
- follow_up
priority: medium
task_status: done
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
