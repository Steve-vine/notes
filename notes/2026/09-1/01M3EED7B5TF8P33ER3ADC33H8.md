---
id: 01M3EED7B5TF8P33ER3ADC33H8
created: 2026-09-26T08:48:16.229455Z
updated: 2026-09-26T12:39:19.20725Z
type: task
title: Exchange setup says what actually works — Compass holds Exchange Recipient Administrator, and keeps its own writes to shared mailboxes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 755
sprint: s3nfes0
comments:
- id: 01M3EMACN0WWGEGX21A538Z9SR
  author: Steve Vine
  at: 2026-09-26T10:31:34.81597Z
  text: |-
    Done: PR #768, merged to main as 7ce7645.

    - Tenant setup (scripts/exchange/README.md): step 3 is now a single Entra role on compass-access, Exchange Recipient Administrator, assigned Active and permanent. It no longer needs an Exchange PowerShell session. If a tenant was set up from the old step 3, the assignment it created does nothing and can be removed. The "isn't supported in this scenario" troubleshooting line points to step 3, and notes that a new role can take a few minutes to reach Exchange. The az section gains the same assignment through Graph.
    - Compass now enforces shared-only itself. A grant or revoke aimed at a mailbox that isn't shared is refused before it reaches Exchange. Compass checks twice: against its own mailbox list, and against Exchange by the write script just before each write, because the list can be an hour old. The request or review row fails with "Refused by Compass: <mailbox> (can open): not a shared mailbox…". Other changes in the same request still go through and are recorded.
    - ADR 0078 replaces ADR 0075 §4. ADR 0075 is unchanged.
    - Tests use the fake Exchange: a mailbox that has dropped off Compass's list is never sent, and a mailbox Exchange reports as a user mailbox is refused and reported as Compass's refusal. I also ran the script's own check against a local PowerShell with stand-in commands.
assignee: steve
label:
- follow_up
priority: medium
task_status: done
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