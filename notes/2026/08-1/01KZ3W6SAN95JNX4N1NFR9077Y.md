---
id: 01KZ3W6SAN95JNX4N1NFR9077Y
created: 2026-08-03T13:14:59.285332Z
updated: 2026-08-03T13:15:12.648413Z
type: task
title: 'Estate: production clusters have no kind dictionary — all Rollouts unsynced'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 512
sprint: skxht3g
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Found in Sprint 46 Estate testing (full cluster-vs-DB diff). env-production-uk-pri and env-production-us-pri have no kind-dictionary entries on their System config, so none of their Argo Rollouts are discovered: 34 Rollouts missing in prod-uk (chinwag-prod/-demo, chinwag-v2-prod/-demo, openanswer, scout-prod) and 31 in prod-us. ExternalSecrets are likewise undiscovered. Staging clusters have the Rollout + ExternalSecret entries; production was never configured. g5, mgnt-production-uk-pri and mgnt-staging-uk also have no dictionary (may be intentional — check).

**Fix:** add the Rollout and ExternalSecret preset entries to both production Systems (Settings → kind dictionary editor).

**Order matters:** do this AFTER ISE-510 is fixed — prod Rollouts share DataDog service tags the same way, so syncing them now would permanently collapse them into merged blobs on first discovery.

Services and namespaces verified 1:1 on all four clusters; no other sync gaps.