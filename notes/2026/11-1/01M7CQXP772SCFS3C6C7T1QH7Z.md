---
id: 01M7CQXP772SCFS3C6C7T1QH7Z
created: 2026-11-14T09:58:51.367479Z
updated: 2026-11-14T10:26:14.833579Z
type: task
title: 'All checks lists every check: an approved check with no pass/fail rule shows a grey "No rule" pill and opens to its page, where a rule can be added'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1817
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
## What happened

On 2026-11-14 Steve approved a check on Checks ▸ Review and expected to find it on **All checks**. It wasn't there. All checks only lists checks that have a pass/fail rule (Compass's own checks, and collected checks with a rule, COM-1606). A collected check without a rule can only be found through its control's Evidence tab, which is also the only place to "Add a pass/fail rule". To him the tab's name promises every check.

## What people see

1. **Every live check is listed.** All checks shows Compass's own checks and every approved collected check (CHK-n) for the company. Checks waiting for approval stay on Review. Replaced or retired checks don't show.
2. **A grey "No rule" pill.** A collected check with no pass/fail rule shows a grey **No rule** pill in the State column. Passing, Failing and the other states are unchanged. If it can't read (e.g. a key has expired), it shows that state instead, because that matters more.
3. **The other columns** for a no-rule check: Since is when it was approved, Failing shows "—", Last run is its last capture, and the integration filter covers it.
4. **The summary cards** above the table gain a **No rule** card (count, click to filter). The tab's count and the Overview headline count every check ("18 checks: 9 passing · 2 failing · 7 no rule"), and a no-rule check never counts as passing or failing.
5. **Opening one goes to the check's page**: what it reads and shows, its schedule, its captures with the latest sample table, which control it evidences, and its history. A no-rule check's page has **Add a pass/fail rule**, the same as on the Evidence tab today: write one, or **Ask Polaris to propose one**, which goes to Review for approval as now. Once a rule is approved, the pill changes to Passing or Failing after the next run.
6. **The check's ID** (CHK-n) shows in the row and on its page, so it matches what Polaris calls it (COM-1805).

## Notes for the builder

- On main, `ChecksPage.tsx` lists `useChecks()` → `GET /api/v1/checks`, which returns only checks with a state. A collected check without a rule needs to join that list with a no-rule state, or the page needs to merge both lists. Pick whichever keeps sorting and filters simple.
- `CheckDetailPage.tsx` (`/checks/:key`) is the place for a no-rule collected check too. Reuse the Evidence tab's `RulePanel` for adding a rule. COM-1813's full-width review page and COM-1814's column names should look the same here.
- Follow *Screen conventions* (`brief/information-architecture.md`). The grey pill uses `StatusPill`.

## Done when

- A check approved without a rule appears on All checks straight away with a grey **No rule** pill, and the No rule card counts it.
- Opening it shows the check's page, with Add a pass/fail rule and Ask Polaris to propose one.
- After a rule is approved and run, the row shows Passing or Failing.
- Compass's own checks and rule-carrying collected checks look exactly as they do today.
- There are tests for the merged list, the No rule state, its card and count, and the page's Add a rule; the Browser smoke opens a no-rule check from All checks.

**On the chain** (the checks list in the API changes).