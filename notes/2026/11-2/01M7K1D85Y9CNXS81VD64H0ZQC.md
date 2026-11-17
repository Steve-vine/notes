---
id: 01M7K1D85Y9CNXS81VD64H0ZQC
created: 2026-11-16T20:40:05.054299Z
updated: 2026-11-17T12:12:32.329586Z
type: task
title: A check's control can be changed, so its evidence moves to the control it now belongs to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1875
sprint: s7nqsy0
comments:
- id: 01M7KJF023T578ZM5BRG7S16P9
  author: Steve Vine
  at: 2026-11-17T01:38:08.067146Z
  text: |-
    Done — PR #1877, merged 31937729.
    Edit on a collected check's page now has a Control section: search for a control by ref or name, say why, and "Move to <control>". Before you move it, it says whose coverage will need confirming ("ACC.4 and CHM.2 will need their coverage confirming"), which open gaps it closes, and which workflows look for this check on the old control and won't run after ("WF-3 looks for this check on ACC.4; it won't run after the move").
    It applies at once: the check's current evidence and its history appear on the new control's Evidence tab and leave the old one, each keeping its status; the workflows that use it judge its latest evidence again against the new control; an open gap a workflow raised on the old control for this check is closed with "CHC-n moved to <control>: <reason>" (hand-raised gaps are left); both controls' coverage is marked To confirm; and "moved CHC-n from X to Y: <reason>" shows on the check and on both controls' History.
    Polaris can propose a move (with its reason and what it would do) and gives a link that opens Edit with the move filled in — the person confirms it.
    Assumptions: a gap the move closes is set Cancelled (it wasn't fixed — the evidence moved), with the reason on its thread. A replaced check can't be moved.
    To check on staging: move a live check in Test Company to another control, check both Evidence tabs and Coverage, and the old control's gaps.
- id: 01M7MH8AP0P781G0ACSWMHQEGM
  author: Steve Vine
  at: 2026-11-17T10:36:15.424109Z
  text: |-
    Pre-UAT on staging 44d15b9a — Failed (one small defect: the move isn't listed on the check's own page)
    Done in E2E Test Company (not Test Company), as E2E Admin A, on CHC-2, a live check on ACC.13 whose integration was deleted. To have a workflow gap to close, I made WFL-10 "E2E pre-UAT COM-1875 gap on ACC.13 for CHC-2" (when CHC-2 collects, if it's on ACC.13, raise a gap). It's disabled again now.
    - Edit has the Control section, and the move applies at once: Passed. In Edit, "Move to another control" has a ref/name search, Why, and "Move to ACC.12". Before saving it said: "ACC.13 will need its coverage confirming.", "It closes GAP-140, raised by a workflow on ACC.13 for this check." and "WFL-10 looks for this check on ACC.13; it won't run after the move".
    - Evidence and history follow the check: Passed. After the move, CHC-2's card (last collected 6 Nov) is on ACC.12's Evidence tab and gone from ACC.13's. The check's Details read "Evidences: ACC.12".
    - Workflows judge again against the new control: Passed. WFL-10's runs show "Not met, nothing to do: It is on ACC.12" after the move away, and "Raised GAP-140 on ACC.13" after moving back.
    - Gaps: Passed. Moving off ACC.13 again set GAP-140 to Cancelled, with the comment "CHC-2 moved to ACC.12: E2E pre-UAT COM-1875 move to close the workflow gap". The hand-raised GAP-71 was left alone.
    - Both controls marked to confirm, on Evidence and Coverage: Partly. ACC.13 showed TO CONFIRM ("Changed since it was said: CHC-2 moved to ACC.12") on its Evidence tab and under Coverage ▸ "Coverage to confirm". ACC.12 had no answer before, so it shows "Not yet looked at" rather than To confirm, and the dialog named only ACC.13. That seems sensible, but the Done-when says both.
    - Activity lines: Failed on the check. "E2E Admin A moved CHC-2 from ACC.13 to ACC.12: <reason>" is on ACC.13's History tab, and on ACC.12's through the API. It isn't anywhere on CHC-2's own page: its Changes list renames and schedule changes but no move. Also, ACC.12 isn't assessed, and its History tab shows only "Not assessed yet.", so on screen the line only appears on assessed controls (same as COM-1880).
    - A replaced check refuses the move: Couldn't check. There's no replaced check in E2E Test Company. Covered by the PR's tests.
    - Polaris proposes a move: Couldn't check. My MCP connection's tool list still says "You can't approve or move a check"; it looks cached from before this deploy.
    - ADR 0142 amendment: Passed. "Amendment (2026-11-17, COM-1875): a check's control can change" is on main.
    - Put back: CHC-2 is back on ACC.13. I confirmed ACC.13's coverage as Partly with its original text. WFL-10 is disabled. GAP-140 stays Cancelled.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1875/
- id: 01M7MPRM69N20JCAH3N95035PF
  author: Steve Vine
  at: 2026-11-17T12:12:32.329161Z
  text: 'Re-check on 00a2eb16 after COM-1895: Passed. CHC-2''s own Changes now lists every move, including the ones made before the fix, as "Moved from ACC.13 to ACC.12: <reason> · by E2E Admin A · <date>". A fresh move ACC.13 → ACC.12 → ACC.13 named both controls in the preview ("Moves CHC-2 from ACC.13 to ACC.12."), on the button ("Move from ACC.13 to ACC.12") and in the confirmation ("CHC-2 moved from ACC.13 to ACC.12."). Both controls'' History show each move. CHC-2 is back on ACC.13. Screenshots: ~/compass-uat/s7nqsy0/COM-1895/'
assignee: steve
priority: medium
task_status: review
---
From Steve's testing of round 2 (staging 43d03f09).

**What Steve asked for.** "Make the control editable so that it's possible to make the evidence appear on another control if they change." Today a check's control is fixed when it's approved, and the only way to move it is to re-create the check.

**Builds on COM-1880**, which makes coverage belong to the control rather than the check. Because of that, a move doesn't ask about coverage (amended 16 Nov at Steve's direction).

**Behaviour** (assumptions decided here, not by Steve)
- **Where.** Edit on the check's page has a Control field (search by ref or name), for anyone who can edit the check. It isn't available on a replaced or deleted check.
- **Applies at once.** It doesn't wait for Review: what is collected doesn't change, only where the evidence counts.
- **What the person gives:** a reason.
- **Coverage.** The move marks both the old and the new control's coverage **to confirm** (COM-1880). The Edit dialog says so before you save: "CHM.1 and CHM.2 will need their coverage confirming".
- **The check's evidence moves with it**: its current evidence and its history both appear on the new control's Evidence tab and leave the old one. Each piece keeps its status. The workflows that judge the check run again on its latest evidence against the new control, as they would after a capture.
- **Gaps.** An open gap that a workflow raised on the old control for this check is closed, with "CHK-n moved to <new control>: <reason>". A gap raised by hand is left alone.
- **Workflows.** A workflow whose conditions name the old control together with this check no longer matches. The Edit dialog says which workflows before you save ("WF-3 looks for this check on SOD.9; it won't run after the move"), so the person can change them.
- **Audits.** Evidence already given to an audit stays as it was given. An audit that has ended keeps its copy (ADR 0151).
- **Recorded.** There's an Activity line on the check and on both controls: "Moved from SOD.9 to CHM.2 by <person>: <reason>".
- **Polaris.** Polaris can propose a move with its reason, but a person confirms it on the check's Edit. Polaris never moves it itself, in step with how reads changes work.

**Done when**
- The behaviour above works on staging. Moving a live check in Test Company to another control shows its evidence and history there, and no longer on the old control.
- Both controls are marked "to confirm" on their Evidence tabs and on Coverage.
- The old control's compliance and gaps update accordingly.
- An ADR 0142 amendment records that a check's control can change, and how its evidence and gaps follow (coverage is covered by COM-1880's amendment).
- There are tests for:
  - the move;
  - both controls being marked to confirm;
  - the gaps it closes;
  - the warning about workflows;
  - a replaced check that refuses the move;
  - the Activity lines.

**Where** (for the builder): api/v1/collected_checks.py (PATCH), models/collected_check.py (`control_key`), checks/EditCheck.tsx, core/workflows (re-judging, conditions on control and check), the control Evidence tab, core/collection/coverage.py ("to confirm", from COM-1880), Polaris collection tools.