---
id: 01M7MJFT3T2EV8EF9W45WMAX34
created: 2026-11-17T10:57:49.178117Z
updated: 2026-11-17T10:57:53.510925Z
type: task
title: Workflows act on every control a built-in check is on, and call it by the company's own name
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1896
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
---
From the pre-UAT pass of round 3 (staging 44d15b9a), COM-1882 and COM-1884.

**The problems.**
1. A company can add a control to a built-in check (COM-1882). Adding INS.10 (assessed) to CHB-6 moved its card and its own gap (GAP-145) onto INS.10. But workflows only ever judged its evidence on ACC.3: WFL-11 and Compass's WFL-1 said "Leave ACC.3: it isn't assessed" and never acted on INS.10. Polaris's test of the workflow lists the piece's controls as ["ACC.3"].
2. After CHB-6 was renamed, the workflow builder's check picker and the workflow sentences (and Polaris's posture_get_workflow) still said "CHB-6 · Top admin roles are few". Every other place used the new name.

**Done when**
- A built-in check's evidence is on every control the company has put it on, and workflows judge it on each: a gap is raised or closed per control. Polaris's workflow test lists all of them.
- Removing a control from the check stops workflows acting on it there.
- The workflow builder's check picker, its sentences and Polaris's workflow answers use the company's own name for a built-in check, falling back to Compass's name.
- Tests cover a built-in check on two controls, judged on both, and a renamed built-in check in a workflow's sentences.

Steve to decide later (not part of this task): with "Raises its own gap" on and Compass's WFL-1 enabled, a failing built-in check on an assessed control gets two gaps (ACC.3: GAP-147 and GAP-146).