---
id: 01KXX7KJT32P27V03GCRCE2RQ0
created: 2026-07-19T13:03:50.083645868Z
updated: 2026-07-19T13:25:17.356216851Z
type: task
title: Kubernetes observation detectors → the Observations screen
label:
- feature
assignee: steve
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 140
blocked_by:
- 01KXX7KDMJK1YACXH6N4JZYM7D
sprint: srmqjcq
---
**Sprint 14 (vertical slice: backend + UI).** Make Kubernetes an Observations source, for real.

- **Backend**: reclassify Kubernetes detection from Alerts to **Observations** with a confidence axis (ADR 0027 named this as Sprint 14 work), and add detectors: **CrashLoopBackOff, OOMKill, pending pods, failing probes, cert expiry, resource saturation**. Each resolves to its estate entity (ISE-128) and opens an Incident past the global confidence bar (ADR 0026).
- **UI**: these light up the existing **Observations** screen (the Confidence column is already there), link to the entity in **Estate**, and — when severe + confident — appear as Incidents.

**DoD**: a crash-looping workload appears as an Observation with a confidence score on the Observations screen, joined to its entity, and opens an Incident if it clears the bar. Not done until real detectors populate the screen.

Depends on the scheduler.