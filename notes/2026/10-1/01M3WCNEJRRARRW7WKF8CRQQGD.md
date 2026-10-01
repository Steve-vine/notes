---
id: 01M3WCNEJRRARRW7WKF8CRQQGD
created: 2026-10-01T18:47:10.68091Z
updated: 2026-10-01T20:55:16.73947Z
type: task
title: Dashboard, compliance by framework
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 824
sprint: s0zzctz
comments:
- id: 01M3WKZWDYM5GQX34TED4YY1TT
  author: Steve Vine
  at: 2026-10-01T20:55:12.57377Z
  text: |-
    Merged: PR #832 (97381c1).

    The Dashboard has a new "Compliance by framework" panel directly below "Compliance by tier", in the same format: each framework's name and version, "5 / 118 met", a +/- marker for which way it has gone in about a month, and the bar with its percentage.

    - The figure is the same one the framework's tile on the Frameworks page shows (requirements met out of those in scope).
    - Each name is a link to that framework.
    - It lists the frameworks the Frameworks page lists by default — current versions only — plus an older version if the company still holds a scope statement against it.
    - A framework with nothing in scope reads "Nothing in scope" / n/a rather than 0%.

    To check on staging: Dashboard, right-hand column under the tiers; compare a figure with the same framework's tile on Playbook ▸ Frameworks.

    Technical: no new arithmetic and no migration — the posture measure and the nightly snapshot already held per-framework scores; GET /api/v1/dashboard now exposes them (frameworks, previous.frameworks). The integration test asserts the Dashboard's figures equal the coverage endpoint's for every framework.
assignee: steve
label: null
priority: medium
task_status: review
---
Below the Compliance by tier section, add a new section called compliance by framework, which shows the compliance score by each framework, same format as the compliance by tier section.