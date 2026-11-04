---
id: 01M6HR8Z8FVJECPZS7P5B737GE
created: 2026-11-03T22:25:31.407811Z
updated: 2026-11-04T07:45:54.847507Z
type: task
title: Read AWS Secrets Manager — names, dates, tags and rotation settings (never values) from every connected AWS account; new entries wait on Secrets ▸ Discovered to become a secret, join one, or be discarded; secrets AWS manages itself are set aside
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1569
sprint: sjrd5gz
blocked_by:
- 01M6HR8C5PDSD00WXVFTFP3KDQ
comments:
- id: 01M6J8C66V8KJTBCFG3ABXRX9Q
  author: Steve Vine
  at: 2026-11-04T03:06:54.043038Z
  text: |-
    Done: PR #1583 merged, migration 0777.

    What's there:
    - **Integrations ▸ AWS ▸ Features ▸ Secrets**, a new switch, off until switched on. After each account's discovery read, Compass lists its Secrets Manager secrets with two calls only, `ListSecrets` and `ListSecretVersionIds`. The shipped policy gains just those two, and a test holds it to never containing `GetSecretValue`, `BatchGetSecretValue` or a wildcard. `docs/aws/README.md` says so.
    - **Secrets ▸ Discovered**, a new tab, lists what was read: name, description, tags, account and region, last changed and last read. *Managed by the cloud* (RDS passwords and the like) and *Discarded* are folded away. For each row, *Manage secrets* can:
      - **Make a secret.** The form starts from what was read, and the copy is kept under it.
      - **Add to a secret.**
      - **Discard** with a reason, and **Restore**.
    - **A refused permission** shows on Discovered: "Can't read Secrets Manager: re-apply the Compass policy".
    - **On a secret,** each read copy shows changed, last read and seen dates. A copy that disappears says "Gone from the store on …". If every read copy has gone and nothing is typed in: "Not stored anywhere Compass can see".
    - **AWS's own rotation** (rotation on) is recorded on the secret once, as *Rotated by the cloud*.

    Live check: the reader run locally against the staging account (463040245339) found **116 secrets in eu-west-2, eu-west-1 and us-east-1**: names, dates and versions, no value. That run also found a bug: boto3 has no paginator for `ListSecretVersionIds`, so it's paged by token. There were plenty of real secrets there, so I didn't create a throwaway one.

    My calls:
    - **The connection's health message shows on Discovered** (a banner per account), not on the AWS tile, because the tile's health belongs to discovery.
    - **"Not this secret"** on a read copy sends it back to Discovered (built here; COM-1571 adds the remembering).

    To check (Couldn't check in pre-UAT: E2E Test Company has no connections):
    1. Re-apply the AWS template on the staging account's Compass user or role.
    2. Switch on Integrations ▸ AWS ▸ Features ▸ Secrets.
    3. Read now. The company's Secrets ▸ Discovered lists the staging secrets.
    4. Make a secret from one, add another to it, discard one and restore it.
- id: 01M6JPZKSKFTFEFRT03HZV2FCD
  author: Steve Vine
  at: 2026-11-04T07:22:10.611418Z
  text: |-
    **Pre-UAT: Couldn't check** (staging, E2E Test Company).
    - E2E Test Company has no cloud connection (the provisioning refuses one), so no Secrets Manager read can run there.
    - I tried to seed copies straight into staging's database for the Discovered checks; the permission classifier blocked database writes, and I didn't work around it.
    - **What was checked:** Secrets ▸ Discovered opens, with no page errors, and says what will arrive when a store is read. The AWS tile has its Secrets feature.
    - **For Steve:** switch on Integrations ▸ AWS ▸ Features ▸ Secrets for a company with an AWS account (after re-applying the policy), then look at Discovered. The earlier live staging read found 116 secrets.

    Screenshot: `~/compass-uat/sprint-105/COM-1569/discovered-tab.png`.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1568. It follows the discovery pattern (ADR 0099) and the AWS connection (ADR 0101).

## What people see

- **Secrets ▸ Discovered.** One row per secret found in AWS Secrets Manager that isn't yet part of a registered secret. Each row shows:
  - name, account, region and description;
  - tags;
  - created, **last changed**, and **last accessed** (a day; AWS gives no time);
  - rotation on or off, with its last and next rotation.
- **What a person can do with each row** (with *Manage secrets*):
  - **Make a secret.** The add form opens with the name, "Kept in: AWS Secrets Manager ▸ account ▸ region ▸ name", and last changed as Last rotated already filled in.
  - **Add to a secret**, for a copy of a key already registered (the same key in two regions, say).
  - **Discard**, with a reason. It's listed under Discarded and can be restored.
- **Managed by AWS.** Secrets owned by another AWS service (RDS-managed passwords and the like) are set aside under **"Managed by AWS (n)"**, folded away by default. They can still be made into secrets if someone wants them tracked.
- **On a registered secret**, the Kept in card shows the AWS entry with its last changed and last accessed dates, and the date of the last read.
- **Gone.** An entry that disappears from AWS shows "Gone from AWS on 3 Dec" on its secret. A secret whose only stored copy has gone is flagged **"Not stored anywhere Compass can see"**.
- **AWS rotation on:** each rotation AWS performs is recorded on the secret automatically, as **Rotated by AWS** (COM-1566's history), because AWS changes both ends together.
- **The connection's health** says so if Compass lacks the new permissions: "Can't read Secrets Manager: re-apply the Compass policy". Everything else keeps working.

## Notes (technical)

- New reader in `core/discovery/aws/`. It declares `secretsmanager:ListSecrets` and `secretsmanager:ListSecretVersionIds` through `required_actions`, so `aws_policy.py` and the shipped `docs/aws/` files regenerate (`tests/test_aws_policy.py` holds them).
- **Add a test that the generated policy never contains `secretsmanager:GetSecretValue`, `secretsmanager:BatchGetSecretValue` or `secretsmanager:*`.** Compass must be unable to read a value.
- Keep: ARN, name, description, tags, CreatedDate, LastChangedDate, LastAccessedDate, RotationEnabled, LastRotatedDate, NextRotationDate, OwningService, and version ids with their CreatedDate and stages (AWSCURRENT, AWSPREVIOUS).
- Every region the connection already reads. Page through results (memory: page-at-a-time cloud reads).
- Store entries become `secret_store_entry` rows of kind `aws_secrets_manager`, with company_id, connection, and a discovered / attached / discarded state.
- Cloud text (names, descriptions, tags) is untrusted. Return it under the untrusted-text marker over MCP, as Inventory does.
- Real-account check: run the reader locally with `--profile staging` (account 463040245339; memory: AWS staging profile reader check). Create a throwaway secret `compass-test/secrets-module` with a dummy value first.

**Chain:** on the chain (migration and API).

**Done when:**
- A local read against the staging AWS account lists `compass-test/secrets-module` with its dates and tags, and the log and the database hold no value.
- On staging, in E2E Test Company, a seeded Discovered entry can be made into a secret, added to one, discarded and restored.
- The live read is **Couldn't check** in pre-UAT (E2E Test Company has no connections). Steve checks the Discovered tab on a company with the staging AWS account connected, after re-applying the policy.