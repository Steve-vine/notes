---
id: 01M4RXQ9BQFRPX38EG83HGRTZW
created: 2026-10-12T20:44:00.759375Z
updated: 2026-10-12T20:45:04.591127Z
type: task
title: A rule can file servers by where they sit in the directory or by how they are named
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 935
sprint: surilj1
blocked_by:
- 01M4RXPXH2SGJ40JNC9HJ9Y6YY
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of sprint 66, Inventory discovery - On-prem (ADR in COM-932). Follows the reading of servers (COM-934).

Rules today match on where a resource was found, its kind and a tag. Servers from a directory are all one kind, found in one place, and carry no tags, so without this every server would be filed by hand.

## What people see

- **A rule gains two conditions.** "In OU", chosen from the same tree as on Inventory ▸ Settings, which includes everything beneath the OU chosen. And "Name starts with".
- **"In OU" is offered for servers only.** "Name starts with" works for every kind, cloud resources included.
- **Names match without regard to capitals,** as server names do.
- **The rule reads as a sentence,** as rules do now: "Servers in Servers ▸ SQL → TA-12 Finance system", "Servers named MPWXSQL… → TA-12 Finance system", "Servers in Decommissioned → discarded".
- **Everything else about rules is unchanged:** the preview before saving, first match wins, a rule never makes a technology asset, and never touches a server someone has already placed or discarded.

## Notes (technical)

- `MATCH_KEYS` in `core/discovery/rules.py` gains `ou_dn` and `name_prefix`; `matches` and `describe` learn both. `dn_within` in `core/ad_scope.py` already answers "is this beneath that".
- The match is JSON on the rule, so no column is added. Check the API's validation of the match, which names the keys it accepts.
- An OU that is later renamed or deleted: the rule holds the OU's own id as well as its path and follows a rename; one whose OU has gone matches nothing and says so, as a rule whose technology asset has gone does.
- A name prefix is compared as text. It is never compiled into a pattern.
- Regenerate `schema.d.ts`.

**Done when:** on staging a rule that names an OU files the servers in it beneath a technology asset, its preview said how many it would file, and the next read files a newly added server there without anyone touching it.