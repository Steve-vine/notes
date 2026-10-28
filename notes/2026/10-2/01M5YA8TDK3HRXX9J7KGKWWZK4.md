---
id: 01M5YA8TDK3HRXX9J7KGKWWZK4
created: 2026-10-27T09:15:12.179784Z
updated: 2026-10-28T18:17:05.399909Z
type: task
title: Polaris can read and work vulnerabilities — what's open and overdue for a system or a person, the figures and their trend, and record, assign, fix or comment as the person allows
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1373
sprint: s6wypy5
blocked_by:
- 01M5YA6ZNQ5Q5CGV8DXB00MQ41
- 01M5YA88GK0JWX1SGY1TX762TB
comments:
- id: 01M5ZSRMH4KFD6XFMCDVCGFJMA
  author: Steve Vine
  at: 2026-10-27T23:05:13.508677Z
  text: |-
    Built and merged: PR #1388.

    **What Polaris can do**
    - **Read**, for people who can view vulnerabilities:
      - list them with the Register's filters ("what's open on Payroll?", "what's overdue for me?");
      - open one, with its sources and timeline;
      - "where is CVE-2024-3094?" across every system;
      - the Overview's figures now and how they've moved, monthly and weekly, with found and fixed by month.
    - **Change**, for people who work vulnerabilities: record by hand, assign, comment, change severity, mark fixed, false positive, reopen, raise or link a risk, and change many at once.
    - **Accept** is a sign-off. Polaris asks first ("Accept VUL-12 until 31 Jan 2027"), and nobody, so not Polaris acting for them, accepts one they recorded or own.
    - **Changing many at once** asks first too, and Polaris is told to preview it and say how many will change and how many are skipped.
    - What a scanner, cloud or report wrote comes back as data, never followed as instructions. The MCP server instructions gained a Vulnerabilities paragraph.
    - Each change is logged as the person's, via Polaris.

    **A fix found while testing:** accepting needed *Work vulnerabilities* as well as *Accept*, so someone holding only Accept couldn't accept anything. ADR 0129 makes Accept a sign-off of its own, so it now needs only Accept, on the screen and through Polaris.

    **My calls**
    - "A system's vulnerabilities" and "a person's overdue" go through the one list tool with filters rather than separate tools.
    - Polaris can't add files to a vulnerability; uploads stay on screen, as everywhere else.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on the Overview and lifecycle tasks. Follows the module pattern of the MCP sprints (ADR 0111–0113) and Polaris's rules (ADR 0127, and sprint 89's "ask only for sends, destructive steps and sign-offs").

## What people can ask of it

- **Read:**
  - list vulnerabilities with the Register's filters;
  - one vulnerability with its sightings;
  - group by issue ("where is CVE-2024-3094?");
  - the Overview figures and the trend ("are we fixing criticals faster than last quarter?");
  - a system's vulnerabilities;
  - a person's overdue items.
- **Change:**
  - record one by hand;
  - assign an owner;
  - comment;
  - change severity with a reason;
  - mark fixed;
  - false positive;
  - raise or link a risk;
  - reopen.
- **Accept** is a sign-off: Polaris asks first, says what will be accepted and until when, and the second-person rule applies.
- **Bulk changes** say how many rows will change before they're made.

## Rules

- Polaris acts as the person, with exactly their permissions. Everything is logged as theirs, via Polaris.
- Text that came from a source is returned as data (the `from_the_cloud` pattern) and never followed as instructions.

## Notes (technical)

- `assistant/tools/vulnerabilities.py`, auto-discovered, with lookups in a `vulnerabilities_common.py`.
- `compass_tool(ask=…)` on Accept.
- Add a Vulnerabilities paragraph to the MCP server instructions.

**Chain:** on the chain (no migration; adds tools).

**Done when:** Polaris answers the four example questions from real data and makes each change with the right asks.