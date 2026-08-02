---
id: 01KZ0YRK9K11JD5JQGHZYK9J8E
created: 2026-08-02T10:01:56.787027Z
updated: 2026-08-02T10:28:25.198276Z
type: task
title: Integrations declare their source of record; DataDog and Freshservice stop minting entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 469
sprint: s7j0986
blocked_by:
- 01KZ0YPSH1HNW638H24A56D6FC
- 01KZ0YQ0WCVWAM3CPNCKPBW37Y
assignee: steve
priority: urgent
task_status: todo
---
The observation-versus-record line, made real.

- **Each integration declares what it is a source of record for** — AWS for AWS resources, Kubernetes for cluster objects, EntraID for identity objects, Status Pages for external Applications (nothing else will ever tell ISE that Twilio exists).
- **DataDog is a source of record for nothing**, and neither is Freshservice. DataDog holds Monitors and Alerts; neither is a thing in the estate. Its identifiers become **aliases on entities other sources own**, never entities in their own right.
- A **DataDog APM Service** resolves onto an Application rather than creating one. Synthetic monitors resolve to the Application layer too — they observe an *outcome*, not a resource, and forcing one onto the load balancer or ingress it happens to traverse would blame a component for a fault that could be anywhere along the path.
- **A monitor is a rule; an alert is an instance.** A fleet-wide monitor ("high CPU on any VM") has no subject *as a rule*, but every alert it fires does — it fired *about* a specific host. Resolution therefore matches on what the alert fired **about**, never on what the monitor is scoped to. An alert that genuinely names no subject belongs to the integration or a group, and saying so is honest rather than a failure.

**SEQUENCING RISK — read before starting.** DataDog is currently the *only* enabled entity source for hosts and clusters in production (263 of the estate's discovered entities; AWS, Azure and all three Kubernetes systems are deliberately disabled during testing). Demoting DataDog before those are enabled would empty most of the estate. This must ship **with** the unknown-assets task, so what DataDog observes but no longer owns becomes a visible coverage gap rather than silently vanishing.

**Acceptance**: no connector without a declared source-of-record scope creates entities; existing DataDog-minted entities are converted to aliases or surfaced as unknown assets, never silently deleted; an alert from a fleet-wide monitor resolves to the host it fired about; the estate's entity count change is explained and expected, not a surprise.

Depends on the ADR and the entity-types task. Ship alongside unknown assets.