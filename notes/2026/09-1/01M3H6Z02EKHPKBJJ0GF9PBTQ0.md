---
id: 01M3H6Z02EKHPKBJJ0GF9PBTQ0
created: 2026-09-27T10:35:53.294588Z
updated: 2026-09-27T13:31:38.103591Z
type: task
title: Leavers are finished in AD by Compass — disabled at once, deleted on schedule, details corrected
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 780
sprint: sme8esk
blocked_by:
- 01M3H6YBYE6S45M1W17WDMRA0W
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of the on-premises AD sprint (ADR in COM-773). The account to-dos from COM-763 become things Compass does.

## What people see

- **A leaver whose account lives in AD** (inside a managed OU) is **disabled in AD by Compass** straight away. The urgent to-do no longer appears.
  - In hybrid, sign-in sessions are still revoked in Entra.
  - The leaver shows as **Disabled in AD — Entra follows at the next sync (up to 30 minutes)** until the cloud account catches up. After that, it shows as plainly disabled.
- **A scheduled delete** (ADR 0066) deletes the account in AD on its date.
- **Corrections to account details** are made in AD, where today they are the `account_update` to-do. This covers name, job title, department, manager, office and phone.
- **The rule for what Compass can't do** (COM-773):
  - An account outside the managed OUs, or with AD not set up, becomes a to-do (**not set up**).
  - AD set up but the change fails means **Failed** with a reason and a **Retry** (**something broke**).

## Notes (technical)

- **Disable.** Read-modify-write the ACCOUNTDISABLE bit on `userAccountControl`. The branch points are `_execute_leaver`, `_delete_account` / `_delete_in_ad`, and the joiner amendment's `ACCOUNT_FIELDS_IN_MIRROR` split. Routing comes from COM-778's predicate before the write. An LDAP error fails the subject; it never raises a step.
- **The hybrid gap.** Graph refuses `accountEnabled=false` on a synced account. Between the AD disable and Entra Connect's next cycle, the cloud account is still enabled, and a refresh token can be re-issued after revocation. Say so on the leaver and in the ADR. Consider revoking sessions again when the sync lands, and note that Compass can't trigger Entra Connect's sync cycle.
- **Delete** is a real delete: the AD Recycle Bin, if enabled, is the undo. Say so in the confirm text.
- **Field map.** givenName, sn, displayName, title, department, `manager` (as a DN, resolved via the combined record), physicalDeliveryOfficeName and telephoneNumber.
- Idempotent: an already-disabled account is success.

**Done when:** on staging, a leaver on an AD account is disabled in AD within one run, shows the "Entra follows" state, and then shows as plainly disabled after the sync. A scheduled delete removes the account from AD. An account-detail correction lands in AD and reaches Entra.