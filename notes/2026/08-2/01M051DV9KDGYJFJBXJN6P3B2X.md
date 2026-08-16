---
id: 01M051DV9KDGYJFJBXJN6P3B2X
created: 2026-08-16T10:21:09.811041Z
updated: 2026-08-16T10:21:09.811041Z
type: task
title: Flag for review on an Assist chat — the same channel, a different subject
priority: medium
assignee: steve
label: feature
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 741
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