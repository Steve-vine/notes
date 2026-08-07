---
id: 01KYHZY0A67PT87PGRHHWMVPGR
created: 2026-07-27T14:33:46.05469Z
updated: 2026-08-07T08:59:18.976118Z
type: memo
title: Infrastructure Tagging Strategy
project: 01KX671DATY39VW6GWK3M2T3DN
---
The following tagging strategy is used across the organisation, for all tag-able assets, providing optimal visibility into infrastructure state.

## Contract

Tags state **identity** — facts about an asset that are knowable at provision time and rarely change. Relationships (what depends on what, what a business service is made of) are **not** tagged; they are composed by consuming platforms from these tags.

A **business service is a platform-relative grouping**, not a tagged thing. From an "is everything working" point of view, ISE defines what a business service is (Groups built from tag rules, dashboard services built from groups); from a cost point of view, DataDog does. Not every component can break and not every component costs money — it is down to the platform surfacing the business service to group the components. The tagging strategy's only job is to give every platform sufficient primitives to build its grouping. No platform is privileged.

## Mandatory tags

Every taggable asset carries all of these.

| Key | Meaning | Values | Applied by |
|---|---|---|---|
| `app` **or** `project` (exactly one) | `app`: the broader application this software component belongs to. `project`: the broader infrastructure setup this asset belongs to (e.g. a Kubernetes cluster and its estate). | Controlled lists (below) | Application pipeline / infrastructure pipeline |
| `env` | Deployment stage | `production` \| `staging` \| `dev` \| `test` | The pipeline |
| `impact` | What loss of this asset means for its own app/project | `high` \| `medium` \| `low` (below) | The pipeline |

### `impact` semantics

`impact` is a **structural fact about the asset**, relative to the `app`/`project` it belongs to — not business criticality (that lives in each platform's service definition):

- `impact:high` — loss of this asset means its app/project is probably **down**.
- `impact:medium` — loss of this asset means its app/project is probably **impacted/degraded**.
- `impact:low` — this asset is redundant; loss of **one instance** has no expected effect.

Rules:

- **Missing tag = `high`.** Platforms must treat an asset with no `impact` tag pessimistically. The failure mode of lazy tagging is noisy over-alerting (pressure to tag correctly), never a silently swallowed outage.
- **`impact:low` is per-instance.** Losing all replicas of a redundant set is still an outage. Aggregation logic ("N of M low-impact members down → treat as high") belongs to the consuming platform, not the tag.
- Service severity is computed by the platform: asset alerts → its `impact` says what happens to its app/project → the platform's groupings say which business services contain that app/project.

## Optional tags

Apply where meaningful.

| Key | Meaning | Values |
|---|---|---|
| `region` | Business region the asset serves | `uk` \| `us` |
| `component` | Role within the app — turns "3 things alerting" into "kora has lost its database" | `api`, `worker`, `database`, `queue`, `ingress`, `cache`, … |

## Rules

1. **Exactly one of `app`/`project`, decided by the pipeline test:** if the application pipeline built it, it gets `app`; if the infrastructure pipeline built it, it gets `project`. Dedicated middleware provisioned for and lifecycled with one application is `app`; shared substrate that outlives any one application is `project`.
2. **All keys and values are lowercase, no spaces, single-valued.** Per-platform spelling differences (case, delimiters, tags vs labels) are reconciled by the consuming platform, never by taggers.
3. **Values are opaque identifiers — nothing may parse them.** `project:envstaginguk` names one thing; it does not encode where it is or what it does. Facts you want to filter on get their own tag — that is why `env` exists even though project names happen to contain it, and why `region` exists rather than parsing `uk` out of a name.
4. **Business services are never tagged.** They are groupings composed by each platform from these tags, relative to that platform's interest.
5. **New values require a controlled-list update.** Adding an app or project means adding it to the lists in this document (and to the pipelines) — that is the moment its definition gets agreed.

## Controlled value lists

### `app`

- `kora`
- `chinwag`

### `project`

- `envstaginguk`
- `envstagingus`
- `envproductionuk`
- `envproductionus`

## Deliberately excluded

Recorded so these aren't re-litigated:

- **`service`** — a business service is a relative, platform-composed grouping (see Contract). Tagging it multi-values or goes stale the moment shared infrastructure serves more than one service.
- **`owner`** — the team is small enough that ownership routing adds no information today. Revisit if the org grows.
- **`managed-by`** — pipelines already stamp their own provenance tags in their own formats; duplicating them here would drift.
- **Cost keys (`cost-centre` etc.)** — cost-by-business-service is composed platform-side (DataDog) from `app`/`project`; an app→cost-centre mapping lives in one place there, not on thousands of assets.
- **`tier`** — replaced by `impact` (`tier` is overloaded: business-criticality tiers, web/app/db stack tiers).