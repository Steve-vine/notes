---
id: 01M190DWNAADRSB4PHDQY7AZX5
created: 2026-08-30T09:36:22.186928Z
updated: 2026-08-30T15:11:45.163651Z
type: task
title: A change Compass just made is visible immediately, not at the next sync
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 525
sprint: sz42uhw
comments:
- id: 01M193B66QF260BAMYHHNA04JE
  author: Steve Vine
  at: 2026-08-30T10:27:19.38307Z
  text: |-
    Shipped — PR #530, merged to main as 4bd44bd.

    All three writes now apply locally after Entra confirms and only then, the ordering group creation already used:

    - `member_added` / `member_removed` → a `DirectoryGroupMember` row, or a `DirectoryGroupNestedMember` one where the principal is a group.
    - `user_created` → a `DirectoryUser` for the joiner, which the role-implied memberships granted in the same breath now have to hang off. The adopted-account branch mirrors from what Entra says rather than what the request asked for, so its `$select` widened past the id.
    - `user_disabled` → `account_enabled` false on the leaver.

    `sessions_revoked` left alone — not a mirrored fact.

    Two guards keep the sync authoritative: `_mirror_account` is insert-only (an account already in the mirror is the sync's to describe), and a membership whose group or principal is not mirrored is skipped and left to the pass.

    **On the two things the task asked to check:**

    - **The COM-509 grace stays.** It closes the reported half — the provenance row is stamped and the membership now arrives with it. It does not close the half the comment already names: a full crawl that *began* before the write returns a member list without it, and would delete the membership row and the explanation behind it. Still load-bearing, so left alone (which also kept this diff clear of COM-524, same module).
    - **Out-of-band detection does get more precise** — a membership already in the mirror is never an added pair.

    One residual worth knowing rather than guarding speculatively: if a **full** pass crawls inside Entra's replication window for a brand-new joiner, `_upsert_users` marks the account vanished and counts it departed, leaving an unprocessed-leaver item behind. It self-corrects next pass; the window is seconds against a 15-minute cadence. Adding a vanish grace would be a mechanism where the task asked for one fewer, so it is flagged, not built.

    Every test asserts **before any sync pass runs**, and one runs a pass afterwards to prove it neither re-adds what Compass mirrored nor undoes its removal. `test_close_freezes_the_evidence` changed with the behaviour: a campaign raised over a group after an approved removal now scopes to the members still in it.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: high
task_status: done
---
Approve a request, look at the person, and nothing has changed. Up to 15 minutes later it appears. The change worked — Compass simply doesn't believe it yet, because it only learns what it did from the next mirror pass.

That is a real path to a mistake: the obvious reading of "no change" is that it failed, and the obvious response is to do it again.

## Why some things already appear at once

The execution task **already does this** for groups. Creating a group writes the `DirectoryGroup` row locally the moment Entra confirms it, with a comment saying why: a business role attaches to that group, and the foreign key behind the attachment cannot wait for a sync pass. Renaming a group and deleting one update the mirror too, as does correcting a user's details on an amendment.

Nothing conceptual separates those from the rest. They got solved because a foreign key forced the issue; the others had no forcing function and were left to the sync.

## What's missing

Three, all in `tasks/access_execute.py`:

* **`member_added` / `member_removed`** — `_add_member` (:223) and `_remove_member` (:231) call Graph and stop. No `DirectoryGroupMember` row is written or deleted. The one that prompted this.
* **`user_created`** — the joiner creates the account in Entra (:283) and records the ledger, but writes no `DirectoryUser`. A person hired through Compass does not exist in Compass until a pass finds them.
* **`user_disabled`** — the leaver patches `accountEnabled: false` (:425) and leaves the mirror saying the account is enabled. For up to 15 minutes Compass shows a leaver as an active account, which is the one of the three with governance weight.

`sessions_revoked` needs nothing — it isn't a mirrored fact.

## What changes

After Entra confirms the write, and only then, apply the same fact locally — the ordering group creation already uses. Graph first, mirror second, never the reverse.

The sync pass stays **authoritative**. This is not a second source of truth: if a local write and reality ever disagree, the next pass overwrites the local answer, exactly as it does for a group created this way today. The change is to how quickly Compass reflects what it just did, not to what is true.

## Worth checking while in here

* **The attribution grace may become unnecessary.** COM-509 added a one-hour protection because the provenance row is stamped at the point of the write while the membership isn't mirrored until later, so `reconcile()` was deleting the explanation before the thing it explained arrived. Write the membership at the same time and that window closes at the source. Verify rather than assume — the grace also covers an Entra write landing mid-pass — but if it holds, this removes a workaround rather than adding a mechanism.
* **Out-of-band detection gets more precise, not less.** A membership already in the mirror is not an *added pair* on the next pass, so it never reaches the unrequested-change lane at all. That is the correct outcome (it was requested) and is sturdier than the current time-window guard, which infers the same conclusion from "a request mentioned this recently".

## Not in scope

Changes made **directly in Entra**, outside Compass. Those cannot be mirrored optimistically — Compass doesn't know about them — and 15 minutes is the floor without subscribing to change notifications. Deliberately left as is: a change made outside Compass is one that should be landing in a review queue, not being reflected instantly and silently.

## Verifying

Per change kind: execute against a fake tenant, then assert the mirror carries the fact **before** any sync pass runs — a membership row present after an add and gone after a remove, a `DirectoryUser` after a joiner, `account_enabled` false after a leaver. Then run a pass and assert it doesn't duplicate, resurrect, or contradict what was written.
