---
id: 01KYQMHBRZ5AC5ZEV564RDF05E
created: 2026-07-29T19:10:04.063527Z
updated: 2026-07-29T19:10:13.784657Z
type: task
title: AWS account surface on System detail
project: 01KX671DATY39VW6GWK3M2T3DN
number: 363
sprint: sjyt01k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
The sprint's dedicated pane-of-glass slice beyond the generic capability-driven screens: an AWS card on `SystemDetailPage.tsx`.

- Account id (from health/STS), configured regions — editable via the `aws_config` tenant from the foundation task (kind_dictionary card pattern).
- Discovered resource counts by type; active alarm count.

**Done when:** opening an AWS integration's System detail page shows the account at a glance (identity, regions, what's discovered, what's alarming) and regions can be edited in place.