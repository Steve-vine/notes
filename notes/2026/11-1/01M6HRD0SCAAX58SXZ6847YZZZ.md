---
id: 01M6HRD0SCAAX58SXZ6847YZZZ
created: 2026-11-03T22:27:44.044093Z
updated: 2026-11-04T07:22:32.507687Z
type: task
title: GitHub Actions secrets as a store — the names and last-changed dates of each repository's, environment's and the organisation's Actions secrets join Secrets ▸ Discovered, so a CI copy of a key is tracked like a vault copy
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1576
sprint: sjrd5gz
blocked_by:
- 01M6HSKSHZ9Z1CH63MZ64MDH8B
comments:
- id: 01M6JGWSGDCXZDNTSE4EDG66TQ
  author: Steve Vine
  at: 2026-11-04T05:35:46.700958Z
  text: |-
    Merged to main in PR #1591.

    **What's in it**
    - With the GitHub tile's Actions secrets feature on, Secrets ▸ Discovered lists GitHub Actions secrets as stored copies, read in the same six-hourly pass as the keys. Each copy shows:
      - where it is: the organisation, a repository, or a repository ▸ environment;
      - its name, created and last changed;
      - for an organisation secret, who can use it ("Every repository can use it", "Used by billing, compass").
    - They have the same choices as vault copies: make a secret, add to one, or discard.
    - GitHub has no tags on secrets, so the Kept in card now says to add these from Discovered or to confirm Compass's suggestion.
    - A CI copy counts like any stored copy. In the three-way case with the CI copy as a third, the secret reads "Half done: 2 of 3 copies updated — GitHub Actions ▸ RootCause-IT ▸ compass ▸ DEPLOY_BILLING hasn't changed since …". It's proven once that copy changes too (tested).
    - A repository the App can't read is named on Discovered, and its copies are left alone.

    The live listing's shape was checked with `gh api` against the compass repository: one secret with its created and updated dates, and a staging environment.

    **Couldn't check:** a full read through the App. None is installed yet.
- id: 01M6JQ095VVR4SWBB1GTHGH3ND
  author: Steve Vine
  at: 2026-11-04T07:22:32.507457Z
  text: |-
    **Pre-UAT: Couldn't check.**
    - This needs the GitHub App, and seeding Actions copies was blocked.
    - The Kept in card now says GitHub Actions secrets can't be tagged.
    - The listing's shape was checked against the compass repository with `gh api`: one secret with its dates, and a staging environment.
    - **For Steve:** with the App connected, the repository's `BILLING_READ_TOKEN` should appear on Discovered.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1581, and reads through the GitHub integration (COM-1575).

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
- The feature switch is **Secrets ▸ Actions secrets** on the GitHub tile (COM-1575).

## Notes (technical)

- Endpoints, all metadata:
  - `GET /orgs/{org}/actions/secrets` (plus `/{name}/repositories`);
  - `GET /repos/{o}/{r}/actions/secrets`;
  - `GET /repos/{o}/{r}/environments`, then `/environments/{env}/secrets`.
  - Dependabot and Codespaces secrets are out of scope. Name them as later in the ADR.
- Permissions: repository **Secrets** read, repository **Environments** read, organisation **Secrets** read (already requested by COM-1575's App).
- Store entries are kind `github_actions`. Version change is detected from `updated_at`.

**Chain:** on the chain (migration and API).

**Done when:**
- A local read against RootCause-IT lists the compass repository's Actions secrets with their last-changed dates.
- On staging, in E2E Test Company, a secret with a seeded vault copy and a seeded GitHub copy shows "Half done" when only the vault copy changes, and completes when both have.
- The three-way case from COM-1581, with a GitHub Actions copy as a third stored copy, shows "Half done: 2 of 3" until the Actions copy changes too.
- The live read is **Couldn't check** in pre-UAT.