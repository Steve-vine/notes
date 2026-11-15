---
id: 01M7F9BCSDAHHXAF5SW66GZK72
created: 2026-11-15T09:41:55.117431Z
updated: 2026-11-15T10:57:53.974143Z
type: task
title: 'ADR: evidence, checks and feeds read only through credentials that can''t change anything'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1837
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
## What happened

Steve, testing Checks (2026-11-14). Polaris suggested a separate Microsoft Graph Collection integration for PIM evidence, and that raised the question of permissions. Today, collected checks can read Microsoft 365 and Active Directory through the same connections Access Control uses, and those connections can change things: create users, change groups, and use delegated AD write rights. Compass's code keeps those reads read-only (`core/collection/core_reads.py`), but the credential itself could write. Every new kind of evidence (PIM, Intune, sign-in logs…) also pushes for another permission on the most powerful credential Compass holds. AWS, Azure and Google Cloud already follow the rule that Compass "must be unable to, not merely unwilling" (ADRs 0099, 0103, 0104). Microsoft 365 and AD are the exceptions.

## The decision to record

- **Connections are sorted by what their credential can do**, not by which screen sets them up.
  - **Can change things:** Microsoft 365 and Active Directory (for Access Control), SMTP, SendGrid and Amazon SES (sending mail), and S3 (Compass's own file storage). These are used only for the work that needs them, and never by a collected check, a feed or Polaris's design reads.
  - **Read only:** AWS, Azure, Google Cloud, every Collection integration, and Endoflife.
- **Evidence, collected checks and feeds read only through read-only credentials.**
  - Microsoft 365 evidence comes from a read-only Microsoft Graph Collection integration: its own app registration, granted read permissions only, set up on screen like any other.
  - Active Directory evidence comes from a separate read-only account on the AD connection, never the account with delegated write rights. AD has no web API, so it can't be a Collection integration.
- **What stays as it is:**
  - AWS, Azure and Google Cloud stay as Compass's own connections. They're already read-only, and Collection can't express AWS request signing or the discovery logic (ADR 0147 §9).
  - Directory sync stays Access Control's. Anything that reads Compass's own copy of the directory, such as Inventory's Entra devices, reads that copy and not the tenant, so it's unaffected.
- **Considered and rejected:** moving AWS, Azure and Google Cloud into Collection integrations. It would be tidier but costs several sprints, needs new sign-in capabilities, and reduces no permissions.

## Done when

- A new ADR (next free number) is accepted. It amends ADR 0142 §4/§7 (core reads for collected evidence) and refers to ADRs 0099, 0103, 0104 and 0147.
- The CLAUDE.md key-ADR list has a one-line entry for it.
- The follow-on tasks reference it: the read-only Microsoft Graph integration, the read-only AD account, moving checks off Microsoft 365 and AD, and grouping the Integrations screens by what each connection can do.

**Independent** (an ADR only, no code).