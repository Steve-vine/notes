---
id: 01KYERF0XN074106H1DY6D8JBZ
created: 2026-07-26T08:25:31.829377Z
updated: 2026-08-07T12:15:33.918125Z
type: task
title: Estate drift watches durable knowledge; placement churn is counted, not reported
project: 01KX671DATY39VW6GWK3M2T3DN
number: 301
sprint: svgrad3
comments:
- id: 01KYEXVWWKM8PD1KJH9ZQCRGFK
  author: Steve Vine
  at: 2026-07-26T09:59:56.562958Z
  text: |-
    Implemented — PR #269 (feature/ise-301-scope-estate-drift).

    Part 1 (scope drift to durable knowledge) + Part 3 (cleanup) DONE and verified on staging: is_edge_stale now only drifts depends-on/routes-to + human-asserted/confirmed edges; volatile runs-on/part-of excluded even when harvested. Re-ran the Obs Loop on the 3 drift-bearing systems → open estate_drift 266 → 0, 538 resolved via reconcile (drift_emitted=0 on every system). Every open finding had been runs-on (214)/part-of (52) — 100% placement churn, exactly as diagnosed.

    Part 2 (rate guards) DONE — with one deliberate simplification vs the plan, for the better:

    Key realisation: Kubernetes already aggregates repeats of a condition into ONE event's `count` over [first,last]_timestamp. So the rate is a point-in-time read — NO churn-event store and NO migration needed. Both guards stay read-only Obs-Loop detectors (ADR 0030).
    - node_flapping: a node STILL PRESENT whose NodeNotReady event count ≥ 3 within 30 min → one high Observation on the node. Catches a node that's Ready at sample time but bouncing (which point-in-time node_not_ready misses). Present-nodes-only scoping = Karpenter-safe: a node recycled once is gone, never read as a flap. This is the "faulty node flapping must not go unseen" requirement, caught at the fault's root.
    - Rate-aware placement churn: FailedScheduling/Unhealthy stays a medium note for a one-off but escalates to high at count ≥ 10 in-window — a pod thrashing the scheduler.

    Deviation: I did NOT build a standalone estate-layer pod-reschedule-rate guard. On a Karpenter estate consolidation reschedules pods across many workloads as normal operation, so a generic reschedule rate can't be made non-noisy without per-workload baselines — and its genuine fault cases (flapping node, unschedulable pod, crash loop) are already caught at root by the two guards above + existing detectors. Reporting the fault at its cause beats reporting the symptom across the estate, and it avoids re-introducing the very noise this task removed. Reasoning recorded in ADR 0030.

    Thresholds are shape-based (no staging churn baseline yet) — refine against telemetry. Both surface on the existing Signals/Observations screen (no new screen). Full backend suite + ruff + mypy strict green. Moving to review; staging deploy in flight for smoke test.
assignee: steve
label: null
priority: high
task_status: done
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