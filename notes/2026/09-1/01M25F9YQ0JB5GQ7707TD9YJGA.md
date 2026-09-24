---
id: 01M25F9YQ0JB5GQ7707TD9YJGA
created: 2026-09-10T10:55:05.952857Z
updated: 2026-09-24T20:29:37.868671Z
type: task
title: CI renders the chart — a chart-only PR is currently gated by nothing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 655
sprint: stek6vx
comments:
- id: 01M2GR2GC3029004482E7ZX4YN
  author: Steve Vine
  at: 2026-09-14T19:59:57.826907Z
  text: |-
    Merged to main 2026-09-14 20:00 as bb59fa0 (PR #716). New `chart` job in the PR gate (job-level `if:` on a new `chart` output of the `changes` filter; also runs on workflow/scripts/ci changes): helm lint per overlay; helm template per overlay (defaults with an existing Secret, staging, production) through kubeconform -strict with no CRD schemas — invalid Kubernetes fails, and so does any non-core kind, which is ADR 0073 §1 machine-checked; and scripts/ci/check-chart-immutable-fields.sh, which renders at 0.0.0-dev and packaged at 9.9.9 and diffs StatefulSet selector/volumeClaimTemplates, Job selector and PVC spec (reintroducing helm.sh/chart into the Valkey claim template fails it — verified). kubeconform v0.8.0 baked into the runner image Dockerfile with a download fallback in the job; the image roll is Steve's.

    **Open for Steve**: add `chart` to main's required status checks so a chart-only PR is gated, not merely reported (branch-protection edit; adding a context is safe). Until then the job runs and shows red but does not block.
assignee: steve
label:
- improvement
priority: high
task_status: done
tech: null
---
Seen 2026-09-10: PR #656 (chart image defaults + version placeholders) and PR #658 (the Valkey fix) were both "green" with every test job skipped — the `changes` filter routes `chart/**` to no job at all. #656 carried a change that failed the very next `helm upgrade` (COM-654), and nothing in CI could have caught it.

**Promoted 2026-09-14 (ADR 0073).** This is no longer a nice-to-have. The production install was blocked by `templates/externalsecret.yaml` emitting `external-secrets.io/v1beta1`, which ESO 2.2.0 does not serve — a template that has *never once been rendered against a live cluster*, because staging uses an inline Secret. It was broken for months and nothing could have told us. The sprint is about to make the largest chart changes the project has had; this is the job that stops the next silent one.

**Add a `chart` job** to `.github/workflows/ci.yml`, run when `chart/**` changes (extend the `changes` filter; keep it in the PR gate, job-level `if:` like the others — never workflow-level `paths-ignore`):

- `helm lint chart/` with each overlay — `values-staging.yaml` and `values-production.yaml` (note: renamed from `values-prod.yaml` since this task was written), plus the `--set` values the production overlay needs to render.
- `helm template` both overlays and pipe through `kubeconform` so a template that renders invalid Kubernetes fails here (`kubectl apply --dry-run=server` is not available on a PR runner; kubeconform with the server version's schemas is the offline option).
- **Enforce ADR 0073's no-CRD rule.** `kubeconform` in strict mode with no CRD schemas fails on any kind it does not recognise — which is exactly the guard wanted: an `ExternalSecret` or a `cert-manager.io/v1 Certificate` in the rendered output becomes a failing build rather than a rule someone has to remember. This makes §1 of the ADR machine-checked.
- **Upgrade-safety check for COM-654's class of bug**: render at two different `--version`/`--app-version` values (package once at `9.9.9`) and diff the immutable sections — every `StatefulSet` `.spec.selector` and `.spec.volumeClaimTemplates`, every `Job` `.spec.selector`, every `PersistentVolumeClaim` `.spec`. Any difference fails the job. A small script under `scripts/ci/`, so the rule in the README hard-rules list is enforced, not remembered.

helm is in the runner image (COM-466); kubeconform would be one more pinned binary there, with the usual download fallback.

**Acceptance**: a PR that reintroduces `helm.sh/chart` into the Valkey claim template fails CI; a PR that adds any CRD-typed resource to the chart fails CI; a chart-only PR shows a real job in its checks.