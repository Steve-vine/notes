---
id: 01M34Y77T2T2XKFFJA1YRG7VN8
created: 2026-09-22T16:12:12.994078Z
updated: 2026-09-22T20:17:17.092151Z
type: task
title: Connect Compass to Exchange Online
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 738
sprint: s3nfes0
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The Access Control module governs users and groups; the next thing people ask it to govern is **shared mailboxes** — who can open one, who can send as one. The pain point today is adding and removing people, which needs an Exchange admin and a command. This task is the connection; the mailboxes themselves come in the tasks that follow.

**Carries an ADR: how Compass talks to Exchange Online.** Graph has no API for mailbox permissions. Exchange's admin surface is reachable app-only only through the `ExchangeOnlineManagement` PowerShell module (Microsoft-supported); the REST endpoint underneath it is undocumented and rejected as a foundation. So the **worker image gains `pwsh` and the module**, and a small Exchange client wraps the handful of cmdlets we need (`Get-EXOMailbox`, `Get-EXOMailboxPermission`, `Get-EXORecipientPermission`, `Add-/Remove-MailboxPermission`, `Add-/Remove-RecipientPermission`). Only the JML execution task may call a mutating cmdlet — the ADR 0045 §5 "one write path" property extends to Exchange, grep-provable. A session costs ~10–20 s to establish, so a task run opens one and reuses it.

**Identity and least privilege.** Certificate-based app-only auth on the existing `compass-access` app registration: the `Exchange.ManageAsApp` application permission (Office 365 Exchange Online, admin consent), and an Exchange **RBAC-for-applications** role assignment — `Mail Recipients`, scoped by a management scope to `RecipientTypeDetails -eq 'SharedMailbox'`. Compass cannot read or touch a personal mailbox even if asked to. The certificate is a Kubernetes secret via Helm values, never in the repo.

**In the app.** Exchange settings sit beside the Entra connection on the Integrations screen with their own health card (configured → connected → last successful read); "test connection" counts the shared mailboxes it can see. Absent configuration means the mailbox screens say so rather than showing an empty library.

**Setup on Steve's side**, written into `scripts/entra/README.md`: generate the certificate, upload the public half to the app registration, grant and consent `Exchange.ManageAsApp`, run `New-ManagementScope` + `New-ManagementRoleAssignment -App … -Role "Mail Recipients"` (needs a one-off interactive Exchange admin session), put the private key in the secret.

Hybrid note: Exchange reports whether each mailbox is synchronised from on-prem (`IsDirSynced`). The two permissions we manage are cloud-owned either way; the flag is recorded and shown for information.