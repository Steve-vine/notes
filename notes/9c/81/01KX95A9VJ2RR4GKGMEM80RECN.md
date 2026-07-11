---
id: 01KX95A9VJ2RR4GKGMEM80RECN
created: 2026-07-11T17:59:00.210485815Z
updated: 2026-07-11T20:14:00.166796857Z
type: task
title: CI — retry the staging deploy smoke check
priority: high
task_status: review
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 34
comments:
- id: 01KX99RVE5FJ976460A0YRP6TA
  author: Steve Vine
  at: 2026-07-11T19:16:51.26972786Z
  text: 3rd consecutive occurrence on the ISE-29 staging deploy (after ISE-27, ISE-26) — same curl (7) TCP-connect timeout to ise-api:8000; Helm upgrade + rollout succeeded and pods verified 1/1 healthy each time. It's now reddening essentially every staging deploy, which erodes the signal from that job — bumping priority to high. Worth doing before Sprint 3 closes.
---
The `deploy-staging` job's "Smoke check" step curls the in-cluster ise-api service once and has intermittently failed with `curl: (7) Failed to connect to ise-api.ise.svc.cluster.local:8000 after ~71s: Couldn't connect to server` — a transient TCP-connect flake between the ARC runner and the ClusterIP service. Observed on the ISE-27 and ISE-26 staging deploys; both times Helm upgrade + Rollout status succeeded and pods were verified healthy, so it's the smoke curl, not the app.

Fix: wrap the smoke curl in a bounded retry loop (e.g. ~5 attempts with a short backoff) before failing, same class of hardening as the ISE-20 append-only-check DNS retry. Keep the overall step timeout sane. Reference the CI pattern in CLAUDE.md / Compass ci.md.

Note: staging deploys are allowed to go red (per CLAUDE.md), so this is quality-of-life to stop false reds, not a release blocker.