---
id: 01KZ0YRK9K11JD5JQGHZYK9J8E
created: 2026-08-02T10:01:56.787027Z
updated: 2026-08-02T10:03:32.93713Z
type: task
title: Integrations declare their source of record; DataDog and Freshservice stop minting entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 469
sprint: s7j0986
assignee: steve
label: null
priority: urgent
task_status: backlog
---
The observation-versus-record line, made real.

- **Each integration declares what it is a source of record for** — AWS for AWS resources, Kubernetes for cluster objects, EntraID for identity objects, Status Pages for external Applications (nothing else will ever tell ISE that Twilio exists).
- **DataDog is a source of record for nothing**, and neither is Freshservice. DataDog holds Monitors and Alerts; neither is a thing in the estate. Its identifiers become **aliases on entities other sources own**, never entities in their own right.
- A **DataDog APM Service** resolves onto an Application rather than creating one. Synthetic monitors resolve to the Application layer too — they observe an outcome, not a resource.

**SEQUENCING RISK — read before starting.** DataDog is currently the *only* enabled entity source for hosts and clusters in production (263 of the estate's discovered entities; AWS, Azure and all three Kubernetes systems are deliberately disabled during testing). Demoting DataDog before those are enabled would empty most of the estate. This must ship **with** the unknown-assets task, so what DataDog observes but no longer owns becomes a visible coverage gap rather than silently vanishing.

**Acceptance**: no connector without a declared source-of-record scope creates entities; existing DataDog-minted entities are converted to aliases or surfaced as unknown assets, never silently deleted; the estate's entity count change is explained and expected, not a surprise.

Depends on the ADR and the entity-types task. Ship alongside unknown assets.