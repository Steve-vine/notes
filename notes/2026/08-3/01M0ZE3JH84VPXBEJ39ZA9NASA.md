---
id: 01M0ZE3JH84VPXBEJ39ZA9NASA
created: 2026-08-26T16:22:59.880068Z
updated: 2026-08-26T18:01:52.500583Z
type: task
title: Actions sits above Reports in the sidebar
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 434
sprint: sbph5q5
comments:
- id: 01M0ZKRKT7GGRF6XDJRG5D0D94
  author: Steve Vine
  at: 2026-08-26T18:01:52.199416Z
  text: |-
    Done — PR #419, merged to main.

    Overview now reads Dashboard, Actions, Reports. Labels only — no routes, gates or pages touched.

    It also puts the two ungated entries together, so a library-only account sees Dashboard and Actions adjacent rather than a gap where Reports used to be.

    The Overview assertion in the layout test is an ordered list rather than a membership, which is what makes the order a decision rather than an accident of the array. Renamed it to say what it now asserts, and left it ordered.

    Nothing wrong with the change, but this one took a while for CI reasons worth recording. GitHub dropped the `pull_request` event for all three of today's PRs. Closing and reopening fixed two of them; this one needed a new head SHA (amend + force-push) to fire a `synchronize`. Then `sast` failed on `Failed to find semgrep-core in PATH` — a broken semgrep install on the runner, nothing to do with a nav reorder — and passed on a rerun.

    Also learned that `gh workflow run ci.yml --ref <branch>` cannot gate a PR: every job in the workflow is conditioned on `github.event_name == 'pull_request'`, so a dispatch run completes as `skipped` with zero checks while branch protection keeps waiting. I've corrected the note that recommended it.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: low
task_status: review
---
Overview currently reads Dashboard, Reports, Actions. It should read **Dashboard, Actions, Reports**.

Actions is where you go to find out what you have to do, and Reports is where you go to export something for somebody else. The first is a daily destination and the second is occasional, so the daily one should not be the third thing down.

It also puts the two universal entries together at the top, with the one gated entry below them — Reports keeps `gate: 'Company'` because every one of its rows is company data, so a library-only account sees Dashboard and Actions with nothing between them rather than a gap where Reports used to be.

## Implementation

`components/nav.ts` — move the Actions entry above Reports in `NAV_ITEMS`. Section order is unchanged; only the order within Overview.

`AppLayout.test.tsx` asserts the Overview labels as an ordered list in at least two places (the Reports test and the vendor_admin test added by COM-408), so both move with it. That the order is asserted rather than assumed is the point — it should stay that way.

Labels only. No routes, no gates, no pages.