---
id: 01M60VQP75YA3DKT2T0RR4PDHZ
created: 2026-10-28T08:58:54.053289Z
updated: 2026-10-28T18:16:56.168297Z
type: task
title: The web server is given time to start — a busy host no longer has it restarted before it has finished loading
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1390
sprint: ssp4evc
comments:
- id: 01M60WQ900EEB62W2A2VTF3R8V
  author: Steve Vine
  at: 2026-10-28T09:16:09.087811Z
  text: |-
    Fixed — PR #1403, merged to main (084af128). Chart only; it applies to production too.

    - The web server now has up to 5 minutes to start before Kubernetes may restart it. Once it's running, a stuck one is restarted as quickly as before.
    - Checked with Helm 3 and Helm 4 against the staging and test value sets. Setting it to null turns it off.

    On staging since 09:15 GMT. The deploy rolled out cleanly with the host still busy (load ~50 from sprint 93's builds): API Running with 0 restarts, 522Mi.
assignee: steve
label:
- bug
priority: high
task_status: done
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