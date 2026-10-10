---
id: 01M4GQEEQGT8TEKRXZGW2V9WW3
created: 2026-10-09T16:20:24.432503Z
updated: 2026-10-10T16:23:16.734359Z
type: task
title: An AWS organisation is connected once — its accounts are listed, each is switched on for a company, and a new account does not go unread unnoticed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 890
sprint: svsqcj9
blocked_by:
- 01M4GQACVAJQFDZPY0MK40W58J
comments:
- id: 01M4KA0AKV1JEDJKFEB4J0SKZB
  author: Steve Vine
  at: 2026-10-10T16:23:13.275246Z
  text: |-
    Merged to main (PR #898, 2026-10-10). The last of the ten; staging is deployed next.

    What to look at, under Inventory ▸ Settings:
    - A new AWS organisations card, below AWS accounts. Connect an organisation asks for a name, the management account number (or a delegated administrator's), the role to use there (blank for the one the template creates), and the name of the read-only role present in every member account.
    - After connecting, a set-up window shows Compass's AWS identity and the organisation's external ID to copy, downloads both role templates, and explains how to put the member role in every account at once. List accounts there is also the test.
    - Every account is then listed with its number and one of: "New, not read", "On for" a company, "Left off" with the reason and who, or what AWS says if it is suspended, closed or no longer in the organisation.
    - Switch on picks the company and Production or Non-production. The account then appears under AWS accounts like any other and is read on the next pass.
    - Leave off asks for a reason. It can be switched on later.
    - An account that appears in the organisation later shows as new, and Inventory admins get an action ("An AWS account in … is new and not read") until someone decides.

    Behaviour worth knowing:
    - An account already connected one at a time is recognised and shown as on. It is not duplicated and keeps its own set-up.
    - Accounts switched on from an organisation all share the organisation's external ID, because one template is rolled out to all of them.
    - To stop reading an account that is on, remove it under AWS accounts (that is where it says what happens to what was found). It then shows as left off, not as new.
    - Removing the organisation stops the listing only. Accounts already switched on stay connected.
    - If the listing fails, nothing is changed and the card says why.

    Two things differ from the task text:
    - A suspended or closed account is marked and no longer read, but its connection is left in place for a person to remove. AWS can reverse a suspension for 90 days, and removing the connection would discard what was awaiting a decision.
    - Permissions in Compass are not per company, so "a company the person is an Inventory admin of" is any company that is not archived.

    Needed from you before this can be smoke-tested: a role in an organisation's management or delegated administrator account, made from the organisation template. Without one this has only been proved against a made-up organisation in the tests.

    Technical: migration 0239 (aws_organisations, aws_organisation_accounts, aws_connections.organisation_id). The management role can do two things only: describe the organisation and list its accounts. docs/aws/README.md has the steps, including the StackSet. The e-mail address AWS returns with each account is not kept. New action type inventory_aws_accounts_undecided.
assignee: steve
label:
- feature
priority: low
task_status: review
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