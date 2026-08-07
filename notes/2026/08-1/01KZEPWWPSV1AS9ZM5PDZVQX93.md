---
id: 01KZEPWWPSV1AS9ZM5PDZVQX93
created: 2026-08-07T18:13:50.937723Z
updated: 2026-08-07T18:14:21.553665Z
type: task
title: 'Connector gaps: EC2 launch_time/account_id, Entra group-membership edges'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 618
sprint: sw5yz4n
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Make the three exemplar reports return real rows. AWS: EC2 discovery adds `launch_time` (ISO) + `account_id` attributes (reuse the ARN parse at aws.py:100). EntraID: materialise user→group membership as `part-of` edges during group discovery so the report group-scope filter (and anything else) can answer "users in group X" from the DB.

Done = after a sync, an EC2 report shows launch_time/account_id and a group-scoped Entra user report returns members. No migration, no api-types regen; independent of the other tasks — can run in parallel.