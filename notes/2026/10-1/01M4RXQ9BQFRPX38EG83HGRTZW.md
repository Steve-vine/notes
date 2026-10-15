---
id: 01M4RXQ9BQFRPX38EG83HGRTZW
created: 2026-10-12T20:44:00.759375Z
updated: 2026-10-15T10:35:41.101064Z
type: task
title: A rule can file servers by where they sit in the directory or by how they are named
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 935
sprint: surilj1
blocked_by:
- 01M4RXPXH2SGJ40JNC9HJ9Y6YY
comments:
- id: 01M4ZJ3J2NHF3AVB68FWA8JE5H
  author: Steve Vine
  at: 2026-10-15T10:35:41.01358Z
  text: |-
    Merged to main (PR #958, 2026-10-15). Not on staging until the rest of the sprint is in Review.

    What to look at:
    - Discovered ▸ Rules ▸ New rule: "Name starts with" (any kind, capitals ignored) and, once the kind is "Domain-joined servers", "In OU" — a searchable list of OU paths like "Servers ▸ SQL", each including everything beneath it.
    - The preview says how many it would file. The rule reads e.g. "Domain-joined servers in Servers ▸ SQL → AST-12 Finance system", or "Everything named old… → discarded".
    - Rename the OU in AD: after the next read the rule's sentence uses the new name and it still files there. Delete the OU: the rule says "in an OU that has gone" and files nothing.

    Things that differ from the task text:
    - The rule holds the OU by its id only (ou_id), and looks up its current path each time it runs, rather than keeping the path as well.
    - Choosing an OU with a kind other than servers is refused ("Only servers from the directory sit in an OU"), as is an OU no longer in the directory.

    Technical: rules.MATCH_KEYS gains ou_id and name_prefix; rules.matches takes the live OU paths, looked up once per run (rules.live_ous). The name prefix is compared as text with casefold, never as a pattern.
assignee: steve
label:
- feature
priority: high
task_status: review
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