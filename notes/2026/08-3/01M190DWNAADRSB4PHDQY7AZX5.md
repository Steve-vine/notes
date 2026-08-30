---
id: 01M190DWNAADRSB4PHDQY7AZX5
created: 2026-08-30T09:36:22.186928Z
updated: 2026-08-30T09:36:28.490556Z
type: task
title: A change Compass just made is visible immediately, not at the next sync
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 525
sprint: sz42uhw
assignee: steve
company:
- moneypenny
label:
- improvement
priority: high
task_status: todo
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
