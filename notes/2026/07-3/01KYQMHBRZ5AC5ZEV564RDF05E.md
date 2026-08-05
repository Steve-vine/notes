---
id: 01KYQMHBRZ5AC5ZEV564RDF05E
created: 2026-07-29T19:10:04.063527Z
updated: 2026-08-05T12:33:40.969848Z
type: task
title: AWS account surface on System detail
project: 01KX671DATY39VW6GWK3M2T3DN
number: 363
sprint: sjyt01k
blocked_by:
- 01KYQMGWJYCQQDXCA7MPZ5245E
comments:
- id: 01KYQVQ4RQKR9QVBNT01S7ZDV6
  author: Steve Vine
  at: 2026-07-29T21:15:33.526995Z
  text: |-
    Built and shipped to review. PR #336 (stacked on #335), merged to staging.

    What landed: an AWS account card on System detail (shown for aws integrations, the ClusterLinkCard pattern) — account id badge (read off the account-scoped aliases), region list editable in place (saves via PUT /systems/{id}/aws-config, admin-gated, server-validated), discovered resource counts by type, and an active-alarm badge (red when firing). Backed by a new GET /systems/{id}/aws-summary computed entirely from ISE's own record — no AWS round-trip per page view. api-types regenerated.

    Verified by test_aws_summary_rolls_up_the_account (stubbed discovery+detect → account id, regions, 5 resource-type counts, 3 firing alarms).

    Smoke on staging: open the AWS integration's System page — the card should show the account at a glance and region edits should take effect on the next sync.
assignee: steve
label: null
priority: medium
task_status: done
---
The sprint's dedicated pane-of-glass slice beyond the generic capability-driven screens: an AWS card on `SystemDetailPage.tsx`.

- Account id (from health/STS), configured regions — editable via the `aws_config` tenant from the foundation task (kind_dictionary card pattern).
- Discovered resource counts by type; active alarm count.

**Done when:** opening an AWS integration's System detail page shows the account at a glance (identity, regions, what's discovered, what's alarming) and regions can be edited in place.