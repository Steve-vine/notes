---
id: 01M5JTJGF62N26YGD7VND0B8RS
created: 2026-10-22T22:09:13.702542Z
updated: 2026-10-23T12:43:38.383971Z
type: task
title: Review a DDQ's answers — approve or send back each one, see what's held back and why, and an Admin can release a held-back item for this DDQ with a recorded reason
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1259
sprint: s5uw2fz
blocked_by:
- 01M5JTJ9HBRRR883Y86T9B025R
comments:
- id: 01M5MCKJH8TVHBRFYW6SKBTN19
  author: Steve Vine
  at: 2026-10-23T12:43:37.384171Z
  text: |-
    Done — merged in #1275 (ea7b6db8, migration 0655_ddq_review).

    - A **Review** card on the DDQ: "Not yet submitted for review", "In review" or **Ready to send**, with progress ("12 of 14 approved, 2 not answered") and how many items are held back. **Submit for review** (owner) and **Approve all that can be given** (approvers).
    - On a question: **Approve**, **Send back** (asks what needs changing), **Mark Not answered** (asks why), and who approved it / sent it back and why.
    - A held-back answer can't be approved, and the box says why ("Held back, so it can't be approved: Incident Response Plan: Confidential — never shared").
    - A **Held back · n** card lists every answer and evidence file that can't go to this client, with the reason and the questions it's on.
    - An Admin gets **Release for this DDQ** on each, with a required reason; it then reads "Released by Steve Vine, 22 Oct 2026: client is under contract, MSA §12", no longer counts as held back, and can be approved. Permanent, in History, this DDQ only, classification unchanged. **The assistant and API tokens can't release.**
    - Not answered counts as done for Ready to send; answering it later puts it back to Drafted.

    My calls:
    - Editing an approved answer makes a new version and sends the question back for re-approval.
    - Approving needs the DDQ In review; release and Not answered work while it's open.
    - An answer release covers that version only — an edited answer is judged again. An evidence release covers that file wherever it's attached on this DDQ.
    - No self-approval rule (as the library).
    - Release needs the person's own browser session — the assistant and API tokens are both refused.
assignee: steve
label:
- feature
priority: high
task_status: review
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