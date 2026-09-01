---
id: 01M1FEWD3H51JM1XQAMS57AFDZ
created: 2026-09-01T21:44:24.433703Z
updated: 2026-09-01T21:44:24.433703Z
type: task
title: 'The Differ: change detection leaves the sync path'
priority: medium
task_status: backlog
label: feature
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 763
tech: null
---
Build the Differ per ADR 0107 and the boundary spec.

Transition detection moves out of `sync.reconcile_findings` and out of the sync transaction, joining the estate-diff work that `drift` does today. The Differ reads the Signal Store and the Estate, detects change, writes transitions back to the signal, and pushes **only what changed** to the Correlator.

**The behaviour that matters:** a signal still firing in the same way produces nothing new upward. That is the mechanism that ends the repeated surfacing of unimportant things — the other half is the Correlator's importance judgement.

Runs per-minute, paced by the Conductor. Affordable because it makes no network calls — unlike today's Obs Loop, which defaults to 86,400s precisely because it dials out.

**Headless.** No user-facing surface of its own.

**Blocked by** the Differ / Correlator boundary spec.