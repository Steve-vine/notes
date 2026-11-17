---
id: 01M7MJFT3T2EV8EF9W45WMAX34
created: 2026-11-17T10:57:49.178117Z
updated: 2026-11-17T19:50:15.523273Z
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
- id: 01M7MPRD3WJ9GS2BD007CSBVD0
  author: Steve Vine
  at: 2026-11-17T12:12:25.084091Z
  text: |-
    Pre-UAT on staging 00a2eb16 — Passed
    - Workflows judge the check on every control it's on: as E2E Admin A, enabled WFL-11 for the test, then on CHB-6 ▸ Edit added INS.10 (assessed) beside ACC.3 and saved. Within seconds WFL-11 ran on its own: "Raised GAP-150 on ACC.3; Raised GAP-151 on INS.10". The check's own gap came on INS.10 too (GAP-149). To make Compass's WFL-1 run (it starts on a status change), I raised the check's threshold so it passed, then put it back so it failed. On the pass, WFL-11 closed GAP-150 and GAP-151, and WFL-1 closed GAP-146 on ACC.3. On the fail, WFL-11 raised GAP-157 (ACC.3) and GAP-158 (INS.10), and WFL-1 raised GAP-155 (ACC.3) and GAP-156 (INS.10). Passed.
    - The workflow test lists every control: the on-screen Test on WFL-11 said "Would keep GAP-157 open on ACC.3; keep GAP-158 open on INS.10". Polaris's test of WFL-11, and of WFL-1 pretending a change to Non-compliant, listed controls ["ACC.3","INS.10"]. Passed.
    - Removing a control stops workflows there: took INS.10 off in Edit with a reason. GAP-158 (WFL-11), GAP-156 (WFL-1) and the check's own GAP-154 on INS.10 were cancelled, each with the comment "CHB-6 no longer evidences INS.10: E2E pre-UAT COM-1896 take INS.10 off CHB-6". After another pass then fail, both workflows acted on ACC.3 only (WFL-11 raised GAP-161, WFL-1 raised GAP-160), and Polaris's test listed ["ACC.3"]. Passed.
    - The company's own name in workflows: renamed CHB-6 to "E2E pre-UAT COM-1896 few top admins". WFL-11's canvas, Sentences and trigger panel said "When evidence is collected by CHB-6 · E2E pre-UAT COM-1896 few top admins". The builder's "Only from these checks" picker offered "CHB-6 · E2E pre-UAT COM-1896 few top admins · Built-in" whether I searched "CHB-6" or "admins". Polaris's posture_get_workflow showed the new name too. Passed.
    - Tests: in PR #1890 (not re-run here).
    Observation: when INS.10 was added, WFL-1 didn't raise a gap there straight away. WFL-1 starts on a status change, and adding a control doesn't change the status. It acted on INS.10 at the next status change. WFL-11, which starts when evidence is collected, acted at once.
    Put back: name reset to Compass's wording, controls ACC.3 only (Compass's), threshold 4, WFL-11 disabled again. Left open on ACC.3: GAP-161 (raised by WFL-11, which is now disabled, so nothing will close it), GAP-160 (WFL-1) and GAP-159 (the check's own gap).
    Screenshots: ~/compass-uat/s7nqsy0/COM-1896/
assignee: steve
priority: medium
task_status: done
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