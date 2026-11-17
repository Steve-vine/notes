---
id: 01M7NKBM8860678HDNT9AH3RVW
created: 2026-11-17T20:32:15.112755Z
updated: 2026-11-17T20:32:17.939145Z
type: task
title: '"Gaps from evidence" is retired: each gap it holds open passes to the check whose evidence raised it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1900
sprint: s7nqsy0
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Steve, 2026-11-17: retire the "Gaps from evidence" workflow. With COM-1897 every check raises its own gap, so the workflow would now raise a second one.

Builds on COM-1897 (it needs custom checks' Raise a gap).

**What changes**
- In every company, "Gaps from evidence" is **disabled and marked Retired**. It stays in Automation ▸ Workflows, with its runs and versions kept as history. It can't be enabled or changed again, and it says why: "Retired: every check now raises its own gap".
- **Each gap it holds open passes to the check whose evidence raised it.** The gap stays open with its number, owner, target date and thread, and its thread and Activity say so. From then on, the check closes it when it passes.
  - If that check's Raise a gap is off, the gap stays open for a person to close, and its thread says why.
  - A closed gap it raised that it hadn't yet seen pass also passes to the check, so a Complete one still reopens and a Cancelled one is still believed, as before.
- **After the change**, every live check that is Non-compliant on an assessed control, with Raise a gap on, has an open gap there. Where the workflow's single gap covered several failing checks on one control, each of the others gets its own gap.
- No company gets "Gaps from evidence" again, new companies included.
- Polaris no longer names "Gaps from evidence" as how gaps are raised.

**Done when**
- In E2E Test Company and every other company, "Gaps from evidence" is disabled, marked Retired, and can't be enabled.
- Each gap it held open is still open, now raised by its check, and closes when that check passes.
- No control loses an open gap, and no check has two open gaps on one control.
- A check comparison before and after the deploy shows exactly that (like the rules-to-workflows switchover check), run against a copy of staging's data before deploying.