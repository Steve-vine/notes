---
id: 01M5G0TV038KW5HP7Q3MPN7WBQ
created: 2026-10-21T20:00:54.787619Z
updated: 2026-10-22T07:26:22.131302Z
type: task
title: The plan's export and evidence, Inventory's review-overdue flags and the assistant's "today" follow the reader's own day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1203
sprint: ss8348q
comments:
- id: 01M5H81XMW93XBFJRD9YQ9HC4W
  author: Steve Vine
  at: 2026-10-22T07:26:21.340126Z
  text: |-
    Done — merged in PR #1233.

    - **Inventory:** its own screens judge "review overdue" on the reader's own day, at the same moment Actions does. That covers the technology asset, data asset and software registers, each asset's page, and the summary's overdue count. A New York reader no longer sees an asset as overdue when it's still due today for them.
    - **Evidence of operation:** a control's card marks a plan activity overdue from the reader's own midnight.
    - **The plan's export** was already judging "overdue" on the day of whoever asked for it. A test now proves it.
    - **The assistant:** its default "today" is the person's own day. That covers:
      - vendor review dates, questionnaire valid-until dates and vendors' "needs attention";
      - overdue gaps and risk treatments, and the gap report's overdue count;
      - overdue requests to disclose;
      - the "today" its Actions list reports;
      - software's "support ends within".
    - London readers see no change. Background jobs stay on the deployment's clock.

    My calls (beyond the task):
    - **Two more assistant tools changed:** the Actions list and software's support cutoff. Both sit beside things already judged on the reader's day.
    - **Not changed:** the assistant's attestation helpers and the access review tool's default start date, which still use the UK day. They weren't in the task; say if you want them moved too.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Found while building COM-1195 (sprint 79), which moved the plan, attestation and portal screens onto the reader's day. Follows ADR 0121 §3.

**What's wrong:** a few places still decide "today" or "overdue" on the deployment's clock (the UK day, or UTC), so a New York reader can see them disagree with Actions and with the screens COM-1195 fixed:
- the **Security Assurance Plan's export**, and its **evidence of operation** (what counts as overdue or done in time)
- **Inventory's own screens:** "review overdue" on assets, data assets and software (the portal's copy already follows the reader)
- the **assistant's** default "today" in its vendor, gap, risk, report and Data Subject Request tools (e.g. a default review date or a "respond by" date)

**What it should do:** each of these judges "today", "due today" and "overdue" on a dated item by the reader's own day: the person viewing, exporting or asking the assistant. A scheduled export uses its schedule's zone. Background jobs stay on the deployment clock.

**Done when:** for a New York reader, an item due 12 Nov shows overdue at New York's midnight in Inventory, in the plan's export and in its evidence, the same moment Actions does; the assistant's default "today" is the person's own day; and a London reader sees no change.