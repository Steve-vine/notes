---
id: 01M7P3Z9QDQDXQ948SFHWGZNN2
created: 2026-11-18T01:22:36.909817Z
updated: 2026-11-18T01:22:38.831383Z
type: task
title: A check's page and card say who set its evidence's status, and update without a reload
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1925
sprint: s7nqsy0
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