---
id: 01M4B0BTNGPSDX0ZTERGX1C5T8
created: 2026-10-07T11:00:48.944156Z
updated: 2026-10-07T11:00:48.944156Z
type: task
title: A request's timeline shows when it actually finished — and what it was waiting for in between
assignee: steve
label: improvement
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 852
---
Asked for by Steve after smoke-testing sprint 63 on staging, 2026-10-07: *"On a request timeline, I can see time Raised, Approved and Executed. Time complete/validated isn't shown, so any change that required waiting for the sync to complete isn't shown as such."*

Follows COM-847 (a request's status says how the job is going). That made the **status pill** honest about waiting; the **timeline** underneath was left as it was.

## Why

"Executed" on the timeline is the moment Compass ran its own part. For most requests that is also the moment the job was finished. For some it is not:

- a new starter made in Active Directory, whose cloud groups, lists and mailboxes are applied only once the account has synced to Entra;
- anything with a change somebody has to make by hand in AD, which is finished when Compass sees it (or does it itself, or the person says it's done).

For those, the timeline ends at "Executed" and never says when the job was actually done. A request that took four hours to finish reads exactly like one that finished in a second, and afterwards nobody can tell that it waited, for what, or for how long.

## What people see

After **Executed**, the timeline carries on for as long as the request does:

- **While it is waiting**, an entry says what for, and since when:
  - *Waiting for the account to reach Entra — since 14:02*
  - *Waiting on 2 changes to be made by hand in AD — since 14:02*
- **When each wait ends**, the entry becomes what happened, with its time:
  - *Cloud access applied — 14:31* (the account arrived and Compass finished the job)
  - *Changes made in AD — confirmed 16:10* — and how: seen in the directory, done by Compass, or marked done by a named person where Compass couldn't check.
- **Completed — 16:10** is the last entry once nothing is outstanding: the time the whole job was done.
- A request that finished the moment it ran shows a single **Executed** entry, as now — no separate "Completed" a second later.
- Validation is unchanged: *Validation due* and *Validated* still appear for requests that need it, after Completed.

## What's permanent

The completion time is recorded when it happens and never changes. It is the time to quote when asked "when did this person actually get their access".

## Decisions taken (say if any is wrong)

- **"Completed" is separate from "Executed" only when the two differ.** One entry when the request finished at once, so the common case stays as short as it is today.
- **Completed means nothing is outstanding** — no account still on its way to Entra, no to-do still open. It is the same rule the status pill uses to read "Executed" (COM-847), so the pill and the timeline can't disagree.
- **Validation is not part of "Completed".** A change can be complete and still awaiting its second pair of eyes; they stay two entries.
- **A scheduled account deletion is not part of "Completed" either** — it has its own entries already (due / deleted / cancelled).
- **Requests that finished before this ships:** where the finish time can be worked out it is filled in (the last to-do's confirmation time). A hybrid joiner that waited on Entra before this shipped has no record of when that wait ended; it shows "Executed" only, as today, rather than a made-up time.
- **Not in this task:** failed attempts and retries on the timeline; a "Completed" column or "time to complete" on the Requests list. Follow-ons if wanted.

## Notes (technical)

- Timeline: `RequestTimeline` in `app/frontend/src/access/RequestDetailPage.tsx` — entries are built from `created_at`, `gate_edited_at`, `scheduled_for`, `decided_at`, `executed_at`, the deletion fields, `validation_due_at`, `validated_at`. Nothing between `executed_at` and validation.
- What exists: `access_requests.executed_at` (set in `_finish`, `tasks/access_execute.py`); `access_request_subjects.awaiting_entra_since` — set when the cloud side is deferred and **cleared to null** when `_finish_joiners_awaiting_entra` completes it, so the end of the wait is recorded nowhere; `access_manual_steps.created_at / marked_done_at / marked_done_by / resolved_at / resolved_by_compass`.
- Recommended: store it, don't derive it on read.
  - `access_request_subjects.entra_finished_at` — set where `awaiting_entra_since` is cleared; keep the start too (don't null it, or add `awaited_entra_from`) so the timeline can say "since".
  - `access_requests.completed_at` — set by **one** function ("is anything still outstanding?") called from each place a wait can end: `_finish` (nothing was deferred), `_finish_joiners_awaiting_entra`, `manual_steps.land` (the last open step of the request), and `cannot_do` must not set it. Idempotent: set once, never moved.
  - The predicate must be the one `display_status` uses for `awaiting_entra` / `awaiting_manual` (ADR 0087) — share it, don't copy it (the COM-486 lesson: two copies of a rule drift).
- Migration: add the columns; backfill `completed_at` = `executed_at` for executed requests with no manual steps and no subject still awaiting Entra; = max(step `resolved_at`) where every step is closed; leave null where a step is still open or a subject is still waiting. CI migrates a fresh DB only — run the backfill against a copy of staging and put the counts in the PR. Revision id ≤ 32 chars.
- API: `completed_at` on the request, `entra_finished_at` (and the wait's start) on the subject; the timeline reads to-do times from `manual_steps` already on each subject. Regenerate `schema.d.ts`, run the drift script.
- A to-do closed on a person's word (COM-849, no AD connection) reads "marked done by …", not "seen in the directory" — reuse `onTheirWord` in `ManualSteps.tsx`.
- Several subjects: the request's waiting entries summarise across subjects (earliest start, latest end); per-subject detail stays in the subject's own block.

## Done when

- A hybrid joiner's timeline shows Executed, then waiting for Entra with its start time, then "Cloud access applied" and "Completed" with theirs.
- A request with to-dos shows the wait and how and when each was confirmed, then Completed.
- A request that finished at once shows one Executed entry and no extra line.
- The completion time is stored, set once, and agrees with the status pill.
- Tests: the completion moment through each path (nothing deferred, Entra wait, to-do seen / done by Compass / marked done, can't-do never completes); the timeline for each; the backfill rules.
- Smoke-tested on staging: raise a hybrid joiner, watch the timeline through the sync.