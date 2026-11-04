---
id: 01M6MB699GD640J6RD0JJA4TMY
created: 2026-11-04T22:34:35.184833Z
updated: 2026-11-04T22:34:38.659483Z
type: task
title: Initiative Actions tab lists only the actions that count towards it, with no routine reviews
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1592
sprint: srkxswe
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
An initiative's **Actions** tab lists every open action on its items, including routine reviews that come round on a schedule. For example:
- Mark content Requires review and it shows as an action, as expected.
- Record the review and the mark is resolved. But the content's *next* routine review then appears in the list with a **Later** status.
- Controls behave the same way: after an assessment is saved, its next scheduled review shows.

These rows never count (the tab reads e.g. "15 of 21 count towards complete"), but they clutter an initiative with work that isn't part of it.

**Steve (2026-11-04):** the count is right, but the list should only show the actions that count towards the initiative. The main Actions page stays as it is, with Later items behind its Upcoming switch.

**Wanted behaviour:**
- The initiative's Actions tab shows only the actions that count towards its percentage:
  - remediating its gaps
  - giving its risks a treatment plan
  - completing those plans
  - the reviews this initiative asked for (Requires review)
- Routine reviews of its controls, content and risks don't appear. That covers repeating content reviews, assessment reviews, a risk's periodic review, and anything Later that comes from them.
- The "N of M count towards complete" line and the "doesn't count" marker go, because every row counts. The tab's count and any open-actions figure on the Initiatives list match the rows shown.
- Polaris's initiative actions answer gives the same list.

**Done when:** in E2E Test Company, mark a content item and a control Requires review on an initiative. Both appear on its Actions tab. Record the content review and save the assessment: both rows leave the tab, and no Later row replaces them. A routine review already due on one of the initiative's controls doesn't appear either. The percentage is unchanged from today's for the same data. The main Actions page still shows those routine reviews.

**Implementation:**
- `core/initiatives/actions.py` keeps every row about the initiative's items and marks `counts` (with `_COUNTED` plus asked-for reviews). Filter to `counts` rows before returning, and decide whether `counts` stays on the API (drop it only if nothing else reads it).
- Frontend: `initiatives/ActionsTab.tsx:31` (the summary line) and `:56` (the tooltip marker).
- Check `open_actions` on the Initiatives list/MCP (`initiatives_list`), and that `progress.py` isn't affected.
- Update Polaris's `initiatives_list_actions` wording (`assistant/tools/initiatives.py`).
- Update tests in both suites.

**On the chain** only if the `counts` field is removed from the response. Otherwise independent.

Found by Steve while testing Initiatives (2026-11-04).