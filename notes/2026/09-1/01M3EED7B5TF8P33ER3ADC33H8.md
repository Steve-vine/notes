---
id: 01M3EED7B5TF8P33ER3ADC33H8
created: 2026-09-26T08:48:16.229455Z
updated: 2026-09-26T09:52:41.704978Z
type: task
title: Exchange setup says what actually works — Compass holds Exchange Recipient Administrator, and keeps its own writes to shared mailboxes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 755
sprint: s3nfes0
assignee: steve
label:
- follow_up
priority: medium
task_status: active
---
Follow-up to COM-738, found connecting staging on 2026-09-26.

**What happened.** The tenant setup in `scripts/exchange/README.md` step 3 gives Compass its Exchange rights with an RBAC-for-Applications assignment (`New-ManagementRoleAssignment -App … -Role "Mail Recipients"` inside a `SharedMailbox` management scope). App-only *PowerShell* doesn't use that route. Without a supported role, sign-in fails with *"The role assigned to application … isn't supported in this scenario"*. Microsoft's app-only guide offers either an Entra directory role on the app, or a custom Exchange role group that contains the service principal.

**Decision (Steve).** Compass gets the Entra role **Exchange Recipient Administrator** on `compass-access` (Active, permanent), and **no Exchange-side scope**. A coming sprint converts user mailboxes to shared, which needs to write to non-shared mailboxes. Compass can already delete users, so this breadth is in keeping with that. Staging is set up this way and green: 270 shared mailboxes read on 2026-09-26.

**What changes.**
- **An ADR** (next free number) superseding ADR 0075's identity/least-privilege section. It records the role, the reason, and that "shared mailboxes only" moves from Exchange to Compass. ADR 0075 itself is not edited.
- **`scripts/exchange/README.md`**: step 3 becomes the Entra role assignment (portal steps, the PIM Active/permanent note). The troubleshooting line for "role … isn't supported" points at it. The "What Compass will refuse" section stops claiming Exchange enforces shared-only. The `az` section gains the role assignment if there is a clean equivalent.
- **Compass enforces shared-only on writes.** Before granting or revoking, the change is refused unless the mailbox is a `SharedMailbox`. Check it in two places:
  - against the mirror, in the execution task
  - in `set_mailbox_access.ps1` itself (`RecipientTypeDetails -eq 'SharedMailbox'`), because the mirror can be up to an hour stale

  A refused change fails like any other failed change: visible, with a reason. The conversion task later relaxes this for the conversion step only.

**Done when:** a fresh reader can set up a tenant from the README first time. A grant aimed at a user mailbox is refused by Compass, which a test proves using the fake Exchange.