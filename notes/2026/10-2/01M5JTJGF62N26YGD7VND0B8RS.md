---
id: 01M5JTJGF62N26YGD7VND0B8RS
created: 2026-10-22T22:09:13.702542Z
updated: 2026-10-22T22:09:13.702542Z
type: task
title: Review a DDQ's answers — approve or send back each one, see what's held back and why, and an Admin can release a held-back item for this DDQ with a recorded reason
assignee: steve
priority: high
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1259
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

- **Submit for review** (owner) moves the DDQ to **In review**. Questions can still be answered.
- **Approve DDQ answers:** per question, **Approve** or **Send back** (with a comment; it goes back to Drafted). There's also **Approve all that can be given**. A held-back answer can't be approved.
- **Held back** (a tab with a count): every answer and evidence file that can't be given, with the reason ("Confidential — never shared", "Sensitive — no NDA in place", "Not classified").
- **Release for this DDQ** (Admin, *Release held-back information*): a reason is required. The release covers this item on this DDQ only. It's shown on the item ("Released by Steve Vine, 22 Oct: client is under contract, MSA §12"), it's permanent, and it's in History. The item's own classification doesn't change.
- **Ready to send** once every question is approved, or marked "Not answered" with a reason.

## Notes (technical)

- ddq_release: ddq, item (answer or file), by, reason, at. Append-only.
- The assistant cannot release (COM-1245 call 13); the API refuses a token-authenticated release.

**Done when:** an answer is sent back and re-approved; a held-back file is released by an Admin with a reason and no longer counts as held back; a non-admin can't release.