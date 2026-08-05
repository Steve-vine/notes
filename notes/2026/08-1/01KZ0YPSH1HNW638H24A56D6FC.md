---
id: 01KZ0YPSH1HNW638H24A56D6FC
created: 2026-08-02T10:00:57.633362Z
updated: 2026-08-05T12:34:34.643003Z
type: task
title: 'ADR 0073: the three-layer estate model (amends ADR 0028)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 462
sprint: s7j0986
comments:
- id: 01KZ1088Y4BAE6HCE19V4GCPHJ
  author: Steve Vine
  at: 2026-08-02T10:27:59.04451Z
  text: |-
    ADR 0073 written and up for review — PR #401 (feature/ise-462-adr-0073-three-layer-estate), merged to staging.

    - docs/decisions/0073-three-layer-estate-model.md: codifies the full Sprint 45 design from the Canon section — three layers with dependency direction, discovered-vs-asserted, source-of-record declarations (DataDog/Freshservice = nothing), unknown assets (flag, never mint), entity-type reshaping incl. workload-stays-a-Resource with the many-to-one argument, Applications as predicate-backed entities with a dedicated composition edge type, monitor-is-a-rule/alert-is-an-instance, two independent environment dimensions with containment-inherited infra env, tag roles + dimension-scoped value lists, exactly-one-of-app/project compliance rule, source-of-record naming (retires _named_only_by), and the three tag-arrival paths incl. integration-level defaults.
    - ADR 0028 status annotated "amended by 0073" (body untouched — append-only respected); README index updated for both.
    - Docs-only change; PR CI is the gate. Consequences section carries the ISE-469/470 sequencing warning (DataDog demotion must ship with unknown-asset flagging or the estate empties).
assignee: steve
priority: high
task_status: done
---
**Foundation task — blocks most of the sprint.** Codify the design agreed 2026-08-02 and recorded in the ISE Canon ("The three layers of the estate"). Substantially amends ADR 0028's discovery model, so it needs its own ADR rather than living only in the Canon.

Covers:

- **Three layers** — Business Service → Application → Resource, with the definitions as settled (Application defined by *consumption*, by a person or another application, so VPN/DNS/gateways qualify; an Application is never a Business Service even at 1:1).
- **Who owns the truth**: Resources are discovered, Applications and Business Services are asserted. This is the line the whole model rests on.
- **Each integration declares what it is a source of record for.** DataDog and Freshservice are a source of record for nothing — DataDog holds Monitors and Alerts, and neither is a thing in the estate. Its identifiers become aliases on entities other sources own.
- **A Kubernetes workload is a Resource** (workloads map many-to-one onto Applications).
- **Naming discipline** — "service" is always qualified; Business Service / Kubernetes Service / DataDog APM Service.
- **Environments are two independent dimensions**, neither inferred from nor validated against the other; infrastructure environment inherited by containment.
- **Unknown assets** — alerts against unclaimed things are flagged, never minted as placeholder entities.
- **Application→Resource is a composition edge with its own type**, not `runs-on`.

Grounding: ADR 0028 (estate knowledge base), 0037 (tag pool), 0039 (entity lifecycle), 0041 (proposals), 0057 (status page register).

**Acceptance**: ADR 0073 accepted in `docs/decisions/`, cross-referenced from ADR 0028; the Canon section and the ADR agree.