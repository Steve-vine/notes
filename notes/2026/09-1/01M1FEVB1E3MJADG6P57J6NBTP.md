---
id: 01M1FEVB1E3MJADG6P57J6NBTP
created: 2026-09-01T21:43:49.550412Z
updated: 2026-09-01T21:43:49.550412Z
type: task
title: 'Spec: the prioritisation vocabulary'
assignee: steve
label: brief
priority: high
task_status: todo
project: 01KX671DATY39VW6GWK3M2T3DN
number: 759
tech: null
---
The second of ADR 0107's deferred designs. Produces an ADR.

**The question it must answer:** is this a P1 or a P2 — does someone need to be woken up, or can it wait until morning?

This is the vocabulary the Correlator reasons in, so it is the thing to pin before any escalation logic is written. Everything above the Correlator inherits it, and it is the difference between a priority ISE can defend and another number nobody trusts.

**Candidate dimensions** to accept or reject: service tier, customer impact, business hours and on-call windows, environment weighting, blast radius, and whether a fallback exists (a degraded service with round-robin routing is not the same as one that is down).

**Constraint from ADR 0107:** severity may contribute but is no longer sufficient on its own — today `promote_findings` decides escalation from severity and policy alone, which is exactly why a flapping synthetic on a minor service escalates like an outage.

**Done when** there is an accepted ADR naming the dimensions, where each value comes from, and how they combine into a priority an operator can argue with.