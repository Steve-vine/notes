---
id: 01KZ0YRBF68QZJW46M7CX4FBFH
created: 2026-08-02T10:01:48.774301Z
updated: 2026-08-05T14:49:10.177984Z
type: task
title: Business Services compose Applications
project: 01KX671DATY39VW6GWK3M2T3DN
number: 468
sprint: s7j0986
blocked_by:
- 01KZ0YQWRV5728MHEBDPSBG3T5
comments:
- id: 01KZ1A4KZ29K2PFSCGZ75DKY5V
  author: Steve Vine
  at: 2026-08-02T13:20:45.026628Z
  text: |-
    Built and up for review — PR #411 (feature/ise-468-business-services), merged to staging. Stacked on #410; no migration (type + edge arrived in 0084/0088).

    - The top layer, asserted whole: Business Service entity composed of Applications on asserted composes edges — one hop up the same edge type. Never equal to one Application; only Applications compose (Resource or BS in the composition = 422); never touched by discovery (no last_seen, sweep-immune); create/recompose/remove only via the audited API.
    - "There are no test Business Services": a composed Application whose environment isn't customer-facing (ISE-465 marker) is flagged on every read, alerted on the row, and warned in the composition picker — a detectable fault, never accepted configuration.
    - The rollup: impact climbs Resource → Applications → Business Services through composition edges (never environment matching); summarise() leads with the Business Services; ImpactPanel shows both layers as linked badges on incident/entity screens.
    - /business-services screen: list + fault alerts, create/edit modal (name + Application multi-select), removal; nav after Applications.
    - 6 backend + 2 frontend tests incl. the full Resource→App→BS impact chain. All gates green (89 files / 491 frontend tests).
assignee: steve
priority: high
task_status: done
---
Connect the existing dashboard service model to the Application layer, so the top of the model is real rather than a separate parallel concept.

- A **Business Service** is composed of one or more Applications, and **has no environment of its own** — it composes whichever Application instances are customer-facing (normally Production, and Demo where customers use it). The test is whether a customer touches the environment, not what it is called.
- **There are no test Business Services.** A Business Service that has picked up a non-customer-facing Application is a detectable fault, not a configuration.
- **An Application is never a Business Service**, even at 1:1.
- **Never retired by discovery**; lifecycle belongs to the assertion that created it.
- `impact` stays an ordinary governed tag key and remains an input to Business Service rules — not a role.

Consolidation matters here: ISE currently has overlapping half-notions of "service" (the `service` entity type, dashboard services, status-page services). This task is where the top layer becomes one concept rather than a fourth.

**UI**: composition editing on the Business Service, and the rollup — a Resource going red showing which Business Services are affected, through the composition edges rather than through environment matching.

**Acceptance**: an operator can define a Business Service from Applications and see, from a failing Resource, which Business Services are impacted.

Depends on the Applications-as-entities task.