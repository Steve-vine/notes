---
id: 01M73QEMA6B63G9XQCMKFA3S1R
created: 2026-11-10T21:57:28.006291Z
updated: 2026-11-11T14:00:55.080653Z
type: task
title: 'Target: GitHub''s Secrets reads recreated as configuration — deploy keys, the organisation''s fine-grained tokens and Actions secrets through App sign-in and follow-on reads, run beside the coded GitHub App and compared'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1713
sprint: sj4f1kj
blocked_by:
- 01M73QC5JFEQX7MZGKRC9RF4N6
- 01M73QCHFKHNH35P0021RQ8YQT
- 01M73Q9S96V19DX5JNC9G9GYXP
- 01M73QBB97RXXF7VVZ2GTZN0EV
comments:
- id: 01M749A186JQSVQJ8WG6SVG6GH
  author: Steve Vine
  at: 2026-11-11T03:09:31.782754Z
  text: |-
    Staging is ready (74c7156f). **Couldn't check**: this needs the GitHub App's ID and private key entered on screen, and the key never passes through me. Steps for Steve:
    1. Add a Collection integration (or use "Add with Polaris") with Sign-in "As an app". Settings: claims {iss: "{app_id}"}, lookup /orgs/{app_ref}/installation → id, exchange /app/installations/{lookup}/access_tokens → token / expires_at.
    2. Add an account with the App ID, the organisation as "What the app reads", and the private key.
    3. Set up feeds into Secrets for deploy keys (follow-on read per repository), the organisation's fine-grained tokens and Actions secrets.
    4. Run them beside the coded GitHub App and compare.
- id: 01M74TZ4DKE81FPQFCGBW6QZCX
  author: Steve Vine
  at: 2026-11-11T08:18:08.94725Z
  text: |-
    Set up on staging 2026-11-11: a new Collection integration, **GitHub App** (Sign-in "As an app", lookup /orgs/{app_ref}/installation, exchange /app/installations/{lookup}/access_tokens). Its three feeds wait for approval:
    - **Deploy keys** into Secrets ▸ keys: each installed repository's deploy keys, closing by "missing".
    - **Organisation fine-grained tokens** into Secrets ▸ keys: one read per organisation, which the feed finds by choosing one repository per owner.
    - **Actions secrets** into Secrets ▸ stored copies: organisation and repository secrets, names and dates only.

    There's no coded GitHub App connection on staging to compare with yet.

    Steve, next:
    1. Add an account on GitHub App with the App's ID, "What the app reads" (the organisation, e.g. Moneypenny-Development) and the private key.
    2. Test it, preview each feed and approve.
- id: 01M74YVVN6M00JHYB4WHEJKH64
  author: Steve Vine
  at: 2026-11-11T09:26:15.97472Z
  text: |-
    Steve added the GitHub App account (2026-11-11). Its Test failed at first with a 404: the App wasn't installed on Moneypenny-Development. Once installed, it tested OK. Previews:
    - **Organisation fine-grained tokens:** 5 tokens, with owners, created, expiry and last-used dates. It chose one repository for the organisation out of 247.
    - **Deploy keys** and **Actions secrets:** the preview times out, because each makes one follow-on read per repository (247) inside a web request. Scheduled runs on the worker aren't limited that way. Fix-forward task: COM-1722, which also makes the sign-in error name the step that failed.

    Steve: approve the three feeds. Their first runs on the worker will show the deploy keys and secrets.
- id: 01M756HJTRGXSF46KZFMXP335Y
  author: Steve Vine
  at: 2026-11-11T11:40:27.864364Z
  text: |-
    All three GitHub App feeds are live on staging (2026-11-11). The integration has been renamed "GitHub".
    - **Organisation fine-grained tokens:** 5 tokens.
    - **Actions secrets:** 52 stored copies (248 reads: the organisation and every repository).
    - **Deploy keys:** 57 keys across 247 repositories.

    Each run takes about 70 seconds on the worker. A second run read everything again and changed nothing.

    The first runs of Actions secrets and Deploy keys failed: the "looks like a secret" check mistook capitalised secret names (NPM_TOKEN, AWS_SECRET_ACCESS_KEY) and a repository's full name for keys. Worked round by separating the parts with " / " and ":". The proper fix is COM-1726.

    Still to do: compare with the coded GitHub App. There's no coded GitHub connection on staging, so the comparison needs production's or a fresh coded connection.
- id: 01M75EJQR6E36M35F9YRDDKJ84
  author: Steve Vine
  at: 2026-11-11T14:00:54.27783Z
  text: |-
    Where this stands (2026-11-11 14:00, staging bb59b9a2). The configuration side is done; what's left needs Steve and time.
    - The three GitHub App feeds are live: Organisation fine-grained tokens (5), Actions secrets (52 stored copies), Deploy keys (57 across 247 repositories). Each runs in about 70 seconds, and a second run changed nothing.
    - Preview no longer times out on the 247-repository feeds. It reads a sample of 25 (COM-1722, on staging now).
    - The "looks like a secret" check now accepts capitalised secret names and paths (COM-1726, on staging). The feeds still join their parts with " / " from the earlier workaround. Switching them back to plain owner/repository text would send all three back to waiting for approval, so I've left that for Steve to decide.

    Still needs Steve:
    1. **The comparison with the coded GitHub App** (two days side by side). Staging has no coded GitHub connection, so it needs one added on staging, or a comparison against production's coded tile.
    2. **Rotation proof:** add a test deploy key, change its stored copy, remove the old key, and check the secret shows "Seen at source and store".

    I'll export the full configuration as JSON onto this task once the comparison is agreed.
assignee: steve
label:
- feature
priority: high
task_status: review
---
One of the sprint's three targets (ADR 0146, COM-1705). Today a coded GitHub App (ADR 0141 §13, COM-1575/1576/1581) reads deploy keys, fine-grained tokens and Actions secrets for Secrets. Sprint sep79bz already proves the organisation's alerts and repositories as feeds (COM-1704). This task finishes GitHub.

**Chain:** independent (configuration and comparison on staging)

## What gets set up

- The GitHub Collection integration gains an account using **App sign-in** (COM-1707). This is a read-only GitHub App with the same permissions as today's coded one, or the same App.
- Feeds into Secrets:
  - **deploy keys**: the repositories, then each repository's keys (COM-1706). A repository answering "no permission" is skipped and its keys are left as they were, matching today's behaviour;
  - **fine-grained tokens** granted to the organisation, with owner, expiry and last use;
  - **Actions secrets as stored copies**: organisation, repository and environment secrets, by name and last change, through follow-on reads.

## Done when

- On staging (E2E Test Company, then Test Company), the configured feeds and the coded GitHub App are run side by side for at least two days.
- A comparison on this task lists, for each kind, the keys or copies each found. They must match. Every difference is explained or fixed (as a capability, never a special case).
- Rotation proof for a test deploy key works through the feed: add a new key, change the stored copy, remove the old key, and the secret shows *Seen at source and store*.
- The full configuration is exported as JSON on this task, so it can be recreated on production.
- No code change for GitHub (COM-1696).