---
id: 01KY7KQ2GKNBE1C5W5CVQV91CT
created: 2026-07-23T13:47:51.699967Z
updated: 2026-07-24T14:43:10.481015Z
type: task
title: 'Helm: optional Twingate sidecar for integration connectivity'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 230
sprint: skiru9m
comments:
- id: 01KY7PE0NR7T6FBPX7R68E770J
  author: Steve Vine
  at: 2026-07-23T14:35:20.631983Z
  text: |-
    Done — PR #212 (feature/ise-230-twingate-sidecar → main).

    - twingate block in values.yaml: enabled (default false), secretName (operator-managed, referenced by name only), pinned image twingate/client:1.0.4 (ADR 0008), per-pod pods.{api,worker,beat} toggles, sidecar resources.
    - Which pods: worker (outbound sync/ai/actions connector tasks) + api (interactive evidence/chat) get the sidecar by default; beat only schedules, so off. All are opt-in-configurable.
    - Sidecar + volumes live once in _helpers.tpl and are included per deployment, gated on twingate.enabled at each call site. Sidecar has its own elevated securityContext (privileged/root/NET_ADMIN); app containers unchanged.
    - secretName is `required` when enabled → misconfig fails helm template loudly.

    Verified:
    - Default/disabled render is byte-for-byte identical to main (full helm template diff under values-staging).
    - Enabled render puts sidecar + tun-device hostPath + service-key secret volume on worker and api (2), not beat.
    - Enabling without secretName fails loudly; both values files render as valid YAML; helm lint clean.

    Headless infra (chart only) — no user-facing surface. Now that both ISE-229 and ISE-230 are in Review, releasing both to the staging cluster.
- id: 01KY7X7ZNNF6RFR1NP81Q4S5HS
  author: Steve Vine
  at: 2026-07-23T16:34:23.029789Z
  text: 'RELEASED to main 2026-07-23. PR #212 merged (532855a). Main CI green — secret-scan, api-types, backend, frontend, build-images all passed. Sidecar stays default-off, so the production render is unchanged until an operator sets twingate.enabled + creates the service-key secret. Staging reset to main; merged branch deleted.'
assignee: steve
label: null
priority: medium
task_status: done
---
Upcoming integrations (starting with Kubernetes clusters) need the ISE pods that connect out to resources to be routed via Twingate. The established pattern (used in another of Steve's apps — reference example below) is a Twingate client **sidecar container** in the pod, plus a **secret mounted as a volume** into that sidecar.

## Scope

Update the Helm chart (`helm/`) so the sidecar can be switched on via values:

- Add a `twingate` block to `values.yaml`, e.g.:
  - `twingate.enabled: false` (default off — current deploys unchanged)
  - `twingate.secretName: ""` — name of the pre-existing Twingate service-key secret
  - `twingate.image` — pinned client image tag (ADR 0008 forbids `latest`; the reference app uses `twingate/client:latest`, ISE must pin a specific tag)
- When enabled, render into the pod spec(s):
  - a `tun-device` hostPath volume (`/dev/net/tun`, type `CharDevice`)
  - a secret volume from `twingate.secretName`
  - the Twingate client sidecar container mounting both (service key at `/etc/twingate/service_key.json`, subPath `service-key`)
- The secret itself is created manually by Steve — the chart only references it by name (do not template the secret contents).
- The sidecar needs its own securityContext (privileged, root, `NET_ADMIN`) — it cannot inherit ISE's restrictive `containerSecurityContext`. Keep the app containers' security context unchanged.

## Reference example (trimmed from the chinwag app)

```yaml
spec:
  volumes:
    - name: tun-device
      hostPath:
        path: /dev/net/tun
        type: CharDevice
    - name: twingate-service-key
      secret:
        secretName: creds-twingate   # ← from .Values.twingate.secretName
  containers:
    - name: twingate-sidecar
      image: twingate/client:latest  # ← pin via .Values.twingate.image (ADR 0008)
      securityContext:
        capabilities:
          add: [NET_ADMIN]
          drop: [ALL]
        privileged: true
        runAsGroup: 0
        runAsNonRoot: false
        runAsUser: 0
      volumeMounts:
        - mountPath: /dev/net/tun
          name: tun-device
        - mountPath: /etc/twingate/service_key.json
          name: twingate-service-key
          subPath: service-key
```

## Which pods

The sidecar belongs on the pods that make outbound connections to integrated systems — the Celery **worker** at minimum; confirm during implementation whether **api** (interactive evidence/chat calls) and **beat** need it too. Consider defining the sidecar + volumes once in `_helpers.tpl` and including it per-deployment.

## Acceptance

- `twingate.enabled: false` (default): rendered manifests identical to today.
- `twingate.enabled: true` + `twingate.secretName` set: sidecar container present with tun device + secret volume mounted; `helm template` renders cleanly for both values files.