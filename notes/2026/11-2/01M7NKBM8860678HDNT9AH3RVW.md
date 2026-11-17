---
id: 01M7NKBM8860678HDNT9AH3RVW
created: 2026-11-17T20:32:15.112755Z
updated: 2026-11-17T20:40:17.14994Z
type: task
title: '"Gaps from evidence" is deleted: each gap it holds open passes to the check whose evidence raised it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1900
sprint: s7nqsy0
assignee: steve
label:
- feature
priority: medium
task_status: todo
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