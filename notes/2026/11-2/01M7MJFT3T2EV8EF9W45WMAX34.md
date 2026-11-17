---
id: 01M7MJFT3T2EV8EF9W45WMAX34
created: 2026-11-17T10:57:49.178117Z
updated: 2026-11-17T11:44:31.719097Z
type: task
title: Workflows act on every control a built-in check is on, and call it by the company's own name
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1896
sprint: s7nqsy0
comments:
- id: 01M7MN5932SEQPRHPJRMG4P8BB
  author: Steve Vine
  at: 2026-11-17T11:44:29.79446Z
  text: |-
    Done — PR #1890, merged 00a2eb16.
    - A built-in check's evidence is now on every control the company has put the check on. Workflows judge it on each one, raising and closing their gaps per control, and a test of a workflow (on screen or by Polaris) lists all of them.
    - Adding a control to a built-in check makes the workflows judge its latest result again straight away, so a gap appears on the new control without waiting for the check's result to change.
    - Taking a control off stops workflows acting there. Any open gap a workflow raised there from the check's results is cancelled, with the comment "CHB-n no longer evidences <control>: <reason>", the same way the check's own gap already is.
    - The workflow builder's check picker, the workflow sentences, the test drawer and Polaris's workflow answers now use the company's own name for a built-in check, and Compass's name when the company hasn't given one. When Polaris drafts a workflow, it finds the check by either name.
    Assumption: an open workflow gap on a removed control is cancelled rather than left open, because nothing would ever close it. This is what COM-1875 does when a custom check moves control. A switched-off check isn't judged again when a control is added.
    Not changed: the "two gaps" behaviour (the check's own gap plus WFL-1), left for Steve to decide.
    To check on staging: on CHB-6 (with INS.10 added), the next workflow run raises or closes WFL-11's and WFL-1's gaps on INS.10 as well as ACC.3. Adding a control again from Edit judges the check at once. The builder's picker and WFL-11's sentences show CHB-6's new name.
assignee: steve
priority: medium
task_status: review
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