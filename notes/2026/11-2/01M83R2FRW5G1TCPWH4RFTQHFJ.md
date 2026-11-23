---
id: 01M83R2FRW5G1TCPWH4RFTQHFJ
created: 2026-11-23T08:24:00.540737Z
updated: 2026-11-23T08:24:02.079224Z
type: task
title: As at on a register — the heading's entry count and Last reviewed follow the chosen date, as the list does
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2103
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Sprint "Registers - Phase 2". Found in Claude's pre-UAT pass of sprint 121 (Registers) on staging 29d0849fc; Steve asked for it to be logged here (23 Nov 2026).

## The problem
With **As at** set to a past day, the list shows the register as it stood then, but the heading above it still shows today's entry count and today's "Last reviewed". A register can read "12 entries, last reviewed last week" above a list of 8 entries from before that review. Someone showing a past date to an auditor could quote the wrong figure.

## What people see
With As at set to a past day, on the register's Entries tab:
- **Entry count**: the number of entries the register had at the end of that day, leaving out those archived by then. It matches the list when no filter or search is on, and a filter or search doesn't change it.
- **Last reviewed**: the latest review made on or before that day, with its date and reviewer. If there was none by then, it reads "Last reviewed never".
- **Next review** is not shown, because it's about today.
- Clear the date (or pick today) and the heading goes back to today's figures straight away.
- A per-company register counts and reads the reviews of the company being viewed, as it does today.

Unchanged: the heading's name, owner, Restricted and Archived marks, and "Kept for" still show the register as it is now. The As at note on the list already says the view is of a past day.

## Implementation notes (technical)
- The heading is in `pages/RegisterPage.tsx` and reads the register's current summary. As at lives in the URL (`as_at`), set in `registers/EntriesTab.tsx`; only treat it as active on the Entries tab and when it's before today, in the reader's time zone (same rule as `entry_query`).
- `reviews.last_reviews(..., as_at=)` already filters by moment (COM-2101). Use `end_of_day(day, zone)`, as the entry list does.
- The count must use the same as-at rule as the entry list, so the two can't disagree. Return it from the server; don't count rows in the browser, because filters change those.
- Keep the heading from flashing today's figures while the past-day figures load.
- Restricted registers: same server-side access check as the register today.

## Done when
- On a past day, the heading's entry count equals the unfiltered list's count, including when entries were added or archived after that day.
- On a past day before the latest review, Last reviewed shows the earlier review, or "never" if there wasn't one.
- Next review is hidden on a past day.
- Filtering or searching the past-day list doesn't change the heading's count.
- Clearing the date restores today's figures without a reload.
- Tests cover the count and the review on a past day, per-company and shared.

On the chain: API change, no migration.