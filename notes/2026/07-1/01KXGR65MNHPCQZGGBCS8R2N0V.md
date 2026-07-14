---
id: 01KXGR65MNHPCQZGGBCS8R2N0V
created: 2026-07-14T16:43:28.789419073Z
updated: 2026-07-14T20:47:48.916521Z
type: task
title: CI pipeline & branch protection
task_status: done
label:
- chore
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 4
comments:
- id: 01KXGR6N7NWT7QB33TV99197JT
  author: Steve Vine
  at: 2026-07-14T16:43:44.757331863Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 09:05 UTC]
    **Done building — moving to In Review.** PR: https://github.com/Steve-vine/compass/pull/2

    ## What was done
    - **`.github/workflows/ci.yml`** (PR + push to main) — five required checks, all green on the PR:
      - `backend`: ruff check, ruff format --check, mypy (strict), pytest
      - `frontend`: eslint, tsc, prettier --check, vitest, build
      - `secret-scan`: Gitleaks (full history)
      - `deps-scan`: pip-audit (backend lockfile) + npm audit (`--omit=dev --audit-level=high`)
      - `sast`: Semgrep OSS (`p/default`)
    - **`.github/workflows/release.yml`** (push to main only) — builds + pushes backend/frontend images to **GHCR (private)**, tagged `<ref>-yyyymmdd-hhmm` + short SHA; never `latest`. Correctly did **not** run on the PR.
    - **chart**: `values-prod.yaml` points at GHCR; `chart/README.md` documents the `imagePullSecret`.
    - **docs**: new `docs/ci.md`; `CONTRIBUTING.md` updated (branch naming, squash-only, CI-required-not-human-approval).
    - **Branch protection on `main`** applied via `gh`: requires the 5 CI checks, `strict` (up-to-date), `enforce_admins`, linear history, **no required human approval** (ADR 0016). **Squash-only merge** + delete-branch-on-merge enabled.
    - **ADR 0020** added in the project repo recording the registry + scanning decisions.

    ## Decisions made on the fly
    - **SAST = Semgrep OSS, not CodeQL.** CodeQL needs GitHub Advanced Security, which is **not available** on this private repo (`security_and_analysis` empty). Semgrep preserves SAST coverage; swapping to CodeQL later is a one-job change if GHAS is ever enabled. Recorded in ADR 0020.
    - **`enforce_admins: true`** so the CI gate is real even for the solo admin — relaxable later via a settings flip.

    ## Problems encountered
    - First `secret-scan` run failed 403 ("Resource not accessible by integration") — gitleaks-action reads the PR commit list, which the default `contents: read` token can't do. Fixed by granting that job `pull-requests: read`. Re-run is green.

    ## Acceptance criteria
    - [x] GitHub Actions on PR: ruff, type checks, pytest, vitest
    - [x] Security scanning: dependency, secret, and SAST
    - [x] On merge to main: build + push immutable images `<branch>-yyyymmdd-hhmm` (release.yml; will fire on the squash-merge)
    - [x] Branch protection: require CI to pass (no human approval)
    - [x] Document the branch naming + squash-merge convention

    ## Out of scope (raise as follow-ups if wanted)
    - Postgres-backed integration tests in CI (arrives with DEV-392).
    - Trivy image scanning of the built images; auto-deploy to the cluster (no CI→cluster path).

    Note: the first real exercise of `release.yml` happens when this PR is squash-merged — worth confirming the GHCR packages appear (private) before closing.
- id: 01KXGR6YRVN50BDMSM7KBC0PPA
  author: Steve Vine
  at: 2026-07-14T16:43:54.523061184Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 09:24 UTC]
    **Merged + verified — moving to Done.** Squash-merged as `1033140` ([PR #2](https://github.com/Steve-vine/compass/pull/2)).

    The `release.yml` run on the merge succeeded and pushed both images to GHCR:
    - `ghcr.io/steve-vine/compass-backend:main-20260614-0921` (+ `:1033140`)
    - `ghcr.io/steve-vine/compass-frontend:main-20260614-0921` (+ `:1033140`)

    Tags follow the ADR 0008 `<ref>-yyyymmdd-hhmm` scheme; no `latest`. Packages from a private repo's Actions inherit **private** visibility by default.

    ### Notes / possible follow-ups (not filed yet)
    - **Package privacy** couldn't be confirmed via API — my local `gh` token lacks `read:packages`. Worth a 10-second glance in the GHCR UI that both packages show *Private*.
    - **Node 20 action deprecation** — GitHub flagged `checkout@v4` / `docker/*` actions running on Node 20 (forced to Node 24 from 2026-06-16). The pinned majors already ship Node 24-capable builds, so no breakage expected; a routine version bump can clear the warning. Say the word and I'll file it as `tech-debt`.
sprint: s7hkfxa
---
Stand up CI and the CI-gated merge policy per ADR 0016.

- [ ] GitHub Actions on PR: ruff, type checks, pytest, vitest
- [ ] Security scanning: dependency, secret, and SAST
- [ ] On merge to main: build + push immutable images `<branch>-yyyymmdd-hhmm`
- [ ] Branch protection: require CI to pass (no human approval — solo + AI review)
- [ ] Document the `dev-<id>-slug` branch naming + squash-merge convention

Refs: ADR 0016, 0008.

---

## Agreed approach (plan-mode sign-off 2026-06-14)

**Decisions (confirmed with Steve):**

* **Registry:** GHCR **private** — `ghcr.io/steve-vine/compass-backend` & `-frontend`. Cluster pulls via an `imagePullSecret`; local `nerdctl …:local` dev loop unchanged.
* **Security scanning:** GitHub-native intent. CodeQL needs GitHub Advanced Security, which is **not available** on this private repo (`security_and_analysis` empty), so SAST uses **Semgrep OSS** as the agreed fallback. Secret = Gitleaks; dependency = pip-audit (backend) + npm audit (frontend).
* **Repo settings:** applied via `gh` — squash-only merge + branch protection (CI required, no human approval per ADR 0016).

**Build:**

1. `.github/workflows/ci.yml` (PR + push to main): jobs `backend` (ruff check/format, mypy, pytest), `frontend` (lint, typecheck, format:check, vitest, build), `secret-scan` (gitleaks), `deps-scan` (pip-audit + npm audit), `sast` (semgrep OSS).
2. `.github/workflows/release.yml` (push to main): build + push both images to GHCR private, tag `<ref>-yyyymmdd-hhmm` + short SHA (ADR 0008, never `latest`).
3. Chart: `values-prod.yaml` images → GHCR; document `imagePullSecret` in `chart/README.md`.
4. Docs: update `CONTRIBUTING.md` (branch naming, squash-only, CI-gated self-merge), add `docs/ci.md`.
5. Repo settings via `gh`: squash-only + branch protection on `main`.
6. ADR 0020 (project repo) recording registry + scanning choices.

**Out of scope (follow-ups if needed):** Postgres integration tests in CI (<issue id="5848cfcb-6bb5-44d3-be70-e97b90a7c322" href="https://linear.app/stevevine/issue/DEV-392/database-foundation-sqlalchemy-alembic">DEV-392</issue>), Trivy image scanning, auto-deploy to the cluster (no CI→cluster path).

---
*Migrated from Linear [DEV-390](https://linear.app/stevevine/issue/DEV-390/ci-pipeline-and-branch-protection) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-392, DEV-389*