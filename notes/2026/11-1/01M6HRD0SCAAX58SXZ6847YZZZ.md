---
id: 01M6HRD0SCAAX58SXZ6847YZZZ
created: 2026-11-03T22:27:44.044093Z
updated: 2026-11-03T22:27:44.044093Z
type: task
title: GitHub Actions secrets as a store — the names and last-changed dates of each repository's, environment's and the organisation's Actions secrets join Secrets ▸ Discovered, so a CI copy of a key is tracked like a vault copy
assignee: steve
label: feature
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1576
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1575.

## What people see

- **Secrets ▸ Discovered** lists GitHub Actions secrets. Each row shows:
  - where it is: organisation, repository, or repository ▸ environment;
  - its name;
  - created, and **last changed**;
  - for an organisation secret, which repositories can use it.
- They have the same choices as vault entries: **make a secret**, **add to a secret** (the CI copy of a key that's also in Secrets Manager), or **discard**.
- **GitHub has no tags on secrets**, so `compass-secret` can't be used here. Linking is by suggestion (names and timing, COM-1571) or by hand. The Kept in card says so.
- **Rotation.** A change to a GitHub Actions copy counts like any stored copy (COM-1572): a rotation is complete only when the CI copy has changed too. **"Half done: GitHub ▸ compass ▸ STRIPE_KEY hasn't changed since 3 Mar"** is the common case this catches.
- GitHub's API can't return a secret's value at all. Compass shows that on the tile, next to the Secrets permission, so nobody worries about it.

## Notes (technical)

- Endpoints, all metadata:
  - `GET /orgs/{org}/actions/secrets` (plus `/{name}/repositories`);
  - `GET /repos/{o}/{r}/actions/secrets`;
  - `GET /repos/{o}/{r}/environments`, then `/environments/{env}/secrets`.
  - Dependabot and Codespaces secrets are out of scope. Name them as later in the ADR.
- Permissions: repository **Secrets** read, repository **Environments** read, organisation **Secrets** read (requested in COM-1575's App manifest).
- Store entries are kind `github_actions`. Version change is detected from `updated_at`.

**Chain:** on the chain (migration and API).

**Done when:**
- A local read against RootCause-IT lists the compass repository's Actions secrets with their last-changed dates.
- On staging, in E2E Test Company, a secret with a seeded vault copy and a seeded GitHub copy shows "Half done" when only the vault copy changes, and completes when both have.
- The live read is **Couldn't check** in pre-UAT.