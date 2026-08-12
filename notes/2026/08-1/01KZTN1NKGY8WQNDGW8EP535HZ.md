---
id: 01KZTN1NKGY8WQNDGW8EP535HZ
created: 2026-08-12T09:32:23.536535Z
updated: 2026-08-12T09:32:30.732697Z
type: task
title: 'Kubernetes: read the DataDog Autodiscovery tags annotation'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 660
sprint: sj9fsph
assignee: steve
label:
- bug
priority: urgent
task_status: active
---
Found while smoke testing Sprint 60. `mp-app` and `mp-env` were applied to the Chinwag workloads, are visible in DataDog, and **never reach the estate**.

They are not labels. They live in a Kubernetes **annotation** on the Rollout's pod template:

```
ad.datadoghq.com/tags = {"mp-env": "prod", "mp-app": "chinwag-v2"}
```

That is DataDog's Autodiscovery convention — the agent reads the annotation and applies those tags to the pods' metrics, which is why they show in DataDog. **ISE reads `metadata.labels` only and never annotations** (the capture gap recorded as deferred in ADR 0096), so `mp-app` has never entered the tag pool from any source.

**Scale:** 64 rollouts carry it — 16 each on env-production-uk-pri, env-production-us-pri, env-staging-uk, env-staging-us. Every one has both keys.

**Why it is urgent, not cosmetic:** the Tag Dictionary roles are ALREADY bound to these keys (Application → `mp-app`, Environment → `mp-env`). So the entire Business Application layer is pointed at two tags ISE cannot see: every Application-role rule resolves to `mp-app:` and matches nothing, and `detect_candidates` needs both on one entity and gets zero. This is the `app:`/`env:` disjointness the Sprint 60 diagnosis turned on — being actively fixed at source, invisibly.

**The change:** read `ad.datadoghq.com/tags` as tags alongside labels, on the objects the connector already reads labels from (built-in workloads and dictionary-defined custom kinds such as Rollouts).

- Parse as the JSON key→value map it is; ignore silently when it is not valid JSON, so one bad annotation cannot fail a cluster's sync
- Everything downstream unchanged: same pool, same deny-list, same length and control-character rules
- **NOT** "read all annotations" — that sweeps in `kubectl.kubernetes.io/last-applied-configuration` and `argocd.argoproj.io/tracking-id`, which are machinery. This annotation's whole purpose is to carry operator-chosen tags, which is exactly the line the connector's existing label/deny design already draws.

Close the corresponding line in ADR 0096's deferred-capture list.