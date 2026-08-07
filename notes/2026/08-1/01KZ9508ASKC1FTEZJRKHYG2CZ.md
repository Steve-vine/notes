---
id: 01KZ9508ASKC1FTEZJRKHYG2CZ
created: 2026-08-05T14:24:54.617603Z
updated: 2026-08-07T08:34:48.696426Z
type: task
title: 'Signal Detail Modal: show the affected entity''s key details and tags inline, not just a link'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 562
sprint: scb3vol
comments:
- id: 01KZ9B88DEV2V660Q38J128WC8
  author: Steve Vine
  at: 2026-08-05T16:14:08.302098Z
  text: |-
    Built on feature/ise-562-signal-entity-details, PR #479 (targeting main), merged to staging.

    New EntityContext section on the Signal Detail Modal, rendered when the signal resolves to an entity — the entity's key details exactly as the Entity page leads with them: name (linked) + type badge, containment scope ("in deepgram-flux on cluster-envstaginguk-ekscluster"), naming provenance ("named by env-staging-uk", hidden when pinned), and both environment dimensions with the Entity page's semantics (unknown is stated — "not stated" — never guessed; an inherited infrastructure environment names and links its source), followed by the entity's tags as clickable TagBadges.

    Data comes from the existing GET /entities/{id} under the same ['entity', id] query key as the Entity page, so the two share a cache entry — no backend change. The existing grid link through to the full Entity page stays; a signal with no resolved entity renders the modal unchanged.

    Tests: new SignalDetail.test.tsx covering the full section (including the "inherited from" source link and "not stated") and the no-entity case. Build/eslint/prettier clean.
assignee: steve
priority: medium
task_status: done
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