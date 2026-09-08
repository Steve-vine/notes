---
id: 01M21FDJTPGM1P8NKFJXN33BG3
created: 2026-09-08T21:40:07.126301Z
updated: 2026-09-08T21:40:07.126301Z
type: task
title: The History box comes off the gap, risk and decision pages
priority: medium
assignee: steve
task_status: backlog
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 628
---
Asked for by Steve while smoke-testing, 2026-09-08. Companion to COM-629, which puts the missing detail where the trail is actually read.

The gap, risk and decision pages each carry a **History** box at the bottom. It is admin-only (everyone else sees nothing there), and it shows less than the Activity page does for the same entries: when, "updated", who — not even the one-line summary the log holds. It answers no question the Activity page doesn't answer better.

**Change.** Remove the History box from the gap page, the risk page and the decision page. The Activity page under Admin is the one place to read the trail. Nothing is deleted from the log; the box was only a window onto it.

---

*Implementation notes.* Drop the `<ActivityHistory …/>` line from `GapDetailPage.tsx:271`, `RiskDetailPage.tsx:136` and `DecisionDetailPage.tsx:105`. Those are the only three users, so delete `components/ActivityHistory.tsx` and its test; check `ACTIVITY_ACTION_ORDER` in `statusColors.ts` is still used by the Activity page's sort before pruning anything there (it should be). The `useActivity` hook stays — the Activity page uses it. `PortalVendorDetailPage.test.tsx` mentions the name — check whether it is a mock that can go too. No backend change.