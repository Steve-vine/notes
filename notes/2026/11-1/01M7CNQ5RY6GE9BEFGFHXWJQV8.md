---
id: 01M7CNQ5RY6GE9BEFGFHXWJQV8
created: 2026-11-14T09:20:20.766393Z
updated: 2026-11-14T13:51:03.120869Z
type: task
title: A check waiting for review opens on its own full-width page, with a way back to the Review list where you left it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1813
sprint: spsp226
comments:
- id: 01M7CXEC1WQS54TNNK3BGT3ZAT
  author: Steve Vine
  at: 2026-11-14T11:35:20.892189Z
  text: |-
    Built — PR #1813 (86ed2dd6 after restack onto main), auto-merge on. Frontend only.

    What you now see:
    - Checks ▸ Review stays the list. Clicking a row opens that item on its own page (/checks/review/<id>) at full window width, with everything the modal had: "n of N", CHK-n, the control and its guidance, "waiting over 30 days", Ask Polaris, the reads, the field ticks, Edit query and a fresh sample, Approve / Discard.
    - The list's group, filters, batch and order travel in the page's address, so "n of N", Previous / Next and A / D / ← → follow the list as shown, and a refresh keeps it.
    - "Back to Review", the trail and browser Back return to the list as it was left. Moving between items doesn't add browser history, so Back always goes to the list.
    - Deciding one moves to the next; deciding the last goes back to the list.
    - Old item links (from Polaris and search) open the page. An item already decided shows "This is no longer waiting for review" with a way back.
    - At 1440 px a 10-field (and 14-field) sample shows with no sideways scroll; the first column stays in view when the table does scroll (measured in headless Chromium).

    Choices: the sample table is now one shared component (collection/SampleTable.tsx) with a hook for column headers, so COM-1814's Rename and COM-1816's lookup names are added once. The batch banner's "See what it has proposed so far" still opens the list cut to that batch (it's a list, not one item). The backend still produces old-style item links; the front end redirects them.

    Tests: new vitests for list → page → Back with filter and order kept, opening from the address, an already-decided item, an old link, next-after-decision and back-after-last; 147 targeted tests pass; eslint/tsc/prettier clean. New Browser smoke step opens a review item (or a decided one if nothing is waiting in E2E Test Company) and follows Back to Review. Not yet seen on staging.
- id: 01M7D56VEGMETZBWFMRD8RF4B6
  author: Steve Vine
  at: 2026-11-14T13:51:03.12063Z
  text: |-
    Pre-UAT on staging 53965a3b (E2E Test Company, 1440×900): **Passed with one defect** → fixed forward in a new task.

    Seen: Review ▸ New checks ▸ CHK-1 opens /checks/review/<id>?group=new_checks, full width (content 1440 px, table area 1382 px, no sideways page scroll), with "1 of 1", CHK-1, control + guidance, Ask Polaris, Previous/Next, ticks, Edit query, sample, Approve/Discard. Refresh keeps it; first column and header stay in view while the table scrolls. With Reads = Microsoft 365 the filter travels to the page and back; Back to Review, the trail and browser Back all return with group + filter kept. An unknown/decided id shows "This is no longer waiting for review…" with Back to Review. Viewer sees only Previous/Next/Hide guidance; A and → as Viewer send nothing.

    Defect: the shared sample table squeezes a column with a short header — CHK-1's `id` column is 53 px wide, its long values (PIM_3f7f72a0-…_134382049631256470) break a few characters per line, rows ~410 px tall, ~2 rows on screen. Same table inline on the Evidence tab. Also on real field names (e.g. initiatedBy.app.servicePrincipalId, ~285 px headers) 10 columns need ~1749 px vs 1382 available, so "10 fields fit at 1440" only holds for short names. Screenshots ~/compass-uat/spsp226/COM-1813/COM-1813-02-sample-table.png, -03-sample-table-head.png.

    Couldn't check: Previous/Next and ←/→ across items (every group holds one item), A/D and last-decision-returns-to-list (no decisions made on shared test items), scroll position on return (list too short).
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
## What happened

On 2026-11-14, while testing Checks, Steve opened a check to review it from **Checks ▸ Review**. It opened in a modal far too narrow for it. The sample table (one column per field Compass would keep) is much wider than the modal, so the thing being reviewed can't be seen properly. Steve: "full screen would be better".

## What people see

1. **Review tab = the list.** Checks ▸ Review keeps its list of what's waiting, in the groups it has today (and "From this batch" while a batch runs). Bulk actions on the groups that are approved together stay as they are.
2. **Opening one takes the full screen.** Clicking a row opens that proposal on its own page, not a modal, with its own address, so it can be linked and survives a refresh. The page uses the whole browser width, not the usual page width. It has everything the modal has today: "3 of 14", the CHK-n ID, the control, "out of date", Ask Polaris, the reads, the sample table with the field ticks, hand edits and a fresh sample (COM-1806), and Approve / Discard.
3. **The sample table uses the width.** It fills the page and only scrolls sideways beyond that. Its first column stays in view while it scrolls.
4. **Getting back.** A "Back to Review" link at the top (and the trail, and the browser's Back button) returns to the list with the same group, batch filter and scroll position.
5. **Moving through them.** Previous / Next and the keys (A approves, D discards, ← →) still work on the page. Approving or discarding moves to the next one. When none are left, it goes back to the list with "Nothing is waiting for review".
6. **Anywhere else a waiting check is opened to review** (the Polaris panel, an Actions item, the batch banner's "what's proposed so far") goes to this same page.

## Note for the builder

Corrected 2026-11-14 10:15: my first note was written against a stale local checkout. On origin/main (= staging f90e6b29), `checks/ReviewTab.tsx` opens each item in a Mantine `<Modal opened size="xl">` (around line 604) with the "n of N" title, Previous / Next, Ask Polaris and `ReviewOne`. Replace that modal with a routed full-width page (e.g. `/checks/review/:id`) that carries the same contents and keys. Follow *Screen conventions* in `brief/information-architecture.md` for the page header and trail; the page may opt out of the usual content width.

## Done when

- Each item on Review opens a full-screen page with its own address, not a modal.
- "Back to Review", the trail and browser Back return to the list with the same filter and position.
- Previous / Next and the A / D / ← → keys work on the page, and the last decision returns to the list.
- On a 1440-pixel-wide screen, the sample table for a check with about 10 fields shows without scrolling sideways.
- There are vitest tests for the list → page → back round trip and for the next-after-decision behaviour, plus a Browser smoke entry for the new page.

**Independent** (front end only, no migration or API change).