---
id: 01M2GDMSMHN86CY7DTARVT6CKM
created: 2026-09-14T16:57:42.801847Z
updated: 2026-09-14T16:58:40.490053Z
type: task
title: The chart renders no CRD-typed resource — the ExternalSecret and the cert-manager Certificate go, and an existing Secret becomes the primary mode
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 708
sprint: stek6vx
assignee: steve
label:
- tech_debt
priority: urgent
task_status: todo
---
ADR 0073 §1 and §3. **This is the task that unblocks the production install** — today `helm install` with `values-production.yaml` fails at apply, because the ExternalSecret template emits `external-secrets.io/v1beta1` and ESO 2.2.0 on `env-production-uk-pri` serves only `v1`.

**Two templates are CRD-typed and both go**: `templates/externalsecret.yaml` and `templates/tls-certificate.yaml` (`cert-manager.io/v1 Certificate`). Neither operator is a prerequisite under §1, and a conditional CRD template is the same bug waiting to recur, not an exception to the rule.

**Steps**

1. Delete `templates/externalsecret.yaml`; remove `secrets.eso.*` from `values.yaml`.
2. Add `secrets.existingSecret` — the name of a Secret the operator produced however they like — and make it the documented primary mode. Keep the inline path (`secrets.create` + values) for dev, with the same warning it carries today.
3. Delete `templates/tls-certificate.yaml`; remove the `tls.*` block. TLS becomes an ingress annotation (`cert-manager.io/cluster-issuer: <issuer>`) via the existing `ingress.annotations`, which is a plain annotation on a core resource — cert-manager creates the Certificate itself, and anyone without cert-manager just names an existing `ingress.tls.secretName`.
4. Remove `M365_TENANT_ID` / `M365_CLIENT_ID` / `M365_CLIENT_SECRET` from the Secret templates and values (§3): all three integrations are admin-managed in-app with an env fallback, and the chart renders keys for M365 but not Entra or SSO, which serves no one. Add a generic `extraEnv` on the API and worker for the 12-factor case.
5. `chart/values-production.yaml`: drop the `eso` and `tls` blocks; add the `cert-manager.io/cluster-issuer: letsencrypt-prod` ingress annotation; set `valkey.storage.storageClass: ebs-envproductionukpri-storageclass-ebs` explicitly — **that cluster has four StorageClasses and no default**, so an empty value leaves the volume Pending with nothing explaining why.
6. `scripts/infra/production/external-secret.yaml` — new, `external-secrets.io/v1`, `secretStoreRef: clustersecretstore` (**not** `aws-secrets`, which does not exist on that cluster), reading `compass/prod/*`. Applied before the first install. Production's secrets still come from Secrets Manager; the chart simply stops knowing about it.
7. `scripts/infra/production/postgres-cluster.yaml`: same two corrections — store name, and an explicit `storageClass`.
8. `chart/README.md`: the prerequisites table loses ESO and cert-manager; the hard-rules list gains "renders no CRD-typed resource".

**Acceptance**: `helm template` with every overlay renders only core Kubernetes kinds (no `external-secrets.io`, no `cert-manager.io`); a fresh install works against a Secret created by hand with nothing but `DATABASE_URL` and `SESSION_SECRET_KEY`; `helm template -f values-production.yaml` renders clean.