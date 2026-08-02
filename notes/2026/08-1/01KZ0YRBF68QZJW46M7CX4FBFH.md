---
id: 01KZ0YRBF68QZJW46M7CX4FBFH
created: 2026-08-02T10:01:48.774301Z
updated: 2026-08-02T10:01:48.774301Z
type: task
title: Business Services compose Applications
assignee: steve
label: feature
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 468
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