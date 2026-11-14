---
id: 01M7CNQ5RY6GE9BEFGFHXWJQV8
created: 2026-11-14T09:20:20.766393Z
updated: 2026-11-14T09:20:23.574824Z
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

On 2026-11-14, while testing Checks, Steve found that a check waiting for review opens in a window that's far too narrow for it. The sample table (one column per field Compass would keep) is much wider than the window, so the thing being reviewed can't be seen properly.

## What people see

1. **Review tab = a list.** Checks ▸ Review lists what's waiting, in the groups it has today (and "From this batch" while a batch runs). Each row shows the control, the check's name, why Polaris proposed it, and "out of date" where it applies. Bulk actions on the groups that are approved together stay as they are.
2. **Opening one takes the main screen.** Clicking a row opens that proposal on its own page, at the full width of the screen and with its own address, so it can be linked and survives a refresh. The page has what the review card has today: the reads, the sample table with the field ticks, "Ask Polaris", hand edits and a fresh sample (COM-1806), and Approve / Discard.
3. **The sample table uses the width.** It fills the page and only scrolls sideways beyond that. Its first column stays in view while it scrolls.
4. **Getting back.** A "Back to Review" link at the top (and the trail, and the browser's Back button) returns to the list with the same group, batch filter and scroll position.
5. **Moving through them.** Previous / Next, "3 of 14", and the keys (A approves, D discards, ← →) still work on the page. Approving or discarding moves to the next one. When none are left, it goes back to the list with "Nothing is waiting for review".
6. **Anywhere else a waiting check is opened to review** (from a control's Evidence tab, the Polaris panel, an Actions item, the batch banner's "what's proposed so far") goes to this same page, not a window.

## Note for the builder

The current Review tab (`checks/ReviewTab.tsx` → `OneAtATime` → `ReviewOne` → `ProposalReview` / `SampleReview` in `collection/`) renders inline; I couldn't find the narrow window on that path from the code. Before building, confirm on staging where Steve opens it (e.g. a side panel on Overview, the Polaris panel, or the control's Evidence tab). Every one of those should land on the new page. Follow *Screen conventions* in `brief/information-architecture.md` for the page header and trail.

## Done when

- Review shows a list, and each item opens a full-width page with its own address.
- "Back to Review", the trail and browser Back return to the list with the same filter and position.
- Previous / Next and the A / D / ← → keys work on the page, and the last decision returns to the list.
- On a 1440-pixel-wide screen, the sample table for a check with about 10 fields shows without scrolling sideways.
- There are vitest tests for the list → page → back round trip and for the next-after-decision behaviour, plus a Browser smoke entry for the new page.

**Independent** (front end only, no migration or API change).