---
id: 01M7CQXP772SCFS3C6C7T1QH7Z
created: 2026-11-14T09:58:51.367479Z
updated: 2026-11-14T13:51:07.925008Z
type: task
title: 'All checks lists every check: an approved check with no pass/fail rule shows a grey "No rule" pill and opens to its page, where a rule can be added'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1817
sprint: spsp226
comments:
- id: 01M7CW8Q89D5F304GM6V48Y2EW
  author: Steve Vine
  at: 2026-11-14T11:14:47.176619Z
  text: |-
    Built — PR #1810 (824c4065), auto-merge on. API change (checks list), no migration; ADR 0142 amended (2026-11-14).

    What you now see:
    - All checks lists Compass's own checks plus every approved, switched-on collected check. Proposals stay on Review; replaced/switched-off ones aren't listed.
    - A collected check with no pass/fail rule shows a grey "No rule" pill (Since = approved, Failing "—", Last ran = last capture; the Collected evidence filter covers it). If it can't read, it shows Can't tell with the reason instead.
    - A No rule card (click to filter). Tab count and headline count every check ("18 checks: 9 passing · 2 failing · 7 no rule"); no-rule never counts as passing/failing.
    - Opening one goes to its page: CHK ID + pill, reads and what it shows, schedule and next collection, the control (link to its Evidence tab), the latest capture in the Review sample table, every capture, and Add a pass/fail rule. Once a rule is approved and run, the row shows Passing/Failing and the page becomes the normal check page.
    - CHK IDs now show on every collected check's page; checks named on the Overview tab link to their pages. Polaris knows the No rule state and matches by CHK ID.

    Choices: the page reuses the Evidence tab's rule panel, so buttons read "Write a rule" / "Ask Polaris for a rule" (a line says a proposed rule waits on Review); Settings leaves no-rule checks out; Run now returns a refusal for a no-rule check; "Overview headline" read as the All checks headline (the Overview tab counts controls); a no-rule check that can't read counts as can't tell on the Dashboard tile.

    Browser smoke: new step opens All checks ▸ No rule and a no-rule check's page. E2E Test Company has no no-rule check that reads right now (its ACC.13 Entra check is broken → Can't tell), so the step falls back to opening the first collected check.

    Tests: unit 2328 passed; integration (collection rules, collected check ids, control checks API) 12 passed; ruff/mypy/eslint/tsc/prettier clean; OpenAPI drift OK; full vitest green apart from the known HouseStylesTab load flake.

    For Steve on staging: approve a check without a rule → it appears on All checks at once with No rule; add a rule on its page → Passing/Failing after the next run.
- id: 01M7D5704MFHW5C102PABMYM5S
  author: Steve Vine
  at: 2026-11-14T13:51:07.924705Z
  text: |-
    Pre-UAT on staging 53965a3b (E2E Test Company): **Passed** for the list; the No rule parts **Couldn't check**.

    Seen: All checks shows 13 checks — 12 built-in + "CHK-2 · Entra ID (Microsoft 365) directory role assignments" under Collected evidence, with its CHK ID in the row. Headline "13 checks: 3 passing · 6 failing · 0 no rule · 4 can't tell". No rule card (0); clicking it filters (state=no_rule) to "No check matches these filters". Reads filter has "Collected evidence". CHK-2 shows Can't tell (its integration was deleted); opening it goes to /checks/collected:<id> with the CHK-2 pill, "The check can't read: That Collection integration doesn't exist", chart, About, Changes.

    Couldn't check: the grey No rule pill and count, the no-rule page with Write a rule / Ask Polaris for a rule, and the row turning Passing/Failing after a rule is approved — E2E Test Company has no no-rule check that reads. Steve: approve a check without a rule on a company with a working integration and follow the Done when.

    Observations (not caused by this task): Checks ▸ Overview "Needs attention" says "7 checks failing" while All checks says 6 — it looks like it counts controls ("No dormant accounts" covers IDM.5 and IDM.6). The Controls column links (e.g. ACC.13) open /assessments/ACC.13, not the control page.
assignee: steve
label:
- bug
priority: medium
task_status: review
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