---
id: 01M25XFVN7K31K9ABNXZCXQB27
created: 2026-09-10T15:02:59.495308Z
updated: 2026-09-14T20:58:27.270412Z
type: task
title: Compass is installed in production from release 0.1.0
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 660
sprint: stek6vx
blocked_by:
- 01M25D91B69CGFRQRA7W74AJPF
- 01M2GDMSMHN86CY7DTARVT6CKM
comments:
- id: 01M25Y7NGDBYV14Z48TY69FPSH
  author: Steve Vine
  at: 2026-09-10T15:15:59.629684Z
  text: 'Change of plan 2026-09-10: Twingate cannot run on the dev box, so **Steve installs the chart himself** from a machine with cluster access. Claude''s part shrinks to: the release (v0.1.0 tagged from staging f1c0a7c), the production values file and the checked-in production infra manifests (CNPG Cluster, ExternalSecret-backed values, IRSA role + bucket via the AWS CLI — the `production` profile may create them), and the runbook. Step 5''s `helm upgrade --install` line is what Steve runs; Steve also flips the three GHCR packages public after the release.'
- id: 01M264MG1K22NZ0RNFJ6N9R79Y
  author: Steve Vine
  at: 2026-09-10T17:07:51.475596Z
  text: 'Step 4 done: **Compass 0.1.0 is released** (https://github.com/Steve-vine/compass/releases/tag/v0.1.0) from f1a8822 — images `ghcr.io/steve-vine/compass/{backend,frontend}:0.1.0`, chart `oci://ghcr.io/steve-vine/compass/charts/compass --version 0.1.0`. The three packages were created private; Steve flips them to public (github.com/Steve-vine?tab=packages → each package → settings → visibility), then verify off-LAN: `helm show chart oci://ghcr.io/steve-vine/compass/charts/compass --version 0.1.0`. Remaining for Claude: `chart/values-production.yaml` and `scripts/infra/production/` (CNPG Cluster, ESO-backed secrets, IRSA role + bucket), and the runbook; Steve runs the install.'
- id: 01M269WXSJ6WD885T0YC4AC6VS
  author: Steve Vine
  at: 2026-09-10T18:39:50.577952Z
  text: 'Packages flipped public by Steve 2026-09-10 ~17:10. Verified anonymously from the dev box: `ghcr.io/steve-vine/compass/backend:0.1.0` = sha256:0ffda759…, `frontend:0.1.0` = sha256:655d5b31… (both equal to zot''s `:f1a8822`), `backend:f1a8822` resolves, and `helm show chart oci://ghcr.io/steve-vine/compass/charts/compass --version 0.1.0` returns name compass / version 0.1.0 / appVersion 0.1.0 with no login. Now drafting values-production.yaml + scripts/infra/production/ + runbook.'
- id: 01M26A6NXJ2B8EZ8AEVKFDVJ4J
  author: Steve Vine
  at: 2026-09-10T18:45:10.193927Z
  text: 'PR #671 open: https://github.com/Steve-vine/compass/pull/671 — `chart/values-production.yaml` (renamed from values-prod), `scripts/infra/production/{README.md,postgres-cluster.yaml,aws/setup.sh}`. Three names marked CONFIRM against the cluster (ClusterIssuer, ClusterSecretStore, StorageClass). setup.sh not yet run — waiting on Steve for the bucket name / Postgres size and a go, since it creates resources in the production AWS account.'
- id: 01M26AAF5Z30KQK75V4VP6EFFE
  author: Steve Vine
  at: 2026-09-10T18:47:14.36752Z
  text: 'Steve''s decisions 2026-09-10: he runs `scripts/infra/production/aws/setup.sh` himself (defaults: bucket mp-envproductionpri-compass-attachments, role compass-prod-app, secrets compass/prod/*, CNAME to the Traefik NLB); Postgres **50 GiB** per instance (PR #671 updated). Remaining on Steve: confirm the three CONFIRM names against the cluster, setup.sh, the runbook steps 2–4. Nothing further for Claude on this task unless the install turns something up.'
