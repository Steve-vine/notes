---
id: 01M7P3Z9QDQDXQ948SFHWGZNN2
created: 2026-11-18T01:22:36.909817Z
updated: 2026-11-18T07:53:19.040717Z
type: task
title: A check's page and card say who set its evidence's status, and update without a reload
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1925
sprint: s7nqsy0
comments:
- id: 01M7P5Y793CG17FE74YZXW2WRP
  author: Steve Vine
  at: 2026-11-18T01:56:58.787042Z
  text: |-
    Done — PR #1899, merged dcc8a235.
    A check's page, built-in or custom, now says "Set by …" under its title: a person with their reason ("Set by E2E Admin A, overridden: …"), a workflow by its WFL number and name ("Set by WFL-3 · Leavers are judged (v2)", linked to the workflow), or "Set by Compass's test".
    Each check's card on a control's Evidence tab says the same, on a line of its own, for both built-in and custom checks.
    All checks and Polaris now name a workflow by its WFL number too.
    When you change a check's evidence status on the Evidence tab, its card shows the new status and who set it straight away, with no reload.
    The Raise a gap hint in a built-in check's Edit now reads "While its evidence is Non-compliant, it raises a gap on each of its controls; Compliant closes it." That matches a custom check's. Nothing else had the old words.
    Assumptions: a workflow is named with the version it judged as, e.g. "WFL-3 · Name (v2)". A switched-off check shows no "Set by" line, because its status reads Off. The Checks card on the Assessments queue isn't changed (it does now refresh too).
    To check on staging: in E2E Test Company, on IDM.2's Evidence tab, set CHB-5's evidence to Non-compliant with a reason. Its card should change at once to Non-compliant, "Set by E2E Admin A, overridden: <reason>". Then CHB-5's page should show the same "Set by" line. A custom check judged by a workflow should read "Set by WFL-n · …" on its page and card. Put CHB-5 back to Compliant afterwards.
- id: 01M7P7QPY9QZB6BY20P5MZCSYH
  author: Steve Vine
  at: 2026-11-18T02:28:22.601427Z
  text: |-
    Pre-UAT on staging dcc8a235 — Couldn't check (one part only: a custom check with a status; everything else Passed)
    - "Set by" on the page and card, a person: as E2E Admin A in E2E Test Company, on IDM.2 ▸ Evidence, set CHB-5's evidence to Non-compliant with reason "E2E pre-UAT COM-1925 marked Non-compliant to see Set by". The card at once read Non-compliant, "Compass's test: Passing · last ran 18 Nov 2026, 01:40", "Set by E2E Admin A, overridden: E2E pre-UAT COM-1925 marked Non-compliant to see Set by". CHB-5's own page showed the same line under its title. Passed.
    - "Set by" a workflow: no check in E2E Test Company is judged by a workflow, and a built-in check only files new evidence when its result changes. So I made WFL-12 "E2E pre-UAT COM-1925 judges CHB-12" (when CHB-12 collects evidence, set it Non-compliant, which agrees with its test). I added an expired test secret (SEC-89) and ran CHB-12 now (2 of 5 failing). CHB-12's page then read "Set by WFL-12 · E2E pre-UAT COM-1925 judges CHB-12 (v2)", linked to the workflow, and its card on IDM.18 ▸ Evidence read the same. Passed.
    - "Set by Compass's test": CHB-4 on IDM.6 and CHB-5 on IDM.2 read "Set by Compass's test". Passed.
    - A custom check: CHC-2 is the only custom check in E2E Test Company. Its Collection integration was deleted, so it reads Not run and shows no "Set by" line, which matches the builder's assumption. Couldn't check a custom check that has a status set by a workflow or a person. That needs a working Collection integration. Steve: look at a custom check judged by a workflow in another company (e.g. a WFL judging a CHC) and see that its page and card say "Set by WFL-n · …".
    - The card updates straight away: after Override on the Evidence tab, CHB-5's card changed to Non-compliant with the new "Set by" line before the dialog closed, with no reload. Putting it back to Compliant updated it at once too. Passed.
    - The Raise a gap hint: CHB-5 ▸ Edit reads "While its evidence is Non-compliant, it raises a gap on each of its controls; Compliant closes it." The old words ("While it fails… passing closes it") aren't anywhere in the app's code on main. Passed.
    - Put back: CHB-5 set back to Compliant with a reason, and it reads "Set by Compass's test" again. WFL-12 is disabled. SEC-89 is retired. CHB-12 ran again and is back to 1 of 4, "Set by Compass's test". GAP-152 is untouched (still New).
    Screenshots: ~/compass-uat/s7nqsy0/COM-1925/
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found in the pre-UAT pass on staging 3171ce79 (sprint 117 round 4), 2026-11-18. Fix-forward for COM-1901, which promised that a built-in check's page shows its evidence status beside what Compass's own test found, "so you can see when a workflow or a person gave a different verdict, and who did".

**What's wrong**
- The check's page and its card on a control's Evidence tab show the evidence status and "Compass's test: …", but not who set the status (a person, a workflow, or Compass's test). Only the All checks row and Polaris name them.
- After a person changes the check's evidence status on a control's Evidence tab, the check's card there keeps the old status until the page is reloaded. The section heading updates at once.
- A built-in check's Edit still describes Raise a gap as "While it fails, it raises a gap…; passing closes it". Since COM-1901 the gap follows the evidence's status: Non-compliant raises it, Compliant closes it, Unchecked leaves it.

**Done when**
- A built-in or custom check's page and its card on a control's Evidence tab say who set the evidence's status: a person's name, a workflow's WFL number and name, or Compass's test.
- Changing a check's evidence status on the Evidence tab updates its card straight away.
- The Raise a gap hint in a built-in check's Edit (and anywhere else with the same words) describes the gap following the evidence's status.

Independent (frontend, unless "who set it" isn't in the API yet).