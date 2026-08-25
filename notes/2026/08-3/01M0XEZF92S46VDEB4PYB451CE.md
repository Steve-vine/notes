---
id: 01M0XEZF92S46VDEB4PYB451CE
created: 2026-08-25T21:59:45.186757Z
updated: 2026-08-25T21:59:45.186757Z
type: task
title: Notifications becomes a page — what happened, never what you have to do
company: moneypenny
assignee: steve
priority: medium
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 412
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
