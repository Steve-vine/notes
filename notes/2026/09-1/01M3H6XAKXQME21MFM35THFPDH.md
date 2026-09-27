---
id: 01M3H6XAKXQME21MFM35THFPDH
created: 2026-09-27T10:34:58.557729Z
updated: 2026-09-27T11:08:21.234472Z
type: task
title: Every person and group has one Compass record — ready for a directory that isn't Entra
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 775
sprint: sme8esk
blocked_by:
- 01M3H6WFYD0APAYJZEZYSG6S25
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of the on-premises AD sprint (ADR in COM-773). This is the groundwork the rest of the sprint depends on.

**Nothing changes on screen.** Today Compass identifies every person and group by their Entra ID. That doesn't work for AD only, and it would split a person in two when an estate moves between setups. After this task, each person and group has **Compass's own record**, with their Entra identity attached now and their AD identity attached by COM-777. Everything that points at a person or group points at that record:
- roles and role holdings
- requests and their history
- reviews
- to-dos
- the change ledger
- sign-in (SSO) group mappings
- shared mailboxes and their access

## Notes (technical)

- **Tables to rekey.** `directory_users`, `directory_groups` and the edge tables (`directory_group_members`, `…_nested_members`, `…_owners`, device/contact members, `directory_device_owners`). Every FK into them: `business_role_groups`, `governed_memberships`, `directory_user_business_roles`, `access_changes`, `access_manual_steps`, `recert_*`, `sso_group_role_mappings`, `shared_mailboxes` / `shared_mailbox_access` (`principal_id`), `governed_mailbox_access`, and inventory holders. Sweep for every `String(64)` Entra id column.
- **Anchors.** Add `entra_id` (unique, nullable) and room for `ad_object_guid`, `ad_sid`, `ad_dn` and `ad_sam_account_name` (populated by COM-777).
- **Graph `$select`.** Add `onPremisesImmutableId`, `onPremisesSecurityIdentifier`, `onPremisesDistinguishedName` and `onPremisesSamAccountName` for users and groups. This bumps the select version, which forces a full crawl. (See the memory on Graph delta `$select`: on delta it declares what is tracked.)
- **API ids and URLs.** Screens route on ids, e.g. `/access/users/{id}`. Choose between keeping Entra ids in the API while they exist and exposing the new key. Record the choice in the PR, and regenerate `schema.d.ts`.
- **Migration risk.** CI never migrates a populated DB (memory: *migrations fresh-DB blind spot*). Reproduce against a copy of staging's data before deploying. Use raw SQL for evolving tables in migration tests. Revision ids must be ≤32 characters. May split into stacked PRs (mirror first, then each dependant).
- **Live Graph calls** (`_memberships_of`, adopt-by-UPN, the leaver's sync read) translate between key and `entra_id` at the edge.

**Done when:** the full suite is green, and staging upgrades from its populated database with every role, holding, provenance row, review, to-do and ledger entry intact. Screens are unchanged, and the next Entra sync matches every existing record (no duplicates).