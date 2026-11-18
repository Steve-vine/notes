---
id: 01M7P44V0JYTADA38M6TY1Z3B5
created: 2026-11-18T01:25:38.450189Z
updated: 2026-11-18T01:25:40.469581Z
type: task
title: A gap handed from "Gaps from evidence" to its check reads as the check's gap, and a custom check's Raise a gap switch has its own Activity line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1926
sprint: s7nqsy0
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in the pre-UAT pass on staging 3171ce79 (sprint 117 round 4), 2026-11-18. Fix-forward for COM-1900 and COM-1897.

**What's wrong**
- The gaps COM-1900 handed from "Gaps from evidence" to their checks contradict themselves. GAP-160 (E2E Test Company, ACC.3) is headed "Raised by Compass check: CHB-6", but its description still says "Raised by workflow: Gaps from evidence … The workflow closes this gap when its evidence passes", and its title is still the workflow's ("ACC.3: Evidence is Non-compliant"). Only the thread comment explains the handover. Staging has 13 such gaps, and production will have its own when it's released.
- Switching a custom check's Raise a gap shows in Admin ▸ Activity only as "updated collected check … CHC-2", while a built-in check's line says "switched Raise a gap off for CHB-4".

**Done when**
- Each gap handed from the workflow to a check has the title and description that check gives its own gaps ("Raised by Compass check CHC-n / CHB-n: <name>", and who or what made the evidence Non-compliant, if that's known). Its number, owner, target date, status and thread are unchanged, and its thread keeps the handover note. This applies to gaps already handed over on staging (a new migration; the merged one isn't edited) and to any handed over when the release reaches production.
- A gap left open for a person (the check can't hold it) keeps a description saying why, not that the workflow closes it.
- Switching a custom check's Raise a gap on or off writes an Activity line in the same words as a built-in check's ("switched Raise a gap off for CHC-2").

On the chain (migration).