---
id: 01M3H708MAZ3PFZE12TQNQE0DV
created: 2026-09-27T10:36:34.826927Z
updated: 2026-09-27T10:36:34.826927Z
type: task
title: AD only — Compass runs with no Entra ID and no Microsoft 365
label: feature
priority: medium
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 784
---
Part of the on-premises AD sprint (ADR in COM-773). Steve kept this in sprint 63 (2026-09-27).

## What people see

- **With the setup set to AD only, Compass needs no Entra connection at all.** Access Control works from AD: users, groups, lists, OUs, business roles, joiners, movers and leavers, ad-hoc requests, reviews, to-dos, unrequested-change detection and the access graph.
- **Screens that only exist in the cloud are not shown**, rather than showing empty or erroring: sign-ins, MFA methods, applications, Conditional Access, directory roles, devices, shared mailboxes and Microsoft 365 groups. The Integrations page says why. Reports and dashboard tiles that need cloud data say "not available in AD only".
- **No SSO.** Compass sign-in is **local accounts only**, and the SSO settings say so. People Compass creates for itself, such as review owners and asset owners picked from the directory, get a local account and an invitation to set a password.
- **A joiner is finished as soon as their AD account is made.** There is nothing to wait for.

## Notes (technical)

- Remove the hard gate "Entra ID access is not configured" in `execute_access_request`, recert removal and the converted-step sweep. Gate on the setup's required connections instead.
- The frontend reads the setup from one endpoint and hides routes and tabs. Keep hidden screens reachable by URL only as "not available in this setup", never as a crash.
- **Compass users provisioned from the mirror** (ADR 0046, portal reviewers, inventory owners). Verify that the local-account path covers them: `User.password_hash` and `/auth/login` exist, but check for an invite / set-password flow and whether one is needed.
- **Beat tasks.** Entra/Graph tasks (sync, sign-in and auth-methods sweeps, `entra_health`, mailbox sync, `exchange_health`) skip cleanly in AD only, and System status shows them as "not used in this setup", not as failing.
- **An end-to-end integration test with no Entra configured**, against the Samba DC: joiner, mover, leaver, review removal and detection.

**Done when:** a fresh install set to AD only, pointed at a test domain, runs a joiner → mover → leaver and a review, with no errors anywhere and no cloud-only screens showing. A local account can sign in and act.