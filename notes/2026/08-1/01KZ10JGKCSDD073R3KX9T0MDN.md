---
id: 01KZ10JGKCSDD073R3KX9T0MDN
created: 2026-08-02T10:33:34.572976Z
updated: 2026-08-05T14:25:12.38788Z
type: task
title: 'Dashboards: shorten wallboard services subheading'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 477
sprint: sfv5yw0
comments:
- id: 01KZ1QV0HYC3V62TBXB4FE64ZG
  author: Steve Vine
  at: 2026-08-02T17:20:10.302071Z
  text: |-
    Done — PR #417, merged to staging (ad22ce7), staging CI green and deployed.

    Subheading now reads "Wallboard services — each tile rolls up the signal state of the estate groups it points at, into a red / amber / green." The dropped phrase stays where it belongs, in ADR 0053's rationale for the wallboard.
assignee: steve
label: null
priority: medium
task_status: done
---
UI tweak on the Dashboards page.

The subheading currently reads:

> Wallboard services — each tile rolls up the signal state of the estate groups it points at, into a red / amber / green anyone can read across the room.

Change it to:

> Wallboard services — each tile rolls up the signal state of the estate groups it points at, into a red / amber / green.

(i.e. drop the trailing "anyone can read across the room.")