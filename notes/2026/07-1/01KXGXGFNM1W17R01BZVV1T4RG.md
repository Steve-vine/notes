---
id: 01KXGXGFNM1W17R01BZVV1T4RG
created: 2026-07-14T18:16:29.620626927Z
updated: 2026-07-14T18:16:59.203149345Z
type: task
title: Deploy Compass on new server
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 158
sprint: sc5mwga
comments:
- id: 01KXGXGZYZYWA82CGV01JZK6AM
  author: Steve Vine
  at: 2026-07-14T18:16:46.30374724Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-05 16:30 UTC]
    **Agreed plan (approved in plan mode, 2026-07-05)**

    Migrate CI/CD and the dev deployment to g5:

    1. **Runners** — all workflow jobs move to the ARC scale set `compass-runners` in g5, upgraded to dind container mode (Docker for testcontainers, gitleaks, buildx). Done: helm upgrade applied, `maxRunners: 4`.
    2. **Pipeline** — `release.yml` absorbed into `ci.yml`: PR → main = full test suite (quality gate); push → staging = suite + build/push images to zot + helm deploy staging + smoke checks (`/readyz` via ingress); push → main = suite + build/push only (staging is the only live environment for now).
    3. **Registry** — images at `zot.citops.net/compass/{backend,frontend}`, immutable `<branch>-yyyymmdd-hhmm` + SHA tags, amd64-only, buildx cache in zot. Anonymous access accepted for the internal network (revisit before prod).
    4. **Staging env** — `compass` namespace on g5, host `compass.citops.net`, new `chart/values-staging.yaml` (replaces `values-k3s.yaml`), CNPG Postgres + mailpit + CI deployer RBAC applied from `scripts/infra/`. Done: all three applied; Postgres healthy.
    5. **Decisions/docs** — ADR 0036 (staging-based workflow, supersedes branching model of 0016/0019) and ADR 0037 (self-hosted runners + zot, supersedes registry choice of 0020); docs/ci.md, CONTRIBUTING.md, brief/ways-of-working.md, chart/README.md, README.md updated.

    Branch `feature/dev-845-deploy-on-g5` pushed (e13b6bb). Next: PR → main (validates the test jobs on the new runners), then staging bootstrap + smoke test.

    **Environment gaps found while checking dependencies:** g5 host had no uv (now installed), no Node/docker (needs sudo — command provided to Steve), `gh` CLI unauthenticated (Steve to run `gh auth login`).
- id: 01KXGXHCJ3MCJVVB1KSN15NN0K
  author: Steve Vine
  at: 2026-07-14T18:16:59.203013961Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-05 18:46 UTC]
    **Pipeline green end-to-end (staging run 28750606314)**

    - All five test jobs pass on `compass-runners` (integration tests via testcontainers under dind).
    - `build-images` 43s with warm zot registry cache (2m49s cold); images `zot.citops.net/compass/{backend,frontend}:staging-20260705-1843` + SHA tags.
    - `deploy-staging` 42s: helm release `compass` rev 2 `deployed`, all workloads on the immutable staging tag, smoke checks pass (in-cluster API `/readyz`, public https://compass.citops.net).

    Issues found and fixed during bring-up (all on the feature branch, PR #150 green):
    1. Semgrep blocked mailpit manifest → proper securityContext added.
    2. Transient upstream DNS SERVFAIL killed a testcontainers pull → retrying pre-pull of test images.
    3. `uvx pip-audit` nondeterministically picked the runner image's system python (no ensurepip) → pinned to uv-managed Python.
    4. **Deterministic buildx failure**: BuildKit's nested container on dind's bridge (MTU 1500) inside flannel (MTU 1450) dropped large TLS handshakes to ghcr.io → `driver-opts: network=host`.
    5. `helm --wait` hung on the Ingress LB address traefik never publishes → dropped `--wait` (hooks still gate); smoke now probes the API Service in-cluster (public `/readyz` was routed to the frontend — false positive).

    Follow-ups filed: DEV-851 (frontend test flake), DEV-852–855 (CI performance).

    **Next: Steve's UI smoke test on https://compass.citops.net**, then release (merge PR #150 → main).
---
I have created a new server to run Compass on, going forward I'll refer to that as g5.  All of the dependancies have been installed but do check first.
You are currently running on the g5 server.  The context is at ~/.kube/g5.yaml
Before continuing, enter plan mode so we can address the following changes and requirements.

* I have made changes to the workflow we will follow going forward.  This are documented in CLAUDE.md - How We Work section.  Review this first to ensure you understand and ask any questions you have.  I have not updated any other documents so please review documents in /brief /docs and /decisions to make sure there are no ambiguities.  Short version, all issues will be created on a feature branch and merged into staging, staging will be deployed into the cluster for testing and later merged into main.
* GitHub runners have been setup in this cluster and are setup in GitHub as compass-runners.  All actions should now use these rather than running in GitHub.  Review the CI pipeline and amend as necessary.
* Image repo.  previously you build images and coped them into the cluster.  The g5 cluster is running zot (zot.citops.net) - All images should be pushed here going foward once in staging and deployed from this repo.  This will more closely resemble the eventual prod environment for deployments and updates.

Next steps should be to discuss with me in planning mode how we get from here to a working Compass deployment in g5, using local runners, building the images and pushing to zot, and understanding the new way of working.  Finally updating any appropriate documentation.

---
*Migrated from Linear [DEV-845](https://linear.app/stevevine/issue/DEV-845/deploy-compass-on-new-server) · created 2026-07-05 · completed 2026-07-05*  
*Related to (Linear): DEV-855, DEV-854, DEV-853, DEV-852*