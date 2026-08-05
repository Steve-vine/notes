---
id: 01KZ9508ASKC1FTEZJRKHYG2CZ
created: 2026-08-05T14:24:54.617603Z
updated: 2026-08-05T14:25:44.087743Z
type: task
title: 'Signal Detail Modal: show the affected entity''s key details and tags inline, not just a link'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 562
sprint: scb3vol
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Found during Sprint 50 incident-management testing: the Signal Detail Modal (`components/SignalDetail.tsx`) links to the affected entity but shows none of its detail — the operator has to leave the modal to see what the signal is actually about.

## Scope

Show the affected entity's key details inline on the modal, as the Entity page presents them, e.g.:

- **deepgram-engine**
- Type: workload
- Location: in deepgram-flux on cluster-envstaginguk-ekscluster
- named by: env-staging-uk
- Application environment: not stated
- Infrastructure environment: staging (inherited from cluster-envstaginguk-ekscluster)

Then the list of tags associated with the entity.

Keep the existing link through to the full Entity page.