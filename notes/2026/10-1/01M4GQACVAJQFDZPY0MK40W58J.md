---
id: 01M4GQACVAJQFDZPY0MK40W58J
created: 2026-10-09T16:18:11.434411Z
updated: 2026-10-10T14:10:57.303813Z
type: task
title: An Inventory admin connects an AWS account to a company with a read-only role — tests it, sees its health, and can remove it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 882
sprint: svsqcj9
blocked_by:
- 01M4GQ9TBFA5WJVG5KRKNECC6W
comments:
- id: 01M4K2E2171NZ04NT4MAXEYF96
  author: Steve Vine
  at: 2026-10-10T14:10:54.631255Z
  text: |-
    Merged to main (PR #890, 2026-10-10). On staging once the sprint's ten tasks are all in Review.

    What to look at:
    - Inventory ▸ Settings ▸ AWS accounts. Add account asks for the account number, a name, the role (leave blank for the one the template creates), Production or Non-production, and regions (empty = every enabled region).
    - After adding, a "Set up in AWS" window opens: Compass's AWS identity and the external ID to copy, a button that downloads the role template, and Test.
    - Each row shows health and when it was last read, with Set up and test, Edit and Remove. Remove asks first and says what happens to what was found.
    - Admin ▸ Integrations ▸ AWS identity (last card). It says "Using this deployment's own identity", or takes an access key once. The key can be replaced or forgotten, never read back. Test connection says who AWS thinks Compass is.

    Needed from you before this can be smoke-tested on staging:
    1. An access key for Compass's own identity (an IAM user whose only permission is sts:AssumeRole on the discovery roles), entered on the AWS identity card. Staging has no identity of its own.
    2. An AWS account to connect, with the role created in it from the template. The steps are in docs/aws/README.md.

    Do the identity card first: the role has to trust that identity, so the account's set-up window shows it only after the card's Test has passed.

    One thing differs from the task text. Test cannot tell "the role does not exist" from "the role does not trust Compass" from "the external ID does not match". AWS deliberately gives the same refusal for all three, so the message names the three and leaves you to check. "Compass has no identity yet", "the key was rejected", "the role is in a different account" and "the role may not list regions" each get their own message.

    Also: the external ID is fixed for the life of a connection. Removing an account and adding it again generates a new one, and the role must be updated to match.

    Technical: migration 0232 (aws_connections, aws_identity_settings). core/aws.py is the single client factory. docs/aws/ holds the policy and CloudFormation template, generated from code and held in step by a test. A health check runs every 15 minutes and is the same check as Test. Activity log records add, change and remove; health checks leave no entries.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of sprint 67, Inventory expansion (ADR in COM-881). This is the connection only. Nothing is read from the account until the next task.

## What people see

- **Inventory ▸ Settings gains "AWS accounts"** for the current company: a list of connected accounts with a name, the account number, a health pill and when each was last read.
- **Adding an account asks for** the account number, a name, the role Compass should use, whether the account is Production or Non-production, and which regions to read (all enabled regions unless some are chosen).
- **Compass shows what to set up on the AWS side:** an external ID to copy, and a ready-made template that creates the read-only role. The role can list and describe resources. It cannot read what is inside them.
- **Test** says which account it reached, or why it could not, in plain words: the role does not exist, the role does not trust Compass, the external ID does not match, or Compass has no AWS identity of its own yet.
- **Removing an account asks first** and says what happens: resources already attached to technology assets stay and are marked "no longer read"; anything still awaiting a decision goes.
- **Admin ▸ Integrations gains an "AWS identity" card:** either "using this deployment's own identity", showing which one, or an access key entered once. The key can be replaced but never read back.
- **Who:** Inventory admins for accounts; system admins for the identity card.

## Notes (technical)

- **`aws_connections`**, company-scoped, the usual UUID / Timestamp / Actor mixins.
  - `account_id` (12 digits, unique across the deployment: an account belongs to one company), `name`, `role_arn`, `external_id` (generated server-side, unguessable, never accepted from the client), `default_environment`, `regions` (JSONB, null = all enabled), `last_synced_at`.
  - `health`, `health_checked_at`, `health_message` in the `EntraSettings` shape.
- **`aws_identity_settings`**, a singleton in the attachment store idiom (`models/attachment_store_settings.py`). `credentials_encrypted` through `core.secretbox`; null means the SDK's own credential chain. Write-only through the API.
- **`core/aws.py`: one client factory**, `client(connection, service, region)`.
  - STS `AssumeRole` with the external ID, session name `compass-discovery`, credentials cached until shortly before expiry.
  - botocore standard retry mode and explicit timeouts.
  - Every AWS call in the sprint goes through it. This is the test seam.
- **Health.** `sts:GetCallerIdentity` under the assumed role, then the account's enabled regions.
  - A beat task in the shape of `tasks/entra_health.py`, every 15 minutes.
  - botocore error codes map to the plain messages above. Credentials never reach a log line; check the redaction list covers the new field names.
- **The shipped policy.** `docs/aws/` carries the IAM policy JSON and a CloudFormation template that takes Compass's principal and the external ID as parameters.
  - It names List / Describe actions explicitly. Not `ReadOnlyAccess`.
  - This task ships the STS and region actions; each reader task adds its own.
- **API.** `/api/v1/inventory/aws-connections` (list, create, update, delete, test) under `inventory.admin`; the identity card beside the other integrations in `api/v1/integrations.py`. Regenerate `schema.d.ts` and run the drift script.
- **Activity log** entries for add, change and remove.
- **Chart.** `values.yaml` already documents the `eks.amazonaws.com/role-arn` annotation for S3. Say that the worker's service account needs it too, since reads run there.
- **Screen.** A section on the Inventory Settings panel in `InventoryPage.tsx`; the identity card in `admin/IntegrationsSection.tsx`. Screen conventions apply (pills never truncate, `w="fit-content"` on any switch or checkbox).
- **Tests.** Integration tests on real Postgres with the client factory faked. Fixtures must not contain anything shaped like a real AWS key; gitleaks scans the branch history.

**Needs from Steve before smoke-testing:** an AWS account to connect on staging with the role created in it, and an access key for Compass's own identity on g5.

**Done when:** on staging an AWS account is connected to a company, Test names the account, the health pill is green, and removing the account works.