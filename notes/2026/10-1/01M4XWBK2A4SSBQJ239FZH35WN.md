---
id: 01M4XWBK2A4SSBQJ239FZH35WN
created: 2026-10-14T18:56:21.066291Z
updated: 2026-10-15T14:46:00.085029Z
type: task
title: Compass's Exchange app holds Exchange Administrator — the setup page says so, and Test connection warns when lists can't be changed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 958
sprint: s192kdq
comments:
- id: 01M4XXWD43ABVYZSPDNQ491YH6
  author: Steve Vine
  at: 2026-10-14T19:23:00.611766Z
  text: |-
    Done — PR #951, merged to main. Not on staging yet; waiting for your go.

    What it changes:
    - **Test connection** now also checks that Compass can change lists. Until Exchange Administrator has reached Exchange (or with only Recipient Administrator), it goes red with: "Connected to …, but Compass can't change distribution lists it doesn't own — the application needs the Exchange Administrator role. A role just given can take up to an hour to reach Exchange; test again then". Once it's green, the two refused requests can be retried.
    - **A refused list change** says that in plain words, instead of PowerShell's "parameter cannot be found".
    - **The setup page** names Exchange Administrator, explains why Recipient Administrator isn't enough, and how to move a tenant off it.
    - **ADR 0107** records your choice. Compass still only writes shared mailboxes and governed lists, and only what a role maps; with the wider role, that's now the whole boundary.

    Checked on staging today: Exchange Administrator is active on "Compass ITP - EntraID Access Control" (the app Compass signs in as), and no app holds Recipient Administrator any more. The 18:59–19:03 retries were most likely before Exchange had picked the role up.
- id: 01M4Y498W3A2C2BXRBX8XNFTR0
  author: Steve Vine
  at: 2026-10-14T21:14:53.699719Z
  text: |-
    Resolved on staging: Test connection went green at 21:14 UTC.

    What fixed it, in order:
    - The Entra role Exchange Administrator was given to the app before ~18:45. More than two hours later it still hadn't exposed the override. App-only sessions seemingly don't get it through the Entra role, or not reliably.
    - At ~20:20 Steve ran, in Azure Cloud Shell: `New-ServicePrincipal` for the app, then `New-RoleGroup "Compass - list changes" -Roles "Security Group Creation and Membership" -Members "Compass"`. Checked with Get-RoleGroupMember / Get-ManagementRoleAssignment. It reached Exchange about 50 minutes later.

    So the setup page needs one more step: the Exchange role group, not just the Entra role. That goes into a follow-up once the two retried requests are confirmed.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Found in the COM-954 smoke test (Steve, 2026-10-14). Abu Darby, Attendance Hotline:
- *Can send as* applied.
- *Add to the list* was refused: "A parameter cannot be found that matches parameter name 'BypassSecurityGroupManagerCheck'".
- *Can send on behalf* was refused the same way.

**Why.** Only a list's owners may change its members or its send-on-behalf; anyone else needs an override. Exchange Recipient Administrator doesn't include that override (the *Security Group Creation and Membership* role), and Exchange hides it from anyone without it. So list membership (COM-764, since September) and send on behalf (COM-954) never worked on this tenant. Send as is a permission kept apart from the list's settings, so it was unaffected.

**Steve's decision (2026-10-14):** the app holds the Entra role **Exchange Administrator**, with future requirements in mind. Exchange Recipient Administrator is removed once Exchange Administrator is confirmed working.

## What people see

- **Admin ▸ Integrations ▸ Exchange Online ▸ Test connection** says whether Compass can change lists. If the override is missing, it says so in a sentence, naming the role to add, and doesn't just go green.
- **A refused list change says what's wrong** instead of PowerShell's words: "Compass's Exchange connection isn't allowed to change lists it doesn't own — it needs the Exchange Administrator role (Admin ▸ Integrations)".
- **The setup page** (scripts/exchange/README.md) names Exchange Administrator, says why, and says Recipient Administrator can be removed.

## Notes (technical)

- **New ADR** superseding ADR 0078's choice of role; next free number is 0107. It amends ADR 0080's and ADR 0106's "no further setup is needed for lists". It notes Compass still refuses writes outside shared mailboxes and governed lists, and that this is now the only boundary.
- `test_connection.ps1`: report whether `Add-DistributionGroupMember` exposes `BypassSecurityGroupManagerCheck`, via `(Get-Command …).Parameters.ContainsKey(…)` after connecting with that cmdlet in `-CommandName`. `check_exchange_connection` turns `lists_writable: false` into the warning sentence.
- `set_list_membership.ps1` / `set_list_rights.ps1`: catch the missing-parameter error and reply with the plain sentence above, so it's a refusal Compass explains.
- Parse-check the scripts locally with pwsh; the first real run is staging.

**Done when:** on staging, Test connection is green with no warning under Exchange Administrator, and the two refused requests succeed on Retry.