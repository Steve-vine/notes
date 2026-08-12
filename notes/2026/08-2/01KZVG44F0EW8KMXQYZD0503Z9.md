---
id: 01KZVG44F0EW8KMXQYZD0503Z9
created: 2026-08-12T17:25:35.840871Z
updated: 2026-08-12T17:25:35.840871Z
type: task
title: Cancel scan returns 500 — API pod calls K8s without configuration
assignee: steve
label:
- follow_up
- bug
priority: high
task_status: done
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 379
---
## Symptom

Clicking **Cancel scan** during a running scan returns HTTP 500 from `POST /api/v1/scans/{id}/cancel`. The scan does end up `CANCELLED` (the DB write succeeds before the failure), but the user sees the error toast `"Could not cancel scan"` from the Brief 017 wiring (or, pre-Brief-017, the inline danger banner).

Surfaced during minikube smoke-testing of Brief 017's toast wiring. Pre-Brief-017 the same 500 was happening but went large…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-175](https://linear.app/stevevine/issue/DEV-175/cancel-scan-returns-500-api-pod-calls-k8s-without-configuration)