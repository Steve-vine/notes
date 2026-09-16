---
id: 01M2K5EVT5MVJBQ8J25BNCJDSP
created: 2026-09-15T18:32:23.109377Z
updated: 2026-09-16T16:32:33.947664Z
type: task
title: A generic install guide — the chart's three decisions, with env-production-uk-pri kept as a worked example
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 716
sprint: stek6vx
comments:
- id: 01M2NH064VK8B1Y20KN8HEJSTA
  author: Steve Vine
  at: 2026-09-16T16:32:33.947464Z
  text: 'Done 2026-09-16 across three PRs: #724 examples/cnpg-cluster.yaml, #725 examples/aws/s3-irsa.sh (+ #726 the encryption note), and #729 (541fe09) the guide itself. chart/README.md is now the generic install guide: prerequisites with no operator; the evaluation one-liner; a real deployment as three decisions (a Secret with two values; where attachments go — chosen in the app per ADR 0074, with the pod''s identity as the one values-file fact; the public origin) and a values-file template that is the whole file for a cloud install; surfacing/HTTPS/TLS as the operator''s; upgrade; uninstall; hard rules. Grep-checked: no Moneypenny account, zone, hostname, role or bucket in it. Ours moved out: cutting a release and building images → scripts/infra/RELEASE.md; the g5 bootstrap → scripts/infra/README.md, which indexes the three environments as worked examples; production''s runbook and setup.sh relabelled as what we did for one cluster; scripts/infra/aws-staging/README.md records the env-staging-uk install. On main, not released.'
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Scoped with Steve 2026-09-15 while preparing the AWS staging install. The production runbook (`scripts/infra/production/README.md`) and `aws/setup.sh` are a worked example for one cluster — account, OIDC provider, zone, NLB hostname, StorageClass, role, bucket and secrets prefix are all hard-wired — presented as if they were the instructions. Anyone else following them would be reading someone else's cluster. ADR 0073 made the chart generic; the guide has to match.

**What the chart actually needs from an operator** — three decisions and one cluster fact, nothing else:

1. **A Secret** carrying `DATABASE_URL` and `SESSION_SECRET_KEY`, named in `secrets.existingSecret`. Produced however they like (ESO, Vault, Sealed Secrets, SOPS, `kubectl create secret`). Or the inline Secret for evaluation.
2. **Where attachments go**: an S3-compatible bucket (name, region; credentials by workload identity through the ServiceAccount annotation, or two keys in the Secret) — or a filesystem volume (RWO single-node, RWX otherwise).
3. **The public origin** in `config.appBaseUrl` — needed only because emailed links are absolute and sent by a worker with no request to read a host from. DNS and the certificate are the operator's.

Plus: a StorageClass name for Valkey if the cluster has no default.

Explicitly **not** the chart's business and not in the guide's prerequisites: how the Service is surfaced (Ingress, tunnel, LoadBalancer, port-forward), certificates, secret stores, cloud accounts and IAM. Each gets one sentence saying so and, where the chart has a hook (`ingress.*`, the cert-manager annotation, ServiceAccount annotations), where the hook is.

**Deliverable**

- `chart/README.md` (or `docs/install.md`, linked from it) becomes the guide: prerequisites as the list above; the three decisions with the values each sets; the evaluation recipe (bundled Postgres, bootstrap admin, port-forward); the real-deployment recipe (`helm upgrade --install … oci://… --version X -f your-values.yaml`); upgrade; uninstall; the generated-key/GitOps warning; the migration ordering note.
- A worked example per environment, clearly labelled as examples: `scripts/infra/production/` stays as env-production-uk-pri's (its README retitled "worked example"), its values in `chart/values-production.yaml`. The AWS staging cluster becomes a second example once installed — same layout, its own names.
- `aws/setup.sh` either becomes parameterised by environment (every hard-wired name an input) or is reframed as "what we did for this cluster" and not offered as a tool. Decide at implementation; the guide must not depend on it.
- The g5 staging overlay is a third example (k3s, inline Secret, local volume).

**Acceptance**: someone with a fresh cluster, a Postgres, and no knowledge of our environments can install Compass from the guide alone; nothing in the guide's steps names a Moneypenny account, zone, hostname, role or bucket; the three environments each have a labelled example that follows the guide's shape.