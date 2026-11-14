---
id: 01M7CNQ5RY6GE9BEFGFHXWJQV8
created: 2026-11-14T09:20:20.766393Z
updated: 2026-11-14T10:11:24.54243Z
type: task
title: A check waiting for review opens on its own full-width page, with a way back to the Review list where you left it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1813
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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