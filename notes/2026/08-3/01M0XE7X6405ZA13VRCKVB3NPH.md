---
id: 01M0XE7X6405ZA13VRCKVB3NPH
created: 2026-08-25T21:46:52.996467Z
updated: 2026-08-26T18:28:03.651412Z
type: task
title: Reminder email comes from your action list, not from nine separate scans
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 410
sprint: sbph5q5
blocked_by:
- 01M0XE78829JRERW98X1V1RJFS
comments:
- id: 01M0Z0KCD1SP1C4DPS4FFK81A9
  author: Steve Vine
  at: 2026-08-26T12:26:57.825501Z
  text: |-
    Done — PR #413, merged to main.

    The nine per-module scans are gone. One job now runs each person's action list and mails what has changed since the last time we wrote to them. If it is on your list you hear about it; if it is not, you don't.

    One cadence, decided once: told when something appears, again when it goes overdue, then weekly while it stays overdue. One place to configure it — daily / weekly / never, only overdue, only mine — in the user menu under Email preferences, and it covers modules that do not exist yet. And mail stops when the work does, because there is nothing left to derive it from.

    Urgent work still moves fast: the job runs hourly, so an approval waiting on a decision or an expedited access change reaches you within the hour rather than waiting for the daily digest.

    `vendor_info_requested` and `vendor_info_provided` are retired, as planned. Being asked a question is now your action; the answer arriving unblocks the approver's existing one. Blocked rows show as "Waiting on a reply" and are not chased while you cannot act on them.

    The vendor cadence expiry and the assessment auto-close moved out to their own job — they change rows rather than telling anyone anything, and leaving them in a file that is now entirely about mail is how the next mess starts.

    Two things worth knowing:

    **A pre-existing bug, fixed on the way past.** The Beat task registered as `generate_reminders` was actually wired to the recert-instance scan — the decorator sat above the wrong function. So the hourly reminder job has been calling the wrong thing with the wrong arguments. The rewrite removes it.

    **Admins now get Access validation reminders**, where the old scan only matched the access-manager role. That follows from an admin holding every module capability, and it is exactly what the new "only work assigned to me" preference is for. Say if you would rather admins were excluded from module-wide rows instead.

    Writing the tests turned up one real design bug before it shipped: an action that arrived already overdue would have been emailed twice on the same day, once to say it was overdue and once to say it was still overdue. The overdue notice and the weekly chase now share one week-keyed step.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: done
---
ADR 0055 §6 and §7. Depends on COM-409 — inverting the mail before every
source is declared would drop reminders people get today.

Nine scans in `tasks/reminders.py`, each deciding for itself who to tell, when,
and how often. Every new module adds another. Nothing keeps them consistent,
and a user has no one place to turn any of it down.

## What changes for the reader

Mail stops being something each module sends and becomes something your
**action list** sends. If it is on your list, you hear about it; if it is not,
you don't.

- **One cadence.** Told when an action appears, again when it goes overdue,
  then weekly while it stays overdue. Not nine opinions about nagging.
- **One place to configure** — daily / weekly / never, only overdue, only
  mine. Account settings, not per-module knobs, and it covers modules that do
  not exist yet.
- **Mail stops when the work does.** Derived, so a finished job stops
  generating mail instead of sitting in the bell until someone clears it.
- **Urgent work is still immediate.** A request waiting on a decision, an
  expedited access change against its SLA — sent as it appears. A
  certification expiring in six weeks waits for the digest. Each source
  declares which it is (declared in COM-409, honoured here). Without this the
  inversion would slow every approval in Compass by up to a day.

## Two notification kinds retire

`vendor_info_requested` and `vendor_info_provided` stop being their own
events. Being asked a question is the requester's **action**; the answer
arriving is the approver's existing decision action becoming **unblocked**. So
an action carries a blocked state, and unblocking is a mailable transition
alongside appearing and falling overdue.

## What still isn't action-driven

Terminal outcomes — "your request was approved", "your recertification is
complete". Nothing to close, so no action, and inventing a zero-duration
"acknowledge this" row to force them down the same pipe would make the to-do
list unreadable.

They go through the **same outbox**: one sender, one preference set, one set
of templates. Only the trigger differs. "All mail comes from one place" is the
property worth having and it holds; "all mail comes from an action row" does
not.

## Implementation

- `tasks/reminders.py` loses its per-module notification scans and becomes a
  digest job: run `_collect` per user, diff against the ledger, send.
- **`notifications` survives as the ledger of what we have already told whom**
  — written and read by the digest job, not by modules. This is the one real
  cost of deriving: without a memory, a permanently-open gap emails its owner
  every morning for a year. The existing dedup key
  `(user, kind, target, due_on)` is close to right; each cadence step
  (appeared / overdue / weekly-since) is its own entry, so re-running the scan
  the same day stays idempotent exactly as it is now.
- **Two scans in that module are not notifications and must not be folded in**
  — the vendor cadence expiry (which flips `compliance_status`) and the
  assessment auto-close. They change rows. Move them out to their own Beat
  task rather than leaving them in a file that is now about mail.
- Retire the due-date `NotificationKind` members as their scans go; keep the
  terminal-outcome ones.
- The bell reads the ledger, so check it still shows what it shows today after
  the writers change.

Tests: an action appearing mails once and not again the next day; going
overdue mails again; a closed action mails nothing; an immediate source sends
outside the digest; a blocked action unblocking mails its owner; a user with
mail off gets none of it while the ledger still records the action's state.
