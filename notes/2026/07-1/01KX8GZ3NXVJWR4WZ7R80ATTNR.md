---
id: 01KX8GZ3NXVJWR4WZ7R80ATTNR
created: 2026-07-11T12:03:21.917753997Z
updated: 2026-07-21T17:43:45.783808Z
type: task
title: Phase 2 exit test — both systems syncing, real state visible within one interval
project: 01KX671DATY39VW6GWK3M2T3DN
number: 30
sprint: sdm5e08
blocked_by:
- 01KX8GXZTQ87K6WG9G3SMPMBNP
- 01KX8GY6M1X4GGM2VAHG31WWNH
- 01KX8GYJEGGCPKKA5YR89BTCT6
- 01KX8GYTJ0VJBXAABNQQBP88QT
comments:
- id: 01KXAJZHQPWCHMGFC63VJS53Z3
  author: Steve Vine
  at: 2026-07-12T07:17:02.326597044Z
  text: |-
    EXIT TEST PASSED on staging (https://ise.citops.net) — Phase 2 (State Sync) COMPLETE. No code PR; this is the acceptance verification (as Phase 1/ISE-19).

    Backend pipeline proven live from the ise-worker logs on g5:
    (1) BOTH systems syncing on schedule — DataDog (d2bfb8d2…) and Kubernetes (9dd4045f…) each status:ok every ~120s; beat dispatch_syncs every 30s, per-system interval gates it.
    (2) DataDog leg — 13 monitors in No-Data (real signals: NotificationBot Service Unavailable, [Strategic] Status of APP GW…, etc.) → 13 findings → promoted issues. No Alert-state monitor currently; Steve accepted No-Data as the signal (no test monitors created in the real MP org).
    (3) Kubernetes leg — injected an isolated crash-loop pod (ns ise-acceptance, busybox exit 1). Full pipeline within one interval:
       07:04:22 findings:0 → 07:05:52 findings:1, issues_promoted.created:1 → 07:07:22 findings:1, created:0 (idempotent, no dup).
    (4) Auto-resolve — deleted the namespace: 07:13:52 findings:2, reopened:1 (pod flap surfaced CrashLoopBackOff + its BackOff Warning event, and a recurrence reopened one), then 07:14:52 findings:0, resolved:2 (both promoted issues auto-resolved). Demonstrates ISE-22 finding auto-resolve + ISE-26 issue create/reopen/resolve lifecycle end-to-end.

    UI legs confirmed by Steve via Entra login: Overview shows both system cards syncing with recent timestamps + finding counts; System detail shows the k8s crash-loop finding + DataDog monitor findings with browsable state slices; Issues queue shows the promoted issues (source=finding-promoted), filterable, with evidence panel + lifecycle controls.

    Cleanup: ise-acceptance namespace deleted; g5 k8s system back to 0 findings. Cluster mutations (apply/delete) were run by Steve via the session shell (auto-mode correctly blocks shared-cluster writes); all verification was read-only via g5 admin kubeconfig logs + DataDog read-only API.

    Repro fixture (crash-loop pod):
    ---
    apiVersion: v1
    kind: Namespace
    metadata: {name: ise-acceptance, labels: {purpose: ise-phase2-exit-test}}
    ---
    apiVersion: v1
    kind: Pod
    metadata: {name: crashloop-demo, namespace: ise-acceptance, labels: {purpose: ise-phase2-exit-test}}
    spec:
      restartPolicy: Always
      containers:
      - {name: crash, image: busybox:1.36, command: ["sh","-c","echo crash; sleep 3; exit 1"]}

    Sprint 3 (Phase 2 — State Sync): 12/12 DONE. Roadmap Phase 2 complete: both estates syncing, real state + findings + issues visible in ISE within one interval.
assignee: steve
priority: medium
task_status: done
---
Roadmap Phase 2 exit test: DataDog and Kubernetes both syncing on schedule; a firing DataDog monitor and a crash-looping staging pod both appear in ISE (Overview/System detail/Issues) within one sync interval. On staging.