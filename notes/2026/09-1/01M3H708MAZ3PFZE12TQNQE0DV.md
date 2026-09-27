---
id: 01M3H708MAZ3PFZE12TQNQE0DV
created: 2026-09-27T10:36:34.826927Z
updated: 2026-09-27T17:05:03.311209Z
type: task
title: AD only — Compass runs with no Entra ID and no Microsoft 365
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 784
sprint: sme8esk
blocked_by:
- 01M3H6ZCFZ927D0QNHF7B6168J
- 01M3H6ZM54J5P8M4GKE43TFGNS
- 01M3H6ZZB77X5K1T2BJ0RA5B6N
comments:
- id: 01M3HX7J4HTYQCERBQ6YTDM843
  author: Steve Vine
  at: 2026-09-27T17:05:02.609169Z
  text: |-
    Done — PR #794 (stacked on #793).

    With the setup on AD only:
    - Joiners are made in the role's OU with their AD groups and are finished at once, with nothing to wait for. Membership changes, leavers and review removals are made in AD. Nothing fails with "Entra ID access is not configured".
    - The Entra, Exchange, sign-in, MFA-method and mailbox jobs stand down, even if Entra credentials are still saved.
    - Microsoft sign-in is never offered. People Compass creates from the directory get local accounts, so "Forgot password?" works for them.
    - Access Control hides shared mailboxes, devices, directory roles and Conditional Access. A bookmark to one of them says "Not available in this setup".
    - Admin ▸ Integrations: the Entra ID, Exchange and sign-in cards say "Not used in AD only" and why. Their settings are kept for a later move to Hybrid.

    Tests: an end-to-end run with no Entra configured (joiner → membership change → leaver, all in AD, no to-dos; the Entra sync stands down; SSO off), plus UI tests for the hidden tabs and the Integrations notes.

    Not done here: dashboard and report tiles that need cloud data don't yet say "not available in AD only". They show empty, which is harmless. A follow-up if you want it.
assignee: steve
label:
- feature
priority: medium
task_status: review
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