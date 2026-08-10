---
id: 01KZEPWWPSV1AS9ZM5PDZVQX93
created: 2026-08-07T18:13:50.937723Z
updated: 2026-08-10T13:50:16.614029Z
type: task
title: 'Connector gaps: EC2 launch_time/account_id, Entra group-membership edges'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 618
sprint: sw5yz4n
comments:
- id: 01KZNZ0DNYQJ2PQ2T2VK16FNFQ
  author: Steve Vine
  at: 2026-08-10T13:50:16.254714Z
  text: |-
    Built and pushed as PR #577 (branch feature/ise-618-connector-gaps, from main — independent of the rest of the sprint). No migration, no api-types change.

    **EC2**: both facts were already on the row and neither was askable. `LaunchTime` was discarded; `account_id` existed only as the fifth field of a native key nothing filters on. `launch_time` is normalised to aware-UTC ISO-8601 — the shape `attribute_filters` casts — and the test stubs a +02:00 zone on purpose, because stamping the raw rendering makes every date predicate over it compare as NULL and quietly match nothing. Omitted when absent rather than stamped `""`: an empty string is present-but-unreadable, satisfies `exists`, fails every comparison, and `missing` could never find it.

    **EntraID membership**: this reverses the v1 position that the `group_members` evidence query covered the need. It did not — evidence answers a question you already know to ask, one group at a time, and cannot answer "which users in group X have a password expiring this week" at all, because that is a JOIN and evidence is a fetch. Membership now lands as a `part-of` edge from member to group, so groups are discovered BEFORE users (an edge is declared on its SOURCE and its target must be in the same batch).

    Three deliberate choices:
    1. **Direct members, not transitive.** `/transitiveMembers` answers "who does Entra's token treat as a member" — true, and the wrong answer for a report about who was *granted* something.
    2. **The member-id lookup is case-folded.** Graph returns object ids in inconsistent case between endpoints, and a case-sensitive miss fails SILENTLY: every user comes back in no groups, indistinguishable from a directory where nobody is in one. The fixture stubs the member list upper-cased so a regression is caught.
    3. **Bounded fan-out, and loud.** `_MEMBERSHIP_GROUP_LIMIT` caps the per-group calls (that fan-out is why v1 deferred this). Over the limit every group is still discovered and the shortfall is a WARNING with numbers in `extra` — a partially-edged directory would otherwise read as "these groups are empty". A group ISE lacks permission on costs only that group's edges.

    No new Graph grant needed: `Group.Read.All` already covers `/groups/{id}/members`.

    Hit the shared-fixture-counts trap on the way: adding a second (empty) group to the shared EntraID payload moved the tenant-rollup assertion in test_entraid_alerts.py from "1 identity-group" to "2 identity-groups".
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Make the three exemplar reports return real rows. AWS: EC2 discovery adds `launch_time` (ISO) + `account_id` attributes (reuse the ARN parse at aws.py:100). EntraID: materialise user→group membership as `part-of` edges during group discovery so the report group-scope filter (and anything else) can answer "users in group X" from the DB.

Done = after a sync, an EC2 report shows launch_time/account_id and a group-scoped Entra user report returns members. No migration, no api-types regen; independent of the other tasks — can run in parallel.