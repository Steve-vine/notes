---
id: 01M25D91B69CGFRQRA7W74AJPF
created: 2026-09-10T10:19:38.726338Z
updated: 2026-09-10T10:19:43.262344Z
type: task
title: The production cluster has what the chart assumes — checked, and installed where missing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 653
sprint: stek6vx
blocked_by:
- 01M25AQENFPYCYAD0ZKRMVXN37
assignee: steve
label:
- chore
priority: high
task_status: todo
---
Before Compass can be installed on `env-production-uk-pri` (EKS, eu-west-2, kubeconfig `~/.kube/env-production-uk-pri.yaml`, auth via `aws eks get-token` — needs an AWS login on the machine running it), every prerequisite the chart assumes (chart/README.md → *Cluster prerequisites*) is checked and the gaps are closed.

**Read-only survey first**, written up as a comment on this task before anything is installed:

- Kubernetes version (chart says `>=1.28`), node architecture (release images are **amd64 only**, ADR 0037 — an arm64/Graviton node group means the build has to change), node count / capacity for 3 API + 3 worker replicas.
- Ingress: which controller (the chart's overlays assume Traefik and `IngressClass traefik`; EKS is more likely AWS Load Balancer Controller / ALB, or nginx). The chart takes `ingress.className` and annotations from values, so this is a values decision, not a template change (ADR 0008).
- cert-manager present? A `ClusterIssuer` usable for the production hostname (DNS-01 via Route 53 / Cloudflare, or HTTP-01)? Or does TLS terminate at an ALB with an ACM cert, making the chart's `tls.certificate.create` unnecessary?
- **CNPG operator** (namespace `cnpg` by convention) — required, ADR 0005. If absent, install it; then a production `Cluster` (storage class, size, backups to S3, instances ≥2) from a production variant of `scripts/infra/postgres-cluster.yaml`.
- **ExternalSecrets Operator** + a `ClusterSecretStore` (`values-prod.yaml` expects `aws-secrets` backed by Secrets Manager, keys `compass/prod/*`). IRSA for the ESO service account.
- **S3 bucket** for attachments (`config.s3.bucket`, region) and credentials/IRSA for the API pod.
- Valkey: bundled (needs a storage class for its PVC) or ElastiCache.
- Outbound: SMTP relay for mail (ADR 0055 — production is not mailpit), OTel collector if `config.otel.enabled` stays true.
- DNS: the production hostname(s) and who owns the zone; whether the vendor portal host is wanted at launch.
- Egress from the nodes to ghcr.io (public pull, no secret) — confirm no proxy/allow-list blocks it.
- Who deploys: this machine by hand for the first install (ADR 0071 §7 leaves it open); a CI path from g5 runners to EKS would need an AWS role for the runner SA and is a later decision.

**Then**: install what is missing, in the order operators → Postgres cluster → secret store + secrets → bucket. Record each thing installed (chart, version, values file) under `scripts/infra/production/` so it is reproducible, and update `chart/README.md` prerequisites if the list changes.

**Not this task**: the Compass install itself, the production values file, and the written release-and-deploy procedure — those are the next two tasks in the sprint.

**Acceptance**: the survey comment exists with an answer for every bullet; every "required" prerequisite is present and healthy (`kubectl get pods -n cnpg`, `-n external-secrets`, `-n cert-manager` or equivalents all Running); the CNPG `Cluster` is `Cluster in healthy state`; the `ClusterSecretStore` is `Ready`.