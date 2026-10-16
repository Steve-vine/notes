---
id: 01M52D9VHDA3E34RJXRDQF37RP
created: 2026-10-16T13:09:27.725088Z
updated: 2026-10-16T13:09:30.332989Z
type: task
title: The assistant can read Devices, Directory Roles and Conditional Access — and explain why a Conditional Access exclusion is expected
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1014
sprint: scj9zdp
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1013. These are the cloud-only tabs. When the directory is Active Directory only, they are hidden on screen and the assistant doesn't offer them either.

## What people can ask of it

- **Read:**
  - **Devices:** compliant, managed, enabled and last sign-in, filterable by operating system. Read one device in full.
  - **Directory Roles:** each Entra role with its active holders, its eligible holders, and the groups and applications that grant it.
  - **Conditional Access:** each policy and who is excluded from it, with the reason recorded for each exclusion that is expected.
- **Write (whatever the person's role allows on screen):**
  - record why a Conditional Access exclusion is expected, or clear that reason;
  - fill in an extra field on a policy.
- **Example:** "Who holds Global Administrator, directly or through a group? Which CA policies exclude them, and is each exclusion explained?"

## Notes (technical)

- Wraps `directory.py`: devices, devices/operating-systems, roles, conditional-access/policies and exclusions. Also wraps the expectation PUT/DELETE, which needs `access.review_unrequested`.
- Clearing an expectation is a removal, so mark it `destructive`.
- Reuses `find_account` and `find_group` from COM-1013. Add `find_directory_role` (by display name) and `find_ca_policy`.
- New module `tools/access_entra.py`.
- Tests: the expectation tools are hidden without review-unrequested; an expectation set through the assistant is recorded via assistant.

**Done when:** on staging, the assistant lists the unexplained exclusions on one policy and records a reason for one of them.