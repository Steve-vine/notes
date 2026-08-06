---
id: 01KZ9MY91SRHW4041EQYTRX010
created: 2026-08-05T19:03:27.03331Z
updated: 2026-08-06T08:34:28.849145Z
type: task
title: Facts sync, liveness and entity binding — servers become estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 565
sprint: sesjg7z
assignee: steve
label: null
priority: high
task_status: backlog
---
Registered servers become living estate entities (ADR 0084 §read-state). Depends on ISE-564.

**Sync (read-state)**
- Scheduled **identity-facts slice** per registered server via ansible-runner (`setup` / `gather_facts` subset): OS/distribution + version, kernel, addresses, virtualization type, hardware summary. Slow schedule; a successful run is the **liveness sighting** that keeps the entity alive (Canon entity lifecycle). No volatile facts (uptime, memory-free) in the snapshot — churn is counted, not reported.
- **Entity minting/binding**: on-prem servers mint a `server` entity; servers matching an existing cloud entity (EC2 instance, Azure VM) **bind to it** — one entity carrying both cloud and in-OS facts, never a duplicate. Keys join on **hostname** (K8s-node precedent — the DataDog join key), so the unknown-asset back-fill re-links existing DD alerts to the new entities; verify that re-link against staging live data as an explicit acceptance step.
- ENTITY_TYPES change (new `server` type) ⇒ **OpenAPI snapshot reddens on this branch** — regenerate api-types on the feature branch (EntraID-sprint precedent).

**Detect**
- **Observations, never Alerts** (no native detection layer): a server unreachable past a configurable threshold of consecutive failed contacts raises an Observation; recovery resolves it. Single failed contact raises nothing.

**Frontend**
- Fleet list rows gain last-sighting staleness treatment (standard estate staleness UX).
- Entity detail page gains an **in-OS facts card** (works identically for bound cloud entities and on-prem servers).

**Acceptance**: register an EC2 instance → same entity now shows AWS + in-OS facts, no duplicate; an on-prem server appears in the estate; unplugging a test server (or blocking its port) yields a categorised unreachable state and, past threshold, an Observation that resolves on recovery.