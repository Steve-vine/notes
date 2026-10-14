---
id: 01M4XWBK2A4SSBQJ239FZH35WN
created: 2026-10-14T18:56:21.066291Z
updated: 2026-10-14T18:56:25.890937Z
type: task
title: Compass's Exchange app holds Exchange Administrator — the setup page says so, and Test connection warns when lists can't be changed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 958
sprint: s192kdq
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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