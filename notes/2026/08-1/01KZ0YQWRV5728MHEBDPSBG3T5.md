---
id: 01KZ0YQWRV5728MHEBDPSBG3T5
created: 2026-08-02T10:01:33.723746Z
updated: 2026-08-02T12:01:50.845811Z
type: task
title: 'Applications as entities: proposal-seeded, predicate-backed, derived membership'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 466
sprint: s7j0986
blocked_by:
- 01KZ0YQ0WCVWAM3CPNCKPBW37Y
- 01KZ0YQ7TJ30GJKTE928QNPR98
assignee: steve
priority: high
task_status: active
---
The middle layer, and the load-bearing piece of the sprint.

An Application must be a real entity, not a derived view over a tag query — annotations, incident memory, playbooks, severity overrides and Business Service composition all need a stable id, and a query result has no identity across time.

**The split**: existence is authored, membership is derived.

- **Existence** — a tag pattern *proposes* an Application ("workloads tagged `app:chinwag env:prod` suggest `Chinwag.Prod`, composed of these three"), a human confirms, and the confirmation creates the entity. **One proposal per Application, not one per workload.** Rejection is remembered so it isn't re-asked.
- **Membership** — continuously derived from tags, machine-maintained on `rule`-provenance edges, exactly as tag-rule groups work today.
- **Identity** — name and environment as **two fields**, `Chinwag.Prod` derived for display. Listing all Production Applications, listing all Chinwag instances, and validating the environment against the governed vocabulary all need it to be a field, not something parsed out of a name.
- **The Application stores its own membership predicate.** Without it, renaming `app:chinwag` → `app:chinwag-web` silently forks the Application and orphans its incident history. With it, a tag rename is an *edit*.
- **Never retired by discovery** — the treatment `group` has today. Every Resource disappearing raises an **Observation**, because only a human knows whether that's a broken sync, a deployment gap or a decommission. Removal is explicit and audited; history survives it.

**Why the layer earns its keep — the Application is the stable anchor.** Workloads recycle constantly and the Application does not, so it is the right subject for the things that must attach to the most stable thing available: incident memory, playbooks and annotations. It is also the layer a DataDog APM Service and a synthetic monitor resolve onto (see the source-of-record task).

**Membership is many-to-many.** A Resource may serve several Applications — the shared database is the ordinary case — so **Application→Resource is a relationship, not an attribute**: a tag can seed it, it cannot express many. This is the payoff of the whole layer: a shared database going red is three Business Services impacted, and severity becomes contextual rather than fixed. Do not model membership as a single field on the Resource.

**Also in scope**: the **Application→Resource composition edge type**. It is composition, not placement — reusing `runs-on` would inherit that type's exclusion from drift checks and the impact walk, silently breaking the rollup the layer exists to provide.

Reuse the tag-rule machinery (predicate matching, membership-edge maintenance) but an Application is **not** a `group` — same mechanism, distinct type and screen.

Depends on the entity-types and tag-roles tasks.