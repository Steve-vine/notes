---
id: 01KXGR65MNHPCQZGGBCS8R2N0V
created: 2026-07-14T16:43:28.789419073Z
updated: 2026-07-14T16:43:28.789419073Z
type: task
title: CI pipeline & branch protection
task_status: done
label: chore
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 4
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