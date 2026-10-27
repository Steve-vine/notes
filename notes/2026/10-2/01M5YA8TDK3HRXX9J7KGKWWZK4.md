---
id: 01M5YA8TDK3HRXX9J7KGKWWZK4
created: 2026-10-27T09:15:12.179784Z
updated: 2026-10-27T09:18:59.553437Z
type: task
title: Polaris can read and work vulnerabilities — what's open and overdue for a system or a person, the figures and their trend, and record, assign, fix or comment as the person allows
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1373
sprint: s6wypy5
assignee: steve
label:
- feature
priority: medium
task_status: todo
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