---
id: 01M8FAVGBYEAE17CNZBWV1KZEE
created: 2026-11-27T20:23:53.470049Z
updated: 2026-11-28T00:07:44.226796Z
type: task
title: 'Server configuration checks: thirteen built-in checks modelled on the CIS Windows Server benchmark, run through the agent, with per-company settings, results per server, evidence on their controls and a gap when one fails'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2207
sprint: smfrbak
blocked_by:
- 01M8FATYW6WHD4TY9MEYW1K252
assignee: steve
label:
- feature
priority: high
task_status: active
---
**On the chain** (checks, settings, API). ADR 0187 §8. After COM-2206. Linux rules follow in COM-2210.

## What people see
- **Checks** gains a **Servers** group of built-in checks (CHB numbers, linked to the right library controls), each run against every reporting Windows server of the company at each inventory read:
  1. The system drive is encrypted (BitLocker).
  2. **Host firewall is on** (Windows Firewall on for every profile). *Cross-platform: COM-2210 adds its Linux rule.*
  3. SMBv1 is off.
  4. The Guest account is disabled.
  5. **Administrators hold only allowed members** (the local Administrators group). *Cross-platform.*
  6. **Minimum password length** is at least the company's value (default 14). *Cross-platform.*
  7. Account lockout is on, at no more than the company's attempts (default 10).
  8. Remote Desktop, where on, requires Network Level Authentication.
  9. Microsoft Defender is on, with signatures no more than the company's days old (default 7).
  10. TLS 1.0 and 1.1 are off for the server's own services.
  11. The Print Spooler is off (unless the server is marked as a print server).
  12. **An update has been installed within the company's days** (from COM-2206). *Cross-platform.*
  13. **Coverage:** every server the directory found in this company's scope reports through the agent. A server with no agent, or Not reporting, fails.
- Each check shows **passes / fails per server**, with what was seen ("Firewall off for the Public profile"). A failure raises its own gap (ADR 0159); the result becomes evidence on its controls like any built-in check (ADR 0158), including in audit packs and the SoA/Coverage report.
- Until COM-2210 lands, a Linux server reads **Not checked yet** for the cross-platform checks and **Doesn't apply** for the Windows-only ones — never a fail.
- **Per-company settings** for the values above (allowed local administrators as names or SIDs, password length, lockout attempts, signature age), under the Servers check group or the agent's discovery settings, whichever fits the checks screens.
- On a server's page, a **Configuration** section lists the checks with pass/fail.
- **Mark as print server** on a discovered server (for check 11), recorded in the activity log.
- No check can be written on screen in this sprint (ADR 0187 §8).

## Notes (technical)
- Declare the checks in `core/checks/` (new `servers.py` group in `_declared`, ADR 0132). Each check = code-defined osquery query + pass rule; queries go out with the inventory set (COM-2205) so results arrive together.
- **Build the four cross-platform checks with a rule per platform** (keyed on the server's reported platform), so COM-2210 adds a Linux rule without a new check. A check with no rule for a platform reads Not checked yet (cross-platform) or Doesn't apply (platform-only).
- Windows sources to try (verify each on a real Server 2019/2022): `bitlocker_info`, `windows_firewall_rules` / registry `HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\*Profile\EnableFirewall`, `windows_optional_features` (SMB1Protocol), `users`, `groups`/`user_groups` (local Administrators SID S-1-5-32-544), registry for password/lockout policy, registry `...\Terminal Server\WinStations\RDP-Tcp\UserAuthentication`, `windows_security_products` / Defender registry for signature age, SCHANNEL registry for TLS, `services` (Spooler). Where a fact can't be read reliably, the check reads **Couldn't tell** rather than pass.
- Map controls to existing library controls (encryption, network security, hardening, privileged access, malware, patching, inventory). Tests that pin the number of built-in checks and their control links will need updating.
- Results kept per server per run like other built-in checks' results.

**Done when:** in CI, each check's pass rule is tested against recorded osquery output from a compliant and a non-compliant Windows server; on staging the Servers group lists the checks, the coverage check fails for directory servers with no agent and raises a gap, and the Linux test rig reads Not checked yet / Doesn't apply (never a fail). Steve checks real results on a Windows server (Couldn't check for me).