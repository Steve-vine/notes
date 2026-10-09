---
id: 01M4GQEEQGT8TEKRXZGW2V9WW3
created: 2026-10-09T16:20:24.432503Z
updated: 2026-10-09T16:20:24.432503Z
type: task
title: An AWS organisation is connected once — its accounts are listed, each is switched on for a company, and a new account does not go unread unnoticed
label: feature
task_status: backlog
assignee: steve
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 890
---
Part of sprint 67, Inventory expansion (ADR in COM-881). Accounts can already be connected one at a time. This connects the organisation above them, so the list of accounts is itself discovered.

## What people see

- **Inventory ▸ Settings ▸ AWS accounts gains "Connect an organisation".** It asks for the organisation's management account (or its delegated administrator), the role Compass should use there, and the name of the read-only role present in every member account.
- **Compass then lists every account in the organisation** with its name and number.
- **Each account is either switched on for a company or left off.** Switching one on makes it a connected account like any other, using the shared role name, and it is read from then on.
- **An account that appears in the organisation later shows as "New, not read"**, and Inventory admins get an action to switch it on or leave it off with a reason. This is the point of the task: a new account is not silently outside the register.
- **An account that has been closed or suspended** is marked, and its connection goes to "no longer read".
- **Accounts already connected one at a time are recognised** and shown as on, not duplicated.
- **Compass's template for the read-only role can be rolled out to every account at once** from the organisation; the screen says how.
- **Who:** an Inventory admin. An account can only be switched on for a company the person is an Inventory admin of.

## Notes (technical)

- **`aws_organisations`**: `organization_id`, `management_account_id`, `role_arn`, `external_id`, `member_role_name`, health columns, the usual mixins. Company-scoped by the company it was connected from, but its accounts may be assigned to other companies the acting user administers; check the permission against the target company on every switch-on.
- **`aws_organisation_accounts`**: `account_id`, `name`, `status` (as AWS reports it), `decision` (`on` | `off` | `undecided`), `off_reason`, `first_seen_at`. Switching on creates or links an `aws_connections` row (`organisation_id` nullable on it).
- **Reads.** `organizations:ListAccounts` and `organizations:DescribeOrganization` through the client factory in `core/aws.py`, on the same six-hourly cadence as discovery and before it in the same run, so a newly switched-on account is read in that run.
- **The shipped policy** gains a second, separate document for the management account role: the two Organizations actions only.
- **The template.** Document deploying the member-account template as a CloudFormation StackSet with service-managed permissions. Documentation only; Compass does not create anything in AWS.
- **The new-account action** is a declared action source in `core/actions/inventory.py` (ADR 0055) for `undecided` accounts. Do not write a notify().
- **`account_id` stays unique across the deployment** on `aws_connections`, which is what makes "already connected" detectable.
- **API.** `/api/v1/inventory/aws-organisations` and its accounts sub-route under `inventory.admin`. Stub the new sub-route explicitly in page tests. Regenerate `schema.d.ts` and run the drift script.
- **Tests.** Integration: listing, switch on for a second company with and without permission there, an already-connected account is linked not duplicated, a new account raises the action and deciding clears it, a suspended account. Vitest for the list and the switch.

**Needs from Steve before smoke-testing:** a role in an organisation's management or delegated administrator account. Without one this can be verified against the test fakes only.

**Done when:** on staging, an organisation is connected, its accounts are listed, one is switched on and read, and an undecided account shows as an action for Inventory admins.