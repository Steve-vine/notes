---
id: 01M25F9YQ0JB5GQ7707TD9YJGA
created: 2026-09-10T10:55:05.952857Z
updated: 2026-09-10T10:55:08.848929Z
type: task
title: CI renders the chart — a chart-only PR is currently gated by nothing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 655
sprint: stek6vx
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Seen 2026-09-10: PR #656 (chart image defaults + version placeholders) and PR #658 (the Valkey fix) were both "green" with every test job skipped — the `changes` filter routes `chart/**` to no job at all. #656 carried a change that failed the very next `helm upgrade` (COM-654), and nothing in CI could have caught it.

**Add a `chart` job** to `.github/workflows/ci.yml`, run when `chart/**` changes (extend the `changes` filter; keep it in the PR gate, job-level `if:` like the others — never workflow-level `paths-ignore`):

- `helm lint chart/ -f chart/values-staging.yaml` and with `values-prod.yaml` (plus the `--set` values the prod overlay needs to render — `ingress.host`, both image tags).
- `helm template` both overlays and pipe through `kubeconform` (or `kubectl apply --dry-run=server` is not available on a PR runner — kubeconform with the k3s server version's schemas is the offline option) so a template that renders invalid Kubernetes fails here.
- **Upgrade-safety check for COM-654's class of bug**: render at two different `--version`/`--app-version` values (package once at `9.9.9`) and diff the immutable sections — every `StatefulSet` `.spec.selector` and `.spec.volumeClaimTemplates`, every `Job` `.spec.selector`, every `PersistentVolumeClaim` `.spec`. Any difference fails the job. A small script under `scripts/ci/`, so the rule in the README hard-rules list is enforced, not remembered.

helm is in the runner image (COM-466); kubeconform would be one more pinned binary there, with the usual download fallback.

**Acceptance**: a PR that reintroduces `helm.sh/chart` into the Valkey claim template fails CI; a chart-only PR shows a real job in its checks.