---
id: 01KY7KQ2GKNBE1C5W5CVQV91CT
created: 2026-07-23T13:47:51.699967Z
updated: 2026-07-23T13:47:54.592513Z
type: task
title: 'Helm: optional Twingate sidecar for integration connectivity'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 230
sprint: skiru9m
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Upcoming integrations (starting with Kubernetes clusters) need the ISE pods that connect out to resources to be routed via Twingate. The established pattern (used in another of Steve's apps) is a Twingate client **sidecar container** in the pod, plus a **secret mounted as a volume** into that sidecar.

## Scope

Update the Helm chart (`helm/`) so the sidecar can be switched on via values:

- Add a `twingate` block to `values.yaml`, e.g.:
  - `twingate.enabled: false` (default off — current deploys unchanged)
  - `twingate.secretName: ""` — name of the pre-existing Twingate secret
- When enabled, render the Twingate client sidecar container into the pod spec(s) and mount the referenced secret as a volume, following Steve's reference example from the other app (to be pasted into this task / provided during implementation).
- The secret itself is created manually by Steve — the chart only references it by name (do not template the secret contents).

## Which pods

The sidecar belongs on the pods that make outbound connections to integrated systems — the Celery **worker** at minimum; confirm during implementation whether **api** (interactive evidence/chat calls) and **beat** need it too.

## Acceptance

- `twingate.enabled: false` (default): rendered manifests identical to today.
- `twingate.enabled: true` + `twingate.secretName` set: sidecar container present with the secret volume mounted; `helm template` renders cleanly for both values files.