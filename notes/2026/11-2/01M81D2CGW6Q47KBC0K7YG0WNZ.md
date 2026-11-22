---
id: 01M81D2CGW6Q47KBC0K7YG0WNZ
created: 2026-11-22T10:33:14.012149Z
updated: 2026-11-22T13:26:33.095797Z
type: task
title: 'Design note: attestations are assigned to reading groups, not business roles — one place to assign, groups built from rules'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2096
sprint: sdy0mr7
comments:
- id: 01M81F33V79MCF73HJ28BR94YM
  author: Steve Vine
  at: 2026-11-22T11:08:35.047582Z
  text: |-
    Done: ADR 0168 merged in PR #2074 (decisions/0168-attestations-are-assigned-to-reading-groups.md), and ADR 0117 has an amendment pointing to it.

    Decided as agreed: content is assigned to reading groups only. A group is built from rules (everyone, holds any of these roles, a phrase in a role's name, a Microsoft detail), combined as any or all, then people included or left out by name, with leave-out winning. Compass keeps the members up to date, with the day each joined. The role page loses its Content card and shows the groups it feeds, read only. Existing role assignments move into one-role groups.

    Calls for Steve to confirm:
    - Once a group has had content assigned it can be archived but not deleted.
    - Rules combine as "any" by default.
    - The Microsoft details offered are department, job title, office, employee type and company name.
    - Polaris reads groups and assigns content, but doesn't change a group's rules.
- id: 01M81PZQW76CVX58ZN4R6QMX4E
  author: Steve Vine
  at: 2026-11-22T13:26:33.095616Z
  text: 'Pre-UAT: **Passed**. ADR 0168 is on main (decisions/0168-attestations-are-assigned-to-reading-groups.md), and staging behaves as it describes: see COM-2097 and COM-2098.'
assignee: steve
label:
- brief
priority: medium
task_status: review
---
Sprint "Attestations - Tweaks and Improvements". Raised by Steve while testing Attestations, 2026-11-22.

## Why
Content is assigned on a business role (ADR 0117). Moneypenny has 91 roles, so it's hard to see who is asked to sign what. Most documents follow a few patterns ("everyone", "all managers", "everyone in Legal"), and today each pattern is rebuilt by hand, one role at a time, with nothing showing it afterwards.

## What the note decides (Steve agreed the direction, 2026-11-22)
- A **reading group** is a named set of people in a company, defined by rules rather than a list, so it keeps itself up to date as people join, move and leave.
- Rules can be combined:
  - everyone in the company
  - holds any of these roles
  - holds a role whose name contains a phrase (e.g. "Team Manager")
  - a person's details from Microsoft (department, job title, office, employee type such as contractor)
  - named extra people, and named exclusions
- **Content is assigned to a reading group only.** The business role page's Content card is removed so nothing can be assigned in two places. The role page instead shows, read-only, which reading groups the role feeds into, with links.
- Everything else in ADR 0117 stays: assign date, deadline, cadence, cycles, sign once per document however many groups ask, new starters asked straight away, the portal, chasing, evidence of operation.
- Existing role assignments (staging and test data only; production has none) each become a one-role reading group, keeping their cycles and signatures.

## Implementation notes (technical)
- New ADR **0168** (next free on main is 0168; check nothing else has taken it, since the guided-procedures idea also has its eye on 0168+). It amends ADR 0117 §1–2 (the assignment target) and is marked as amending it.
- Decide in the note: whether a group's membership is worked out live or stored and refreshed (it should be stored and refreshed, so cycle membership and "who joined when" stay exact); which Microsoft person details are available from what Compass already reads; and whether reading groups are per company (yes, like roles) and who manages them (attestations.manage).

## Done when
- The ADR is merged and linked from the two build tasks.