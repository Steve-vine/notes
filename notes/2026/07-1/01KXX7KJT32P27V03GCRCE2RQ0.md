---
id: 01KXX7KJT32P27V03GCRCE2RQ0
created: 2026-07-19T13:03:50.083645868Z
updated: 2026-07-21T09:53:46.74439Z
type: task
title: Kubernetes observation detectors → the Observations screen
project: 01KX671DATY39VW6GWK3M2T3DN
number: 140
sprint: srmqjcq
blocked_by:
- 01KXX7KDMJK1YACXH6N4JZYM7D
comments:
- id: 01KXXTEDNCBSSHRRAH090GYCZD
  author: Steve Vine
  at: 2026-07-19T18:33:03.916227737Z
  text: |-
    Done. Kubernetes is now an Observations source. PR #126 → main (stacked on #125; CI all green). Merged to staging (f1ea83c). Moved to Review.

    capabilities() declares observations not alerts; detection moved to detect_observations() with fixed per-detector confidence (crashloop 0.95, OOM 0.9, unhealthy workload 0.8, node not-ready 0.9/pressure 0.8, pending 0.6, failing probe 0.65, failed scheduling 0.7); obs/-namespaced keys; each resolves to its estate entity; severe+confident auto-open Incidents. Cert-expiry deferred (no secret RBAC — documented). Observations screen (Confidence column already present) lights up automatically. Backend 614 passed.
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 14 (vertical slice: backend + UI).** Make Kubernetes an Observations source, for real.

- **Backend**: reclassify Kubernetes detection from Alerts to **Observations** with a confidence axis (ADR 0027 named this as Sprint 14 work), and add detectors: **CrashLoopBackOff, OOMKill, pending pods, failing probes, cert expiry, resource saturation**. Each resolves to its estate entity (ISE-128) and opens an Incident past the global confidence bar (ADR 0026).
- **UI**: these light up the existing **Observations** screen (the Confidence column is already there), link to the entity in **Estate**, and — when severe + confident — appear as Incidents.

**DoD**: a crash-looping workload appears as an Observation with a confidence score on the Observations screen, joined to its entity, and opens an Incident if it clears the bar. Not done until real detectors populate the screen.

Depends on the scheduler.