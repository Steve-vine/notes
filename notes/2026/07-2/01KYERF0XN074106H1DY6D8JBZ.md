---
id: 01KYERF0XN074106H1DY6D8JBZ
created: 2026-07-26T08:25:31.829377Z
updated: 2026-07-26T08:38:30.679421Z
type: task
title: Estate drift watches durable knowledge; placement churn is counted, not reported
project: 01KX671DATY39VW6GWK3M2T3DN
number: 301
sprint: svgrad3
assignee: steve
label:
- bug
- improvement
priority: high
task_status: active
---
**Sprint 24, live-found (2026-07-26).** 528 of the estate's 549 open findings are low-severity `estate_drift` observations — 472 `runs-on` + 56 `part-of`, virtually all pointing at Karpenter-managed EC2 nodes (`ip-172-21-*`). Node recycling is normal operation on this estate; one observation per vanished placement edge is noise by construction, they never resolve (all sit `new`), and they are the supply side of the ISE-300 haystack (the 424-finding dump that killed the first post-batch analyse run).

**1. Scope the drift detector to durable knowledge** (the stable-vs-volatile lesson applied to drift):
- STOP observing volatile placement edges — `runs-on` and discovery-derived `part-of`. Discovery set-replacement + entity retirement (ISE-204..209) already handle them silently.
- KEEP drift observations for what signals knowledge-base rot: `depends-on` / `routes-to`, anything **human-asserted or human-confirmed** (a human signature diverging from reality always surfaces), structural containment of stable entities.
- Optional roll-up: genuinely unexpected mass placement loss (e.g. >50% of a cluster's placement edges in one pass) surfaces as ONE observation, not hundreds.

**2. Guard against the fault the noise was hiding** (Steve's requirement: a faulty node flapping ready/unready causing repeated rescheduling must not go unseen). Alert on the RATE, not the event — churn and faults have identical events but different distributions:
- **Node Ready-flap detector** (k8s obs detectors): node `Ready`-condition transitions / `NodeNotReady` events ≥N in a window → one **medium** observation on the node entity. A replaced Karpenter node goes away; a faulty one flaps — clean separation.
- **Reschedule-rate guard** (estate layer): when discovery replaces a `runs-on` edge, record a cheap timestamped churn event instead of an observation. Deterministic thresholds raise one aggregated **medium** observation when the distribution goes wrong: same workload rescheduled ≥N times in a window, or one node repeatedly shedding its workload set. Cause-agnostic — catches flapping nodes, taint fights, disruption-budget loops, and future non-k8s churn.
- Precedent: the Sprint 18 alert flap-fold, applied to placement. Principle: **keep counting what you stop reporting.** All deterministic, zero AI cost (Obs Loop philosophy, ADR 0030).

**3. Clean up:** resolve the existing 528 drift observations, and ensure stale placement edges don't linger unconfirmed in the graph re-raising them.

Thresholds admin-visible where natural; severities per the canonical ladder (flap observations medium — they should be able to auto-open incidents if the threshold policy says so). ADR 0030 gets a note; record the "drift watches durable knowledge / placement churn is discovery's job, counted not reported" principle in the ISE Canon (standing instruction).