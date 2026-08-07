---
id: 01KZ12CM21GB4RCB4AKDSNKK08
created: 2026-08-02T11:05:18.657126Z
updated: 2026-08-07T10:09:34.657786Z
type: task
title: 'Overview: grey out integration tiles disabled in Settings → Integrations'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 485
sprint: sfv5yw0
comments:
- id: 01KZ1QXG8QMDJHYD927SB7BTH8
  author: Steve Vine
  at: 2026-08-02T17:21:31.927416Z
  text: |-
    Done — PR #420, merged to staging (ad22ce7), staging CI green and deployed.

    Overview tiles now dim when the integration's State toggle is off in Settings → Integrations.

    Went slightly further than "grey out", because greying alone would have left the tile lying: it was still reporting health and last-sync time, so a paused integration read as "connected, synced 3 hours ago" — indistinguishable from a live one that has gone quiet, and the fastest route to someone hunting a fault that is not there. It now shows a single "disabled" pill in place of health/staleness, and "Switched off in Settings — not syncing" where the sync time was.

    Dimmed AND labelled deliberately: opacity alone would leave the state carried by colour only. Follows the voice IntegrationDisabledAlert established in ISE-461 / ADR 0072.
assignee: steve
label: null
priority: medium
task_status: done
---
UI tweak on the Overview page — grey out any Integration tiles whose integration is disabled (State toggle off) in Settings → Integrations.