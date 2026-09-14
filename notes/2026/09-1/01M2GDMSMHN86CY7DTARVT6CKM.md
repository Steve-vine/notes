---
id: 01M2GDMSMHN86CY7DTARVT6CKM
created: 2026-09-14T16:57:42.801847Z
updated: 2026-09-14T20:58:17.496867Z
type: task
title: The chart renders no CRD-typed resource — the ExternalSecret and the cert-manager Certificate go, and an existing Secret becomes the primary mode
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 708
sprint: stek6vx
comments:
- id: 01M2GR16PZXQCHCWJYXJM7K4ZK
  author: Steve Vine
  at: 2026-09-14T19:59:15.167716Z
  text: |-
    Merged to main 2026-09-14 19:39 as 45be8cb (PR #715). The chart renders only core kinds on every overlay (kubeconform strict clean); `secrets.existingSecret` is the primary mode; TLS is the `cert-manager.io/cluster-issuer` ingress annotation, each Ingress with its own TLS Secret (the vendor portal gets `compass-vendor-portal-tls`); M365 keys gone, `api.extraEnv`/`worker.extraEnv` added; values-production.yaml and scripts/infra/production/{external-secret.yaml (new, v1, store clustersecretstore), postgres-cluster.yaml} corrected, StorageClass `ebs-envproductionukpri-storageclass-ebs` named explicitly.

    Two-key acceptance ("a hand-made Secret with only DATABASE_URL and SESSION_SECRET_KEY") is met once COM-710 lands (derived Valkey URLs) — PR #718 in the stack. Staging impact on the next promotion: cert-manager re-issues compass-tls from the annotation and issues compass-vendor-portal-tls fresh; watch `kubectl -n compass get certificate`.
- id: 01M2GVDA0RNE0R4YYVGBG6RR5J
  author: Steve Vine
  at: 2026-09-14T20:58:17.496735Z
  text: 'Staging promoted 2026-09-14 20:55 (rev 171, staging-20260914-2055 = fee573c). One migration wrinkle, now resolved and worth knowing: cert-manager''s ingress-shim saw the new `cert-manager.io/cluster-issuer` annotation while the chart''s old `compass-tls` Certificate still existed, logged "refusing to update non-owned certificate resource", and Helm deleted that object a moment later — so no Certificate existed for compass.citops.net until the Ingress was touched again (a label added and removed). After the nudge cert-manager created `compass-tls` and re-issued it (SAN now compass.citops.net only, expiry 2026-12-13); `compass-vendor-portal-tls` had issued on its own. A fresh install (production) has no pre-existing Certificate, so no race there. Secret on staging now carries DATABASE_URL + SESSION_SECRET_KEY only; the Valkey URLs are in the ConfigMap; healthz/readyz 200 on both hosts.'
assignee: steve
label:
- tech_debt
priority: urgent
task_status: done
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