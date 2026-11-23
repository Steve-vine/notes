---
id: 01M83R2FRW5G1TCPWH4RFTQHFJ
created: 2026-11-23T08:24:00.540737Z
updated: 2026-11-23T19:36:29.497001Z
type: task
title: As at on a register — the heading's entry count and Last reviewed, and Print this register, follow the chosen date, as the list does
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2103
sprint: ssj8zkq
comments:
- id: 01M83VWC60C7CT8G5PWQCC4YXE
  author: Steve Vine
  at: 2026-11-23T09:30:34.560568Z
  text: |-
    Built and merged to main: PR #2087 (e503be778).

    With As at set to a past day on the Entries tab:
    - The heading shows that day's entry count, from the server by the list's own rule, so filters and search don't change it.
    - Last reviewed shows the latest review by then, or "Last reviewed never".
    - Next review is hidden.
    - Print this register gives the register as it stood that day, and Activity records it as at that day.
    - While that day's figures load, none are shown. If they can't be read, the heading says so rather than falling back to today's.
    - Clearing the date, or leaving the Entries tab, goes back to today's figures and print.

    Tested: count, review and print on a past day, for shared and per-company registers, against real Postgres; a Restricted register's figures are refused to someone who can't open it; the screen's behaviour in frontend tests. CI green.

    Not yet checked in a browser on staging: that comes with the sprint's pre-UAT pass.
- id: 01M84EMVW4D3ZC05E72T1K2YNH
  author: Steve Vine
  at: 2026-11-23T14:58:31.428167Z
  text: |-
    Pre-UAT on staging e2248892e: PASSED (one line not checkable in a browser).

    Account: E2E Admin A, E2E Test Company. Test registers E2E UAT 122 Obligations (UOB, per company), Parties (UPA) and Shared (USH). To get a true past day I set Admin A's time zone to Darwin for the test, so 23 Nov had already ended at 14:30 UTC, then made changes after it. Time zone is back on UTC.

    - Heading count equals the unfiltered list, with entries added and archived since: PASSED. UOB reads 6 entries today and 5 as at 23 Nov (UOB-1 to 5). UOB-5 was archived after that day and shows; UOB-6 was archived by then and doesn't; UOB-7 was added later and doesn't.
    - Last reviewed shows the earlier review, or never: PASSED. UPA, first reviewed after that day, reads "Last reviewed never" as at 23 Nov and "23 Nov 2026 by E2E Admin A" today. UOB's pack and print show only the review made by then.
    - Next review hidden on a past day: PASSED.
    - Filtering or searching doesn't change the count: PASSED. Status = Met showed 2 rows and searching GDPR 1 row; the heading stayed at 5.
    - Print gives that day's register: PASSED. Printed while filtered to Met: "As at 23 November 2026", all 5 entries, UOB-1 still Met / 10, the since-removed Source column present, the later "Added later" column absent, last review on the cover.
    - Activity records the print as at that day: PASSED. Activity page: "exported register UOB · E2E UAT 122 Obligations as at 23 Nov 2026 to PDF (5 entries)".
    - Clearing the date restores today's figures and print without a reload: PASSED. Back to today returned 6 entries and Next review with no page load; the next print was today's, 6 entries with the new column.
    - Shared register: PASSED. USH reads 4 today and 3 as at 23 Nov.
    - Tests cover the count, review and print: COULDN'T CHECK. Not visible in a browser.

    Screenshots and PDFs: ~/compass-uat/sprint-122/COM-2103/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Sprint "Registers - Phase 2". Found in Claude's pre-UAT pass of sprint 121 (Registers) on staging 29d0849fc; Steve asked for it to be logged here (23 Nov 2026), and for Print this register to be included.

## The problem
With **As at** set to a past day, the list shows the register as it stood then, but the heading above it still shows today's entry count and today's "Last reviewed". A register can read "12 entries, last reviewed last week" above a list of 8 entries from before that review. **Print this register** also ignores the date and prints today's register, while the person is looking at a past day. Someone showing a past date to an auditor could quote or hand over the wrong version.

## What people see
With As at set to a past day, on the register's Entries tab:
- **Entry count**: the number of entries the register had at the end of that day, leaving out those archived by then. It matches the list when no filter or search is on, and a filter or search doesn't change it.
- **Last reviewed**: the latest review made on or before that day, with its date and reviewer. If there was none by then, it reads "Last reviewed never".
- **Next review** is not shown, because it's about today.
- **Print this register** gives the PDF of the register as it stood that day: every entry it had then, with their values then and every column it had then. The cover says "As at" that day and shows the last review by then. As today, it ignores the list's filters, search and chosen columns.
- Activity records the print as being as at that day, as it does for an export.
- Clear the date (or pick today) and the heading and Print go back to today's register straight away.
- A per-company register counts, reads the reviews and prints for the company being viewed, as it does today.

Unchanged: the heading's name, owner, Restricted and Archived marks, and "Kept for" still show the register as it is now. The As at note on the list already says the view is of a past day.

## Implementation notes (technical)
- The heading is in `pages/RegisterPage.tsx` and reads the register's current summary. As at lives in the URL (`as_at`), set in `registers/EntriesTab.tsx`; only treat it as active on the Entries tab and when it's before today, in the reader's time zone (same rule as `entry_query`).
- `reviews.last_reviews(..., as_at=)` already filters by moment (COM-2101). Use `end_of_day(day, zone)`, as the entry list does.
- The count must use the same as-at rule as the entry list, so the two can't disagree. Return it from the server; don't count rows in the browser, because filters change those.
- Keep the heading from flashing today's figures while the past-day figures load.
- Restricted registers: same server-side access check as the register today.
- Print: `printUrl` in `registers/entryHooks.ts` hard-codes `asAt: ''`. Give it the active as-at day. The export route already handles the day, the cover, the last review and the Activity wording, so no new print route is needed.

## Done when
- On a past day, the heading's entry count equals the unfiltered list's count, including when entries were added or archived after that day.
- On a past day before the latest review, Last reviewed shows the earlier review, or "never" if there wasn't one.
- Next review is hidden on a past day.
- Filtering or searching the past-day list doesn't change the heading's count.
- On a past day, Print this register downloads that day's register: its entries, values and columns then, with "As at" that day and the last review by then on the cover, whatever the list is filtered to.
- Activity records the print as at that day.
- Clearing the date restores today's figures and today's print without a reload.
- Tests cover the count, the review and the print link on a past day, per-company and shared.

On the chain: API change, no migration.