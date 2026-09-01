---
id: 01M0XEZF92S46VDEB4PYB451CE
created: 2026-08-25T21:59:45.186757Z
updated: 2026-09-01T13:55:52.537674Z
type: task
title: Notifications becomes a page — what happened, never what you have to do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 412
sprint: sbph5q5
blocked_by:
- 01M0XE7X6405ZA13VRCKVB3NPH
comments:
- id: 01M0Z1RP5C379MVE32D7HVN3DN
  author: Steve Vine
  at: 2026-08-26T12:47:20.236345Z
  text: |-
    Done — PR #415, merged to main.

    There is a Notifications page now, reached from the bell, listing what has happened that needed nothing from you. The whole list rather than the last few, with unread filtering and a read state that means something — reading is the entire interaction, because nothing here is waiting on you. Internal and portal both, with links built for whichever shell you are in.

    Each entry links to the thing itself rather than to its section. The bell used to send anything vendor-shaped to /vendors and leave you to find it.

    The rule holds by construction: a row is either feed or ledger, on the row itself, not worked out from which notification kinds happen to be left. A kind list would have been one merge away from letting a reminder into the feed, and the only symptom would have been people quietly seeing their work twice. The unread count now means unread news, so it stops counting reminders — the queue is where work is counted.

    Read entries age out after 30 days. The digest's ledger rows are exempt: deleting one would restart that action's cadence, so the owner of a year-old gap would be emailed about it as though it had just appeared. Unread entries are never trimmed either.

    Three things to flag:

    **Two more notification kinds retired** — "a request awaits your approval" and "your vendor needs your approval". Both are actions, and the rule forbids the same item being in both places. This was not in the task text, but §8's rule cannot hold while they are still written.

    **Approval emails now come from the hourly digest** rather than instantly at submission, so up to an hour later than today. In exchange they stop when the work does, are configurable in one place, and land on the approver's queue immediately either way. It also means Beat being down costs approval mail, where before it did not. If the hour matters, the fix is a shorter digest interval, not a return to inline notices — say the word.

    **Existing bells will empty on deploy.** The migration marks every old reminder as not-feed, because those reminders are rows in the action queue now. Leaving them would mean the feed launches already breaking its one rule.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
ADR 0055 §8. Depends on COM-410 — until the due-date notification kinds
retire, a feed would list the same things the action queue does, which is the
one thing §8 forbids.

Actions answers *what must I do*. This answers *what happened*. Today the
second question has only a bell showing the most recent few, and it is mixed
in with the first.

## What changes for the reader

A **Notifications** page, reached from the bell, listing what has happened
that needed nothing from you — your request was approved, a vendor you own
was reassigned, a recertification campaign closed, someone withdrew a request
against your vendor.

- The whole list, not the last few, with unread filtering and mark-as-read
  that means something. Reading is the entire interaction here: nothing is
  waiting on you.
- Each entry links to **the thing itself**, not to its section. The bell
  navigates to `/vendors` for anything vendor-shaped and leaves the reader to
  find it; a page has room to do better.
- Entries age out. A thing that happened is stale after a month; an action is
  never stale while it is open. Retention policy here, none on the queue.

Available to every authenticated user, internal and portal alike — the bell
already is.

## The rule

**If it is on your action list, it is not in this feed.** No item appears in
both, ever. The feed carries only what needed no doing.

This is what stops the two surfaces competing. Get it wrong and people learn
to check both places for everything, which is worse than the single narrow
list we have now.

## Implementation

The `notifications` table does two jobs after COM-410: it is the **digest
ledger** (what we have already told whom about an action) and the **feed**
(things that happened). Only the second is user-facing.

- Distinguish them on the row — an explicit flag or column, not "whichever
  kinds happen to be left". A kind list would be one merge away from a ledger
  entry appearing in the feed, and the failure is silent.
- `list_notifications` and `unread-count` filter to feed rows. The ledger is
  read only by the digest job.
- Unread count means unread *feed* items, so it stops counting reminders about
  work — which is right: the queue is where work is counted.
- Retention: a Beat job trimming read feed entries past the window. Ledger
  rows are **not** subject to it — the digest needs its memory for as long as
  the action is open.

Frontend: a page at `/notifications`, and the bell's "see all" points at it.
Reuse the list rendering; the per-item deep links are the real work, and they
need a portal variant exactly as COM-411's do.

Tests: a ledger row never appears in the feed or the unread count; an action
and its reminder produce no feed entry; a terminal outcome does; retention
trims read feed entries and leaves ledger rows alone; a portal user sees their
own feed with portal links.