- id: 01M2GVDKJ6C0GD71X3R78JY4KW
  author: Steve Vine
  at: 2026-09-14T20:58:27.270152Z
  text: |-
    2026-09-14 evening: the whole ADR 0073 set (COM-655, 708–715) is merged and running on staging as fee573c (staging-20260914-2055). Unblocked from the chart side. What the install now looks like, once 0.2.0 is cut from that commit:

    1. `AWS_PROFILE=production scripts/infra/production/aws/setup.sh` — now creates three secrets (db_credentials, database_url, session_secret_key); the three Valkey URLs are derived by the chart.
    2. `kubectl create namespace compass`; `kubectl apply -n compass -f scripts/infra/production/external-secret.yaml` (new — produces `compass-secrets` with DATABASE_URL + SESSION_SECRET_KEY, ESO v1, store `clustersecretstore`); `kubectl apply -n compass -f scripts/infra/production/postgres-cluster.yaml` (same store, StorageClass named); wait for both ExternalSecrets and the CNPG cluster.
    3. `helm upgrade --install compass oci://ghcr.io/steve-vine/compass/charts/compass --version 0.2.0 -f chart/values-production.yaml -n compass --set image.tag=0.2.0 --set frontend.image.tag=0.2.0 --timeout 10m` — values-production.yaml now: `secrets.existingSecret: compass-secrets`, the cluster-issuer ingress annotation, `valkey.storage.storageClass: ebs-envproductionukpri-storageclass-ebs`.
    4. First admin: either the runbook's kubectl exec, or add BOOTSTRAP_ADMIN_EMAIL/BOOTSTRAP_ADMIN_PASSWORD to the Secret and `--set bootstrap.admin.enabled=true --set bootstrap.admin.email=…` (post-install only).

    Still to do before this task can start: Steve smoke-tests staging, tags v0.2.0 on fee573c (the release now refuses a single-arch index — the fee573c images are amd64+arm64 in zot).
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**Reopened 2026-09-14.** This was closed on 2026-09-10 when the preparatory work finished, but its acceptance criteria were never met: **nothing is installed**. Checked against AWS and the cluster on 2026-09-14 — no attachments bucket, no `compass-prod-app` IAM role, no `compass/prod/*` secrets, no `compass` namespace, no Helm release. The runbook, values file and infra manifests exist; the install itself has not happened.

**And it could not have succeeded as written.** Checking the chart against the cluster found three blockers, now covered by ADR 0073:

- `templates/externalsecret.yaml` emits `external-secrets.io/v1beta1`; the cluster runs **ESO 2.2.0, which serves only `v1`**. `helm install` fails at apply. Fixed by COM-708.
- The ClusterSecretStore is named **`clustersecretstore`**, not `aws-secrets`, in both `values-production.yaml` and `postgres-cluster.yaml`. Fixed by COM-708.
- The cluster has **four StorageClasses and no default**, so `storageClass: ""` leaves Valkey's and Postgres's volumes Pending. Fixed by COM-708.

**Blocked by COM-708.** Nothing else in the ADR 0073 set is on the critical path.

**Confirmed present on the cluster 2026-09-14** (so COM-653's checks still hold): ClusterIssuer `letsencrypt-prod`, solving DNS-01 via Cloudflare; CNPG operator; cert-manager 1.20.1; the Traefik NLB hostname in `setup.sh` matches the live Service; the private `moneypenny.uk` zone is `Z03740323B5N0L4CHYPCY`; the ESO controller's IAM role can read `compass/prod/*`. GHCR packages are public and 0.1.0 pulls anonymously. The `production` AWS profile has admin via SSO.

**Version to install.** Release 0.1.0 (2026-09-10, commit f1a8822) is 43 commits behind — it predates the whole Inventory module. `staging` and `main` are both at 387e648, so a new release passes the ADR 0071 guard. Decide at install time whether to ship 0.1.0 or cut the next version first; the chart changes from COM-708 need a release either way, so in practice this becomes a new version.

**Remaining steps** (the original list, still correct):

1. `AWS_PROFILE=production scripts/infra/production/aws/setup.sh` — bucket, IRSA role, six secrets, the private-zone CNAME. Idempotent; never rotates an existing secret.
2. `kubectl create namespace compass`; apply the ExternalSecret (new, from COM-708) and `postgres-cluster.yaml`; wait for the CNPG cluster to report healthy.
3. `helm upgrade --install` from the published chart at the release version, both image tags pinned to it.
4. First administrator, then Admin → Email for the SendGrid transport (ADR 0044).
5. Smoke: `/readyz` in-cluster, then `https://compass.moneypenny.uk` over Twingate.

**Acceptance**: `helm list -n compass` shows `compass` deployed at the release version; all pods Ready; the app serves over TLS from inside the network; an attachment uploads to S3; the first admin can sign in.