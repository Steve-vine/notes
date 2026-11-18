---
id: 01M7P3Z9QDQDXQ948SFHWGZNN2
created: 2026-11-18T01:22:36.909817Z
updated: 2026-11-18T01:56:58.787209Z
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
assignee: steve
label:
- bug
priority: high
task_status: active
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