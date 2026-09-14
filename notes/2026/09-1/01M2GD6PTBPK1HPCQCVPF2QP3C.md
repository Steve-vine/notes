---
id: 01M2GD6PTBPK1HPCQCVPF2QP3C
created: 2026-09-14T16:50:01.163226Z
updated: 2026-09-14T16:55:08.8874Z
type: task
title: 'ADR 0073 — Compass installs on any Kubernetes: the chart requires no operator, and how a secret arrives is the operator''s business'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 707
sprint: stek6vx
assignee: steve
label:
- chore
priority: high
task_status: done
---
Scoped with Steve 2026-09-14, while preparing the first production install. Write it down before any chart change lands — this ADR gates the rest of the sprint.

**What the production install turned up**

- `templates/externalsecret.yaml` emits `external-secrets.io/v1beta1`; the production cluster runs ESO 2.2.0, which serves only `v1`. The install would have failed at apply. It rotted unnoticed because staging uses `secrets.external: false`, so that template has never been rendered against a live cluster (see COM-655 — a chart-only PR is gated by nothing).
- `values-production.yaml` names a ClusterSecretStore `aws-secrets`; the cluster's is `clustersecretstore`.
- The cluster has four StorageClasses and no default, so `storageClass: ""` leaves volumes Pending.

**The principle**: the chart declares what Compass needs, not how the operator should provide it. Compass needs a Secret with a database URL in it; whether ESO, Vault, Sealed Secrets, SOPS or `kubectl create secret` produced it is not the chart's business.

**The rule that makes it enforceable**: the chart renders no CRD-typed resource. Every object is core Kubernetes. This is ADR 0008's existing "no CRDs bundled in the chart" rule applied without exception — the ExternalSecret template was always in breach.

**Ten sections**: the prerequisite list with no operator on it; one Service, with surfacing left to the operator; two secrets (`DATABASE_URL`, `SESSION_SECRET_KEY`) with bring-your-own as the primary mode; chart-generated values and the `lookup` trap; Postgres external with an optional bundled evaluation database; Valkey unchanged plus the Redis-Cluster-mode constraint; attachments to an object store or a shared filesystem; HTTPS recommended not required; a bootstrap admin; multi-arch images.

Decided against rendering a CNPG `Cluster` CR (Steve, 2026-09-14): it is CRD-typed so it fails on any cluster without the operator, it does not help the minikube user who has no operator either, and its values surface would become a poor copy of CNPG's own API while still falling short of what `env-production-uk-pri` needs.

**Acceptance**: `decisions/0073-compass-installs-on-any-kubernetes.md` merged to main, status Accepted.