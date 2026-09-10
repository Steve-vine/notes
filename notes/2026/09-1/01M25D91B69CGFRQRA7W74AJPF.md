---
id: 01M25D91B69CGFRQRA7W74AJPF
created: 2026-09-10T10:19:38.726338Z
updated: 2026-09-10T14:50:55.049415Z
type: task
title: The production cluster has what the chart assumes — checked, and installed where missing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 653
sprint: stek6vx
blocked_by:
- 01M25AQENFPYCYAD0ZKRMVXN37
comments:
- id: 01M25WSR69RF9FYEQVWJDJP3XR
  author: Steve Vine
  at: 2026-09-10T14:50:55.049291Z
  text: |-
    **Survey part 1 — from the AWS API only (2026-09-10 11:20).** The cluster API is not reachable from this machine yet: the public endpoint is CIDR-allowlisted (13.40.89.148/32, 194.73.43.192/28, 13.134.4.186/32, 217.9.204.16/28 — our IP 31.126.21.116 is not in it) and the private endpoint needs Twingate, which is installed but not running (`twingate status` → not-running; starting it needs sudo + browser auth).

    - **Credentials**: `AWS_PROFILE=production` → IAM user `svc-crossplane-build` (account 826764636751). Has an EKS access entry with `AmazonEKSClusterAdminPolicy`, cluster scope — full admin once the network path exists. Other entries: the SSO AdministratorAccess role, the node role, the EKS service role.
    - **Cluster** `cluster-envproductionukpri-ekscluster`: ACTIVE, Kubernetes **1.35** (eks.21), auth mode API_AND_CONFIG_MAP, OIDC issuer present and an IAM OIDC provider exists → IRSA works. Chart's `>=1.28` is fine.
    - **Nodes**: one managed node group, **2 × m7i.xlarge (x86_64, AL2023), on-demand, min=max=2**. amd64 — our images are fine. 8 vCPU / 32 GiB total; Compass prod requests (3 API × 200m/512Mi, 3 workers × 200m/512Mi, beat, frontend ×3, Valkey) ≈ 1.5 vCPU / 3.5 GiB — fits, but the node group cannot scale; check headroom against what already runs there (needs cluster access).
    - **Addons**: vpc-cni, aws-ebs-csi-driver, aws-efs-csi-driver → EBS storage class for CNPG and Valkey PVCs is available.
    - **Ingress**: **Traefik is already the ingress controller** — an NLB tagged `kubernetes.io/service-name traefik/cluster-envproductionukpri-rel-traefik`. Both load balancers are **internal** NLBs, so Compass would be reachable only from inside the network / via Twingate, like everything else on this cluster. `ingress.className: traefik` in values-prod stands.
    - **DNS**: Route 53 hosted zones `moneypenny.uk`, `moneypenny.us`, `moneypenny.ai` — all **private** zones. A hostname like `compass.moneypenny.uk` would resolve only inside; consistent with the internal NLBs. cert-manager/ClusterIssuer status needs cluster access; a DNS-01 issuer would need a public zone (Cloudflare `citops.net` as on staging, or a public Route 53 zone) — no ACM certificates exist in eu-west-2, so TLS is not terminating at an AWS LB today.
    - **S3**: no Compass bucket; existing buckets are `mp-envproductionpri-chinwag-prod-atlasfed` and an Argo artifacts bucket. `compass-attachments` (or an `mp-envproductionpri-compass-*` name to match convention) needs creating, plus an IRSA role or keys for the API pod.
    - **Secrets Manager**: no `compass/*` secrets yet. ESO presence needs cluster access.
    - **Managed data**: RDS has only MariaDB (kora); no Postgres → CNPG in-cluster per ADR 0005. ElastiCache not listable with this user (AccessDenied) — assume bundled Valkey.
    - **IAM user scope**: `svc-crossplane-build` can read EKS/EC2/ELB/Route53/S3/RDS/Secrets Manager/ACM/IAM-OIDC, not ElastiCache. Creating buckets/secrets/IAM roles may need the SSO admin role instead — check before the install step.

    **Blocked on**: Twingate connected on this machine (Steve: `sudo twingate start`), then part 2 — operators (CNPG, cert-manager, ESO), storage classes, Traefik IngressClass name, existing namespaces/workloads and headroom.
assignee: steve
label:
- chore
priority: high
task_status: active
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