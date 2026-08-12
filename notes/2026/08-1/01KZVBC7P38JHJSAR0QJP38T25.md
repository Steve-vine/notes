---
id: 01KZVBC7P38JHJSAR0QJP38T25
created: 2026-08-12T16:02:38.403478Z
updated: 2026-08-12T16:04:25.527001Z
type: task
title: 'Chart: secretKeyRef refactor for DATABASE_URL / BROKER_URL / RESULT_BACKEND_URL / JWT'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 117
sprint: sw9wx5e
assignee: steve
imported_from: linear
label: null
priority: low
task_status: backlog
---
Move `DATABASE_URL`, `BROKER_URL`, `RESULT_BACKEND_URL`, and JWT signing material from inline `stringData` in `chart/templates/secrets.yaml` to `secretKeyRef` against the CNPG-generated Postgres user secret, the Valkey secret (when one exists), and the externally-applied `redvektor-jwt` secret.

**Motivation**

Today the chart materialises a `redvektor-secrets` Secret at install time with literal URL strings baked in (interpolated from `secrets.values.*`). This works but couples deploy values to runtime credentials — for k3s/EC2 we end up with Postgres password literals in `values-k3s.yaml`, and JWT key material in the same file. Cleaner pattern: each Deployment's env reads URLs from the underlying source Secrets directly. Operator manages credentials in Secrets, chart only knows about consumption.

**Scope**

* `chart/templates/secrets.yaml` — restructure so `redvektor-secrets` only contains values that genuinely need to live there; URL fields move out
* `chart/templates/api/deployment.yaml`, `worker/deployment.yaml`, `beat/deployment.yaml` — switch env wiring from `envFrom: secretRef: redvektor-secrets` to a mix of envFrom (for the still-inline values) + `valueFrom.secretKeyRef` (for the externalised URL and JWT fields)
* `chart/values.yaml` — new values structure for telling the chart where each URL comes from (CNPG cluster name, Valkey service ref, external JWT secret name, etc.)
* `chart/values-minikube.yaml` — adjust to new pattern, retain hardcoded dev password (now scoped tighter)
* `chart/values-k3s.yaml` — adjust to new pattern, JWT moves to existingSecret ref against `redvektor-jwt` (the Brief 064 example file finally gets wired up)
* Render tests / kubeconform pass

**Out of scope**

* Production ESO path — `externalsecret.yaml` already handles that route; don't disturb
* KEK — already externalised via `security.credentialKek.existingSecret`
* Postgres password rotation — CNPG handles it; this just makes the chart consume rather than literalise

**Why defer**

Discussed at Brief 066 (DEV-284) drafting time (2026-05-26). Original Linear scope for DEV-284 included this refactor; pulled out because (a) the existing pattern works for both targets, (b) the refactor touches four Deployment templates plus values structure across three files, (c) shipping a working k3s deploy is the cutover's gating need and the refactor is hygiene not function. Better as its own focused brief.

**Pairs with / depends on**

* Brief 066 (DEV-284) lands first, establishes the chart on k3s with the current pattern.
* This brief is appropriate as a Phase 5 follow-up or a Phase 6 item depending on what else lands. Not urgent.

---

Imported from Linear [DEV-288](https://linear.app/stevevine/issue/DEV-288/chart-secretkeyref-refactor-for-database-url-broker-url-result-backend)