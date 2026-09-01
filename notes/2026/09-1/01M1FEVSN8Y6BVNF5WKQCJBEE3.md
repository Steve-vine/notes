---
id: 01M1FEVSN8Y6BVNF5WKQCJBEE3
created: 2026-09-01T21:44:04.520042Z
updated: 2026-09-01T21:45:20.499561Z
type: task
title: 'Spec: the Differ / Correlator boundary'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 761
sprint: s7nj09w
assignee: steve
label:
- brief
priority: high
task_status: todo
tech: null
---
ADR 0107 says this boundary "must be exact" but deliberately does not draw it. This task draws it, as a short technical spec rather than a full ADR.

**The split.** `sync.reconcile_findings` today both writes the signal and computes its transition (new / triggered / recurring / recovered) in one pass, inside the sync transaction. Under ADR 0107 the write stays on the integration path and the transition detection becomes the Differ. Everything downstream keys off those transitions.

**What the spec must pin:**
- Exactly which fields the integration write owns and which the Differ owns.
- What the Differ writes back to the Signal Store — the transition lives on the signal, and the next pass must be able to tell what it has already seen.
- What "changed" means for the Estate half, given `drift` already does part of this against `entity_edge.last_confirmed_at`.
- The shape of what the Differ pushes to the Correlator.
- Cadence and idempotency: per-minute, and safe to run twice.

**Latency note to confirm:** an alert now waits for a Differ pass rather than opening an incident inside the sync tick. At a one-minute cadence that is accepted, but it should be stated rather than discovered.

**Headless.** No user-facing surface — this is the contract two later tasks build against.

**Done when** the boundary is written down precisely enough that the Differ and Correlator tasks can be built independently.