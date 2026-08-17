---
id: 01M051DV9KDGYJFJBXJN6P3B2X
created: 2026-08-16T10:21:09.811041Z
updated: 2026-08-17T11:00:58.788238Z
type: task
title: Flag for review on an Assist chat — the same channel, a different subject
project: 01KX671DATY39VW6GWK3M2T3DN
number: 741
sprint: sevhjex
comments:
- id: 01M051TBRA5AMHGJHJHQCRAGFN
  author: Steve Vine
  at: 2026-08-16T10:27:59.882542Z
  text: |-
    DECIDED 2026-08-16 (Steve): "Flagging the request counts as consent."

    So the privacy question is settled the first way. Raising a flag on an Assist chat grants a reviewer access to that thread, and the flagged thread is readable from the Flagged-for-review list by operator-and-above, exactly like a flagged incident. No separate permission, no owner approval step, no redaction.

    Scope consequences:
    - The reviewer opens the flagged chat and reads it in full. Build the link to work, rather than carrying only the comment.
    - Consent is scoped to THE FLAGGED THREAD, not to the flagger's assist history. Reading one flagged chat must not become a route into that user's other threads — the owner-private rule still holds everywhere else, and the list should link to the specific thread rather than to a per-user view.
    - Still worth ONE LINE in the flag modal saying the chat becomes readable. Not to obtain consent — that is settled by the act — but because a tester has no reason to know assist threads were private to begin with, and a person who did not realise cannot be said to have chosen. Cheap, and it removes the only surprise available here.
    - Closing a flag deletes the row (ISE-731's behaviour). Decide whether access ends with it: the tidy answer is that consent expires when the flag is closed, so a closed flag stops being a standing key to that thread.
- id: 01M051VFVGAAV8AHTMYBPRY3RM
  author: Steve Vine
  at: 2026-08-16T10:28:36.848464Z
  text: |-
    DECIDED 2026-08-16 (Steve): access expires when the flag is closed.

    So the flag IS the grant. While a flag is open, a reviewer (operator-and-above) can read the flagged Assist thread; the moment it is closed the thread returns to owner-private and is no longer readable from the review surface.

    Implementation notes:
    - Since closing DELETES the row (ISE-731's deliberate behaviour — "the one place in ISE where destroy is the natural verb"), expiry falls out for free: no open flag, no grant. Nothing extra to store, and no expiry sweep to run. Worth stating in the code so a future change to soft-delete flags does not silently turn every closed flag back into a standing key.
    - Authorisation must therefore be checked against a LIVE flag at read time, not granted once at flag time. A reviewer holding an open thread page when the flag is closed should lose access on the next read rather than keeping it for the session.
    - Re-flagging re-grants. That is correct and needs no special handling: a second tester flagging the same thread opens a new grant, and closing one flag while another is open must not revoke access — the grant is "any open flag on this thread", not "the flag I happened to follow".
    - Worth auditing the read, not only the flag: with consent this narrow, "who read this private thread, and under which flag" is the question that would be asked if it ever mattered.
- id: 01M05AGP2FHKFWKNFPNZ8HWQ0C
  author: Steve Vine
  at: 2026-08-16T12:59:59.951635Z
  text: |-
    BUILT + MERGED 2026-08-16 — PR #689 (squashed to main), migration 0140, ADR 0104.

    **One subject-generic flag, as recommended.** `issue_review_flag` → `review_flag` with `kind` + `target_id` (`incident` | `assist_thread`), the `issue_suggestion_dismissal` precedent. Migration 0140 alters in place, so yesterday's flags come through as `incident` with the same ids and comments. One list, one page, one close action.

    **The read grant, per both decisions on this task.** Flagging is the consent; access expires when the flag is closed. Implemented as *the flag IS the grant*: authorisation asks for a live row on every read, so a reviewer holding the page open when the last flag is closed loses access on their next request. Because closing DELETES the row, expiry is free — nothing stored, no sweep — and that reasoning is written into the code so a future move to soft-delete flags does not silently turn every closed flag into a standing key. Scoped to the thread (the thread LIST stays owner-only); any open flag grants, so re-flagging re-grants and closing one flag while another stands revokes nothing; read-only (every write path is still `_owned_thread`); and the READ is audited as `flagged_chat_read` — who read which thread, under which flag.

    The reviewer gets a **separate read-only transcript page** (`/flagged-for-review/chats/:id`) rather than the Assist page with its controls hidden. Opening somebody else's conversation in Assist would put a reviewer one click from writing into it, with their own sidebar beside it. A closed flag renders there as the grant having ended, not as an error.

    **Two things the vanished CASCADE was quietly doing — both now explicit, and this was the real find.** `target_id` cannot be a foreign key, so `ON DELETE CASCADE` had to go, and with it went cleanup nobody had noticed was happening:
    - `reset_collected_data` deletes review flags itself now. Without that, a data reset would leave a review queue full of feedback about incidents and conversations that no longer exist.
    - The test fixture had to truncate `review_flag` explicitly — flags leaked from one test into the next, which is a real property of the data and not just of the fixture.
    - A flag now outlives its subject. That is honest for feedback (the comment is the thing being triaged), so the list resolves the subject at read time and says "no longer exists" rather than offering a dead link; the row can still be closed.

    **Audit action names.** They dropped the `issue_` prefix (`flagged_for_review`, `review_flag_closed`) now that a flag is not incident-only — and BOTH spellings stay in the incident timeline's exclusion set for ever, because the trail is append-only and every flag raised before the migration still carries the old name. Dropping it would have put those rows back into the narrative of an outage.

    Tests: the grant's boundaries end to end (flagged vs not, closing ends it on the NEXT read, a second flag keeps it alive, read-only, a viewer never gets it, the read is audited), the migration with rows in it (kind backfilled BEFORE the CHECK — Postgres validates a new CHECK against existing rows, so the other order passes on an empty table and fails on staging; constraint names checked by name after the rename; the downgrade dropping thread flags because the restored FK could not hold them), and the frontend queue with both kinds plus an orphaned subject.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
ISE-731 gave testers a way to say "this incident did not go as planned". Assist chats need the same thing: an Assist answer that goes wrong is exactly as worth reporting, and a tester has no way to say so. Requested 2026-08-16.

**Where ISE-731 landed.** `IssueReviewFlag` is keyed to an incident (`issue_id`), several flags per subject allowed on purpose, off the timeline, audited, and closing deletes the row — *"the one place in ISE where destroy is the natural verb"*. The Flagged-for-review page is a top-level item in the System nav section.

**So the model has to generalise.** An assist thread is not an incident. Two shapes:

- Widen to a **subject-generic flag** — `kind` + `target_id`, matching the `issue_suggestion_dismissal` precedent from ISE-688/689, where `target_id` is deliberately not an FK because it points at more than one table. One list, one page, one close action, one audit shape.
- Or add a second table and a second page, which duplicates all of it and means a reviewer works two queues.

Recommend the first. The flag is *"somebody should look at this"* — the subject is a detail of what they should look at, not a different feature. Widening now is cheap; ISE-731 shipped yesterday and the table is nearly empty.

**Scope**
- Generalise the model to carry a subject kind, migrating the existing incident flags.
- A **Flag for review** link on an Assist chat, matching the incident placement — out of the way of the working controls, not part of the conversation.
- One list, with the subject column naming what it points at and linking there: `IN-1360` for an incident, the thread's title or opening question for a chat. A bare id in a review queue is a row nobody opens.
- The comment box, multiple-flags-allowed, off-the-record storage, audit, and close-deletes behaviour all carry over unchanged.

**The privacy question, which is new.** An assist thread is **owner-private** — the codebase draws that line explicitly: *"an issue's conversation is part of working it, not owner-private like an assist thread."* A tester flagging their own chat is implicitly asking someone to read it, but the reviewer is then reading a private thread, and the list is operator-and-above rather than restricted to the owner.

That needs deciding, not defaulting:
- Flagging is consent to have *that thread* read — probably the right reading, but it should be said at the point of flagging rather than assumed.
- Or the flag carries only the comment and a link that still enforces owner-privacy, in which case the reviewer often cannot see what went wrong and the feature is much weaker.

Recommend the first, stated plainly in the modal: *flagging this chat lets an ISE administrator read it.* Silent access to a private thread is the kind of thing that is fine until the once it isn't.

Extends ISE-731.