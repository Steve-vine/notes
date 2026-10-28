---
id: 01M60VQP75YA3DKT2T0RR4PDHZ
created: 2026-10-28T08:58:54.053289Z
updated: 2026-10-28T08:59:01.85197Z
type: task
title: The web server is given time to start — a busy host no longer has it restarted before it has finished loading
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1390
sprint: ssp4evc
assignee: steve
label:
- bug
priority: high
task_status: active
---
Sprint 92, Vulnerabilities - Scanner sources. Found deploying COM-1389 to staging on 2026-10-28.

## What's wrong

The staging deploy of 408b9c70 failed: the new web server was restarted over and over and never came up, while the old one kept serving. Starting the web server takes about 35 seconds of processor time, and staging gives it half a core. Kubernetes restarts it if it hasn't answered within about 60 seconds. On a busy host it never gets there. It has grown closer to that limit with every module.

## What changes

- The web server gets up to 5 minutes to start. Once it's up, the health check is as quick to restart a stuck one as before.
- This applies everywhere the chart is used, production included.

## Notes (technical)

A `startupProbe` on `/healthz` for the API container: `api.probes.startup`, `periodSeconds` 10, `failureThreshold` 30, `timeoutSeconds` 3. Liveness and readiness keep their values; Kubernetes holds them off until the startup probe passes. The pod spec's probes are not immutable fields, so there is no upgrade concern.

**Chain:** independent (chart only).

**Done when:** the staging deploy rolls the API out on a busy host.