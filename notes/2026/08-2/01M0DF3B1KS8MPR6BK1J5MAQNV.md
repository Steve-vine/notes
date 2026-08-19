---
id: 01M0DF3B1KS8MPR6BK1J5MAQNV
created: 2026-08-19T16:54:01.011227Z
updated: 2026-08-19T23:16:24.340072Z
type: task
title: The transcript — questions and answers both persist, and stop overwriting each other
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 295
sprint: sbph5q5
blocked_by:
- 01M0DF2TEXS5KWVE6YJVCKM60F
comments:
- id: 01M0E4ZG5AAMX45HT37K2S116C
  author: Steve Vine
  at: 2026-08-19T23:16:23.850458Z
  text: |-
    Shipped in PR #290, merged to main as 866aea8.

    `vendor_request_messages` (migration **0086**) — request, nullable approval (a question belongs to the area that asked it; a response is to the request as a whole), author `SET NULL` with the name denormalised at write time, kind, body. Ordered by `created_at` alone, which is safe here in a way it was not for COM-219's contacts: messages are written one per transaction, so two cannot share a Postgres `now()`.

    The backfill turns every existing `vendor_approvals.comment` into the first `question` message on its approval, **dated from the approval's `decided_at`** rather than the migration's clock — the question was asked when it was asked. A null or whitespace-only comment is not a question and is skipped. `comment` stays as the *latest* question for the surfaces that read it, written alongside the message; retiring the column is the follow-up.

    `POST /{id}/respond` gives the requester words to answer with — `resubmit` took no body, so this half of the loop simply did not exist. Both entry points call one `reopen_after_answer()` helper, so `resubmit` was not left as a second way to do the same thing; it was marked deprecated and **COM-298 deleted it**.

    Read routes are **per vendor**, not per request: the exchange outlives the request it happened in. Internal for managers; a narrow owner-gated `/api/v1/portal/*` route for owners.

    **Not in the activity log.** Messages are correspondence, not a state change, and the table is already append-only, actor-stamped and read back on the vendor record — a log row would duplicate the record rather than audit it. Worth correcting the task's premise: `vendor_approvals` and `vendor_onboarding_requests` are **not** in the audit allowlist either, because the approvals *are* the trail of who decided what.

    Tests: asking twice appends and the first question survives (the first test, since it is the defect this exists for); a response derives `updated` and re-notifies; 403 for a non-requester, 422 on an empty body, 409 outside `info_requested`; the portal route serves an owner and refuses a non-owner while the rest of the record still reads for them; the backfill produces one message per real comment at the right timestamp.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The info loop has nowhere to keep a conversation. An approver's question is a single `vendor_approvals.comment` column, so **asking a second question overwrites the first** — silently, with no audit row. And a requester has no way to answer in words at all: `resubmit` takes no request body, and `justification` is written once at submission and never again.

Give the loop a transcript. This is what the cancelled chat tasks (COM-291…293) were reaching for, put where it belongs — inside the process that already exists rather than beside it.

- [ ] **`vendor_request_messages`** — `request_id`, `approval_id` (nullable: a question belongs to an area, a general response may not), `author_id` (FK users `SET NULL` — a message outlives its author's account, as `requested_by` does), `body`, `kind` (`question` | `response`), `CompanyScopedMixin` + `TimestampMixin`. Migration takes the next free number.
- [ ] **Order by `created_at`**, with a comment saying why that is safe: messages are written one per transaction, so unlike COM-219's contacts they cannot share a `now()` and need no `position`.
- [ ] **Backfill from `vendor_approvals.comment`** — every existing comment becomes the first `question` message on its approval, so no transcript starts empty on a request that has already had one.
- [ ] **`comment` stays** as the *latest* question for the existing surfaces, written alongside the message rather than instead of it. Retiring it is a bigger change than this task; note it as the follow-up rather than doing it here.
- [ ] **Asking again appends** instead of clobbering. This is the defect the transcript exists to fix, so it should be the first test.
- [ ] **A `respond` endpoint** — the requester (or an owner) posts a `response` message. It reopens the loop the way `resubmit` does: `info_requested` approvals move to `updated` (COM-294), approvers are re-notified. `resubmit`'s body-less POST is superseded by this; keep the route working or remove it deliberately, but do not leave two ways to do the same thing.
- [ ] **Read routes** for the transcript, per vendor (not per request) — the box on the vendor record spans every request that vendor has had. Internal router for managers; `/api/v1/portal/*` for owners, gated on `vendor_ownership.is_owner`, a narrow route rather than a widened `require_portal_read` (ADR 0040's lesson).
- [ ] Decide whether messages join the **activity log**. They are correspondence, not a state change — but the state changes they trigger already are.
- [ ] OpenAPI regenerated → `schema.d.ts`.
- [ ] Tests: a second question appends and the first survives; the backfill produces one message per existing comment; a response moves the approvals to `updated` and re-notifies; a non-owner portal reader gets 403 on the transcript.