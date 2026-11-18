---
id: 01M7NKBM8860678HDNT9AH3RVW
created: 2026-11-17T20:32:15.112755Z
updated: 2026-11-18T07:53:18.994238Z
type: task
title: '"Gaps from evidence" is deleted: each gap it holds open passes to the check whose evidence raised it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1900
sprint: s7nqsy0
comments:
- id: 01M7P1W8CCS02AH27X5Q7PV85P
  author: Steve Vine
  at: 2026-11-18T00:46:00.076777Z
  text: |-
    Done — PR #1894, merged 3171ce79.
    "Gaps from evidence" is deleted in every company, with its versions and runs. No company gets it again: the workflow builder's starting point that built one is now "A gap of its own". Each company's Activity says "deleted the workflow “Gaps from evidence” (WFL-n): every check now raises its own gap". An old link to it opens "Workflow deleted" with that sentence, not an error.
    Each gap it held open passes to the check whose evidence raised it. It keeps its number, owner, target date and thread, and its thread says so. From then on the check closes it when it passes.
    - Where that check can't hold it (its Raise a gap is off, it's switched off or gone, or the gap came from an upload's status), the gap stays open for a person and its thread says why.
    - A closed gap it raised that its check hadn't seen pass also passes to the check.
    Polaris no longer names "Gaps from evidence"; it says gaps come from checks.
    Before/after on a copy of staging (dumped 21:28 on 17 Nov, migrated with this change on top of COM-1899 and COM-1901): 52 held, 0 failed. It's deleted in all 4 companies with the Activity line. It held 13 open gaps, and every one duplicated a gap its check already held on the same control (12 built-in, 1 custom). All 13 stay open, now raised by their checks. The checks' own 13 older duplicates are closed (Cancelled), each saying it's a duplicate of the one kept. No control lost an open gap, and no check holds two on one control.
    Assumptions: where a check already held its own open gap, the workflow's gap is the one kept open, as the task says each gap it held stays open, and the check's older one is closed as the duplicate. A company that never saw the workflow act (a fresh database's default company) loses it with no Activity line. A control a risk names as an exception gets no new gap from the change; the check's next change of status judges it.
    To check on staging: the closed duplicates are GAP-12 to 17, 32 to 35, 92, 115 and 159; in E2E Test Company, GAP-160 is now CHB-6's and GAP-159 is closed. To repeat the comparison around the deploy, run `gaps_handover_compare` (snapshot before, snapshot after, diff), as the PR describes.
- id: 01M7P43Y4E2MYP49SYE4KV5CPX
  author: Steve Vine
  at: 2026-11-18T01:25:08.878775Z
  text: |-
    Pre-UAT on staging 3171ce79 — Passed
    - "Gaps from evidence" no longer exists, and an old link to it says it was deleted: Passed. In E2E Test Company, as Admin A and as the Viewer, Automation ▸ Workflows lists WFL-2 to WFL-11 and no "Gaps from evidence". Opening /automation/workflows/WFL-1, or the workflow's old long link, shows "Workflow deleted: WFL-1 was deleted on 18 Nov 2026: every check now raises its own gap." There's no error. A WFL number that never existed still says "Workflow not found". The new-workflow starting points no longer offer it and do offer "A gap of its own". Activity has a line from Compass at 00:50: "deleted the workflow “Gaps from evidence” (WFL-1): every check now raises its own gap". Polaris says E2E Test Company has no WFL-1. For the other companies, see the coordinator's before/after comparison on real staging (~/compass-uat/gaps-handover/diff.txt): deleted, with the Activity line, in Demo, Moneypenny and Test Company too.
    - Each gap it held open is still open, now raised by its check, and closes when that check passes: Passed. Before I changed anything: GAP-160 on ACC.3 was open. Its page heading reads "Raised by Compass check: CHB-6 · Top admin roles are few". Its thread says the workflow was deleted and the gap now belongs to CHB-6. CHB-6 was listed as holding GAP-160. GAP-159 was Cancelled, "Closed by Compass as a duplicate of GAP-160…". Then, as Admin A on ACC.3's Evidence tab, I overrode CHB-6's evidence to Compliant (with a reason), and GAP-160 closed: "Closed by Compass: its evidence is Compliant (set by E2E Admin A)." I then set the evidence back to Non-compliant. Its status went back to being set by "Built-in check: CHB-6", with no override showing. CHB-6 raised a fresh gap, GAP-164, "Raised by Compass check CHB-6: Top admin roles are few. 5 people hold…". Because the check had just seen its evidence pass, it raised a new gap rather than reopening GAP-160, which is how it should behave. So E2E Test Company's ACC.3 gap is now GAP-164, not GAP-160.
    - No control loses an open gap, and no check has two open gaps on one control: Passed. The coordinator's comparison shows 53 held, 0 failed. In E2E Test Company, CHB-6 holds one gap on ACC.3 and CHB-12 holds GAP-152 on IDM.18. GAP-161, also open on ACC.3, was raised by an earlier pre-UAT workflow (WFL-11, now disabled), not by a check.
    - A before/after check comparison: Passed. The PR's comparison on a copy of staging's data showed 52 held, 0 failed. The coordinator's comparison around the real deploy shows 53 held, 0 failed.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1900/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Steve, 2026-11-17: delete the "Gaps from evidence" workflow, don't just retire it. With COM-1897 every check raises its own gap, so the workflow would now raise a second one.

Builds on COM-1897 (it needs custom checks' Raise a gap).

**What changes**
- In every company, **"Gaps from evidence" is deleted**, with its versions and its runs. It no longer appears in Automation ▸ Workflows, and its WFL number isn't reused.
  - Any WFL link to it says the workflow was deleted. It doesn't show an error.
  - Each company's Activity gets one line: "Deleted the workflow “Gaps from evidence”: every check now raises its own gap".
  - Lines already in Activity and on gap threads that name it stay as they were written.
  - It only ever raised and closed gaps and never set an evidence status, so no piece of evidence loses its "set by".
- **Each gap it holds open passes to the check whose evidence raised it**, before the workflow is deleted. The gap stays open with its number, owner, target date and thread, and its thread and Activity say so. From then on, the check closes it when it passes.
  - If that check's Raise a gap is off, the gap stays open for a person to close, and its thread says why.
  - A closed gap it raised that it hadn't yet seen pass also passes to the check, so a Complete one still reopens and a Cancelled one is still believed, as before.
  - Its other closed gaps keep their history and simply no longer link to a workflow.
- **After the change**, every live check that is Non-compliant on an assessed control, with Raise a gap on, has an open gap there. Where the workflow's single gap covered several failing checks on one control, each of the others gets its own gap.
- No company gets "Gaps from evidence" again, new companies included.
- Polaris no longer names "Gaps from evidence" as how gaps are raised.

**Done when**
- "Gaps from evidence" no longer exists in E2E Test Company or any other company, and an old link to it says it was deleted.
- Each gap it held open is still open, now raised by its check, and closes when that check passes.
- No control loses an open gap, and no check has two open gaps on one control.
- A check comparison before and after the deploy shows exactly that (like the rules-to-workflows switchover check), run against a copy of staging's data before deploying.