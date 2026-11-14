---
id: 01M7CNQ5RY6GE9BEFGFHXWJQV8
created: 2026-11-14T09:20:20.766393Z
updated: 2026-11-14T09:27:08.025542Z
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

On 2026-11-14, while testing Checks, Steve opened a check to review it from **Checks ▸ Review**. It opened in what looks like a window (a boxed card) that's far too narrow for it. The sample table (one column per field Compass would keep) is much wider than the box, so the thing being reviewed can't be seen properly. Steve: "full screen would be better".

## What people see

1. **Review tab = a list.** Checks ▸ Review lists what's waiting, in the groups it has today (and "From this batch" while a batch runs). Each row shows the control, the check's name, why Polaris proposed it, and "out of date" where it applies. Bulk actions on the groups that are approved together stay as they are.
2. **Opening one takes the full screen.** Clicking a row opens that proposal on its own page with its own address, so it can be linked and survives a refresh. The page uses the whole browser width, not the usual page width or a boxed card. It has what the review card has today: the reads, the sample table with the field ticks, "Ask Polaris", hand edits and a fresh sample (COM-1806), and Approve / Discard.
3. **The sample table uses the width.** It fills the page and only scrolls sideways beyond that. Its first column stays in view while it scrolls.
4. **Getting back.** A "Back to Review" link at the top (and the trail, and the browser's Back button) returns to the list with the same group, batch filter and scroll position.
5. **Moving through them.** Previous / Next, "3 of 14", and the keys (A approves, D discards, ← →) still work on the page. Approving or discarding moves to the next one. When none are left, it goes back to the list with "Nothing is waiting for review".
6. **Anywhere else a waiting check is opened to review** (from a control's Evidence tab, the Polaris panel, an Actions item, the batch banner's "what's proposed so far") goes to this same page.

## Note for the builder

Steve confirmed that the entry point is the Review tab. On main, `checks/ReviewTab.tsx` → `OneAtATime` → `ReviewOne` → `ProposalReview` / `SampleReview` (`collection/`) renders inside the tab, in a `Panel`. I found no Mantine Modal on that path, so what reads as a modal is probably the boxed card inside the tab's width. Check on staging (f90e6b29) before building. Either way, the fix is the same: a full-width review page. Follow *Screen conventions* in `brief/information-architecture.md` for the page header and trail; the page may opt out of the usual content width.

## Done when

- Review shows a list, and each item opens a full-screen page with its own address.
- "Back to Review", the trail and browser Back return to the list with the same filter and position.
- Previous / Next and the A / D / ← → keys work on the page, and the last decision returns to the list.
- On a 1440-pixel-wide screen, the sample table for a check with about 10 fields shows without scrolling sideways.
- There are vitest tests for the list → page → back round trip and for the next-after-decision behaviour, plus a Browser smoke entry for the new page.

**Independent** (front end only, no migration or API change).