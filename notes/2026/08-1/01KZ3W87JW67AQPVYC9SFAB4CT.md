---
id: 01KZ3W87JW67AQPVYC9SFAB4CT
created: 2026-08-03T13:15:46.652331Z
updated: 2026-08-13T19:00:07.562869Z
type: task
title: 'Estate: Karpenter-churned nodes linger as live hosts for days'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 514
order: 2.0
sprint: skxht3g
comments:
- id: 01KZ3Z1ARTZN957B1C23FHS6XZ
  author: Steve Vine
  at: 2026-08-03T14:04:26.266048Z
  text: |-
    Done in PR #437 (feature/ise-514-retire-churned-hosts).

    Implemented the suggested rule as `retire_confirmed_gone` in estate_lifecycle.py: absence is only ambiguous while some integration that knows the entity hasn't looked since. Once every system holding an alias has completed a successful sync after the last sighting and none reported it, gone is the unanimous verdict of everything that can see. Runs after the window pass so it only judges what the windows left alone.

    Nice property that made this simpler than expected: no schema change needed. `system.last_synced_at` is only stamped by a sync that SUCCEEDED (sync.py returns early on the error path), so comparing it against `entity.last_seen_at` per knowing system gives exactly "has this source looked since, and not found it" — and a disabled/erroring/behind system automatically holds the entity open. Fail-safe by construction.

    One real risk needed a guard: Kubernetes fails its whole sync if inventory listing fails (so last_synced_at never advances on a bad pass), but AWS contains a failing EC2 call to a warning and an empty list — a successful sync with an empty slice is indistinguishable from a fleet vanishing. So if one system would lose more than half the live entities of a type in a single sweep, the early path stands down and logs. It only applies above a floor of 5 (losing the only host a system knows is 100% of them and entirely ordinary — my first version had no floor and refused to retire single hosts, which the tests caught). Your prod-uk case, 12 ghosts of 37, passes comfortably.

    `entity_confirmed_gone_after_minutes` defaults to 60 so one unlucky pass can't act instantly; 0 disables the early path entirely. Retirement stays reversible — the next sighting un-retires in place.

    Expected effect: the 15 ghosts retire on the next lifecycle sweep after each cluster/account has synced once more; going forward a terminated node disappears within the hour rather than after days. Note this is independent of ISE-511 — the two mis-named staging-uk hosts will retire here whatever they are called.

    Tests: 8 new cases (unanimity, the holdout, never-succeeded sync, grace/zero, wholesale stand-down, realistic 3-of-12 share, no-witness entity, un-retire after early retirement). Full lifecycle suite green (27), ruff/format/mypy strict clean.
- id: 01KZ429AGBXPP3G70ASMMPAKT8
  author: Steve Vine
  at: 2026-08-03T15:01:13.866843Z
  text: |-
    RELEASED to main 2026-08-03 (PR #437 merged, main 34366df, no migration). Staging smoke passed and staging reset to main.

    The 15 ghosts retire on the next lifecycle sweep once each cluster/AWS account has completed one more successful sync. Nothing to run by hand — the sweep is beat-dispatched hourly. If any of them stay live, the likely reason is a system that hasn't synced successfully since the sighting (which by design holds the entity open), so check the integration's health first.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Improvement from Sprint 46 Estate testing. Across the four env clusters, 15 hosts shown live in the Estate no longer exist — the nodes were terminated by Karpenter and the EC2 instances are gone from AWS entirely (2 staging-uk, 3 staging-us, 6 prod-uk, 4 prod-us — nearly half of prod-uk's host list). The per-type retirement window (days) is right for pets but too slow for Karpenter cattle.

**AWS-side confirmation (2026-08-03):** diffing the AWS accounts directly shows the same ghosts from the instance view — Staging 58 hosts in ISE vs 54 live in AWS (4 ghosts); Production 37 vs 25 (**12 ghosts, a third of the production host list**). All ghost instances are fully terminated (not stopped — absent from describe-instances). Everything else in both AWS accounts (buckets, databases, load balancers, EKS clusters) matches ISE 1:1.

Suggestion: retire a host early when every source that ever reported it now agrees it's gone (k8s node absent AND AWS instance not found AND no fresh DataDog sighting), rather than waiting the full staleness window. Related: the two staging-uk ghosts are also the mis-named hosts in ISE-511.