---
id: 01M25XFVN7K31K9ABNXZCXQB27
created: 2026-09-10T15:02:59.495308Z
updated: 2026-09-10T18:47:48.33533Z
type: task
title: Compass is installed in production from release 0.1.0
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 660
sprint: stek6vx
blocked_by:
- 01M25D91B69CGFRQRA7W74AJPF
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
assignee: steve
label:
- feature
priority: high
task_status: review
---
Compass runs on `env-production-uk-pri` at **https://compass.moneypenny.uk** (internal, via Twingate like the rest of that cluster), installed from the published chart at the release version — never from a checkout (ADR 0071 §7).

**Decided 2026-09-10 with Steve**
- Hostname `compass.moneypenny.uk` — a record in the private Route 53 zone `moneypenny.uk`, pointing at the existing internal Traefik NLB (`traefik/cluster-envproductionukpri-rel-traefik`).
- Vendor Portal **on**, at `vendor-portal.moneypenny.uk`, reached through a Cloudflare Tunnel — that route is **COM-661** and blocks the portal going live, not the install: the employee app can be installed with `vendorPortal.ingress.enabled: false` and the portal switched on when the tunnel exists.
- Email: **SendGrid, configured by Steve after install**. At install `config.email` is left unset (mail logged, not sent); the SendGrid SMTP host/port go in values and the API key in Secrets Manager (`compass/prod/smtp_password`) when he has them.
- Cluster prerequisites confirmed present by Steve (COM-653): CNPG, cert-manager, ESO, Traefik, EBS storage.

**Steps**
1. `scripts/infra/production/` — checked-in, reproducible: the CNPG `Cluster` for production (2 instances, EBS `gp3`, size TBD, backups to S3 via barman — bucket in step 2), the `ExternalSecret`-backed values, the Route 53 record.
2. AWS: S3 bucket for attachments (`mp-envproductionpri-compass-attachments`, private, versioned) with an IRSA role for the API/import service account; Secrets Manager entries `compass/prod/{database_url, broker_url, result_backend_url, session_secret_key, session_redis_url, s3_access_key_id?, s3_secret_access_key?}` — prefer IRSA over static S3 keys (chart supports keys today; check whether `config.s3` can run keyless via the pod role, else add that). May need the SSO admin role rather than `svc-crossplane-build`.
3. `chart/values-production.yaml` (rename from `values-prod.yaml`) filled in: hostname, `ingress.className: traefik`, `tls.issuer` = the cluster's ClusterIssuer (name from the cluster), `secrets.eso.secretStoreRef` = the cluster's ClusterSecretStore, `config.appBaseUrl`, `config.vendorPortalBaseUrl: https://vendor-portal.moneypenny.uk` with the portal ingress off until COM-661, `otel.enabled` per what the cluster has, replicas as sized.
4. Cut **v0.1.0** from staging (Steve says when staging is tested) → GHCR packages exist → Steve flips the three packages public → verify anonymous `helm show chart` and `docker pull` from off-LAN.
5. First install, from this machine over Twingate: `kubectl create ns compass`, apply step 1, `helm upgrade --install compass oci://ghcr.io/steve-vine/compass/charts/compass --version 0.1.0 -f chart/values-production.yaml -n compass --set image.tag=0.1.0 --set frontend.image.tag=0.1.0`. Migration hook + import hook run inside it.
6. Smoke: `/readyz` in-cluster, `https://compass.moneypenny.uk` via Twingate, first admin login, Steve's UI smoke test.
7. `chart/README.md` → "Install from a release" points at the real values file; a `docs/` or README section "Production runbook" with the release-and-deploy procedure (the sprint's fourth item — fold in here unless it grows).

**Needs from Steve**: Twingate running on this machine (`sudo twingate start`); a go for v0.1.0; whether `svc-crossplane-build` may create the bucket/secrets/IAM role or the SSO admin role should be used; the CNPG storage size.

**Acceptance**: `helm list -n compass` shows `compass` at chart `0.1.0` app `0.1.0` deployed; all pods Ready; `https://compass.moneypenny.uk` serves the app over TLS from inside the network; attachments upload to S3; the runbook exists.