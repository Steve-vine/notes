---
id: 01M52DCGHRD2E0W2HG6TGDPWHH
created: 2026-10-16T13:10:54.776549Z
updated: 2026-10-16T13:11:55.366156Z
type: task
title: The assistant can read Coverage — how much of the tenant's access Compass can explain, how that has moved, and accept or dismiss the suggested roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1020
sprint: scj9zdp
blocked_by:
- 01M52DA7ACHRXD6G83ANQC2EGB
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1015.

## What people can ask of it

- **Read (for a named company):**
  - the headline: what share of the tenant's group memberships Compass can explain by a business role;
  - the trend over time;
  - the **suggested roles**: a group of people who share the same groups, offered as a business role, with its groups and its people.
- **Write (whatever the person's role allows on screen):**
  - **accept** a suggestion. It becomes a business role on the Role matrix, with those people as holders.
  - **dismiss** a suggestion.
- **Example:** "How much of our access is explained now compared with a month ago? Which three suggestions would explain the most? Accept the first one as 'Contact Centre Agent'."

## Notes (technical)

- Wraps `coverage_proposals.py` (list, accept, dismiss and trend) and `directory.py` `membership-coverage`. Accept and dismiss need `access.accept_coverage`.
- Order suggestions by how much coverage each adds, if the list payload carries it. Otherwise return them in the screen's order.
- Accept returns the new role through COM-1015's role formatter, with its link. Dismiss is `destructive`, because a dismissed suggestion doesn't come back.
- New module `tools/access_coverage.py`.
- Tests: accept and dismiss are hidden without accept-coverage; an accepted suggestion is recorded via assistant.

**Done when:** on staging, the assistant accepts a suggestion and the role appears on the Role matrix with its holders.