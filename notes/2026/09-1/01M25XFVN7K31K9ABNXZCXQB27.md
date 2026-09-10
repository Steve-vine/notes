---
id: 01M25XFVN7K31K9ABNXZCXQB27
created: 2026-09-10T15:02:59.495308Z
updated: 2026-09-10T15:03:41.380735Z
type: task
title: Compass is installed in production from release 0.1.0
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 660
sprint: stek6vx
assignee: steve
label:
- feature
priority: high
task_status: todo
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