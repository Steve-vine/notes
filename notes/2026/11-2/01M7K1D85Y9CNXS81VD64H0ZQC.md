---
id: 01M7K1D85Y9CNXS81VD64H0ZQC
created: 2026-11-16T20:40:05.054299Z
updated: 2026-11-16T21:36:33.832618Z
type: task
title: A check's control can be changed, so its evidence moves to the control it now belongs to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1875
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: backlog
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