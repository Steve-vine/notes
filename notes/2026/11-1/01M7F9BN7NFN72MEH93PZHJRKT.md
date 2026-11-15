---
id: 01M7F9BN7NFN72MEH93PZHJRKT
created: 2026-11-15T09:42:03.765267Z
updated: 2026-11-15T11:41:23.383046Z
type: task
title: Microsoft 365 evidence comes from a read-only Microsoft Graph Collection integration
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1838
sprint: spsp226
blocked_by:
- 01M7F9BCSDAHHXAF5SW66GZK72
comments:
- id: 01M7FG626WGAEQNESMY69VBV8D
  author: Steve Vine
  at: 2026-11-15T11:41:20.476287Z
  text: |-
    Built and merged — PR #1836 (e82aa4aa). Independent: no migration, no API change.

    What you'll see:
    - A Microsoft Graph Collection integration can be set up on screen (by hand or with Add with Polaris). It signs in as its own read-only app registration. No code knows Graph.
    - **One integration covers every tenant.** Each account gives its own "Directory or tenant", plus client ID and secret. The Accounts form asks for the tenant only when the integration's token address needs one, and won't save an account without it.
    - Paging past the first page, reads under /v1.0 and /beta, waiting out throttling, and the ConsistencyLevel header all work.
    - **Setup guide** in the repo at docs/microsoft-graph/README.md:
      - the app registration steps;
      - the read-only permissions to grant: Directory.Read.All, RoleManagement.Read.Directory, Policy.Read.All, AuditLog.Read.All, Reports.Read.All, and Intune's DeviceManagementManagedDevices.Read.All only if devices are wanted. No ReadWrite permissions;
      - the definition to enter;
      - the reads a check makes: PIM eligible and active, Conditional Access, MFA registration, devices.

    Three things Graph needed couldn't be expressed before. Each is now a general capability, recorded in an ADR 0148 amendment:
    - a tenant placeholder in the token address;
    - field names that contain a dot;
    - following the next-page link exactly as given.

    The check that keeps service names out of collection code now also refuses Graph's addresses.

    Tests: a fake Graph covers sign-in per tenant, a wrong secret (Microsoft's message shown), PIM paging past page 1, Conditional Access, MFA registration under /beta with throttling, and one token per run. An end-to-end test on real Postgres defines the integration through the API and runs the PIM and Conditional Access reads.

    Not done:
    - A rolling date window inside a filter isn't expressible yet. Sign-in and audit logs will need it; it's recorded in the ADR and the guide.
    - There's no screen to add a tenant to an account that already exists. Only new accounts get the field.

    **Needs you before it can be proved on staging:**
    1. In each tenant, an app registration with only the read-only permissions above, and admin consent.
    2. Once staging has this build, either you or I define the integration from the guide. Then add E2E Test Company's account with the tenant ID, client ID and secret.

    After that I can run the Done-when checks: the ACC.12 PIM check, Conditional Access, MFA registration and paging. Microsoft accepting the client secret the way Compass sends it is supported per Microsoft's docs, but only a real tenant proves it.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
## What happened

This follows from the ADR on read-only evidence. Steve asked Polaris to get PIM information for ACC.12. Polaris said it couldn't read Graph and suggested a Microsoft Graph Collection integration. Under the new rule, that's the right home for all Microsoft 365 evidence: an app registration with read grants only, separate from Access Control's read-write registration.

## What people see

- **A Microsoft Graph Collection integration is set up on screen**, like any other, with Polaris able to help as it can today. It signs in as its own app registration with client credentials and reads under `/v1.0` and `/beta`, following Graph's own paging.
- **A short setup guide** on the integration (its description and docs link) lists the read-only permissions to grant: Directory.Read.All, RoleManagement.Read.Directory (PIM eligible and active assignments), Policy.Read.All (Conditional Access), AuditLog.Read.All, Reports.Read.All (MFA registration), and the Intune read permissions if devices are wanted. It names none of the ReadWrite ones.
- **Polaris designs Microsoft 365 checks from it.** With COM-1835, the integration's "What we use it for" ticks say which areas it's for.
- **No code knows Graph** (ADR 0147 §9). If something Graph needs can't be expressed, it becomes a general capability in the configuration language.

## Done when

- On staging, a Microsoft Graph Collection integration with a read-only app registration is set up, and E2E Test Company has an account on it.
- A check designed for ACC.12 reads PIM role eligibility (`roleManagement/directory/roleEligibilityScheduleInstances`) through it, and the sample shows real assignments.
- Conditional Access policies and MFA registration also read through it.
- Paging past the first page works.
- Any capability added for it is general and has tests. The ADR 0147 §9 test still passes.

**Needs Steve:** an app registration in each tenant with the read-only grants above, and admin consent.

**Independent** unless a new capability turns out to need an API change. Blocked by the ADR task.