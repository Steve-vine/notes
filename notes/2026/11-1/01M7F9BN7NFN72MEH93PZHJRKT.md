---
id: 01M7F9BN7NFN72MEH93PZHJRKT
created: 2026-11-15T09:42:03.765267Z
updated: 2026-11-15T09:42:03.765267Z
type: task
title: Microsoft 365 evidence comes from a read-only Microsoft Graph Collection integration
priority: medium
task_status: todo
assignee: steve
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1838
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