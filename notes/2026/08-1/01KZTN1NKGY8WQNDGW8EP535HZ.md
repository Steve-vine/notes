---
id: 01KZTN1NKGY8WQNDGW8EP535HZ
created: 2026-08-12T09:32:23.536535Z
updated: 2026-08-12T10:11:31.175446Z
type: task
title: 'Kubernetes: read the DataDog Autodiscovery tags annotation'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 660
sprint: sj9fsph
comments:
- id: 01KZTQ91NDVNHCGHHW9K1K7HGV
  author: Steve Vine
  at: 2026-08-12T10:11:22.413395Z
  text: |-
    Done — PR #611, merged as d516c28, deployed to staging.

    **Verified on the live estate after the first sync:**
    - `mp-app:chinwag-v2` on 16 entities; `mp-env` on 16 (8 `prod`, 8 `demo`)
    - **16 entities now carry BOTH an application tag and an environment tag** — the overlap that has never existed in this estate, and the precondition ADR 0096 §2 and the seeding detector both assume
    - A rule against the Application role resolves: `mp-app:chinwag-v2 in prod` → 8 members, `in demo` → 8, no environment → 16, none at fault

    (That is uk-pri only so far; the other three clusters bring another 48 on their own sync intervals.)

    **One thing still blocked, and it is configuration rather than code.** `detect_candidates` returns nothing — `_candidate_pairs` requires the resolved environment to be a governed **application-dimension value on the bound key**, and `mp-env` has no governed values at all. The whole vocabulary (`prod`/`demo`/`dev`/`test` application, `production`/`staging`/… infrastructure) still sits on the old `env` key.

    The code is right to refuse: "not a recognised application environment — not guessed at". But the consequence is worth stating plainly, because the two halves behave differently:

    - **Hand-authored Business Applications work today.** Rules resolve against `mp-env` regardless of the vocabulary.
    - **Auto-proposals do not**, until `mp-env` gains application-dimension values `prod` and `demo` (both customer-facing, as they are on `env`), and whichever of `dev`/`test` are in use.

    Not doing that unasked — the governed vocabulary is an operator decision and rebinding is audited and warned for good reason.
assignee: steve
label:
- bug
priority: urgent
task_status: review
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