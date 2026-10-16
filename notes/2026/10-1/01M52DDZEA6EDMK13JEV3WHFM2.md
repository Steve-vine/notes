---
id: 01M52DDZEA6EDMK13JEV3WHFM2
created: 2026-10-16T13:11:42.794139Z
updated: 2026-10-16T13:11:46.032873Z
type: task
title: The assistant can read and change Access ▸ Admin — joiner fields, role field mappings, membership rules, sign-in domains, extra fields and what Compass watches
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1022
sprint: scj9zdp
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 72, MCP - Access Control (ADR in COM-1012). Built on COM-1015, because membership rules name roles. Steve, 2026-10-16: read and write, the same as on screen.

## What people can ask of it

- **Read, and write wherever the person's role allows on screen.** Today that means people who manage business roles, plus review-unrequested for "What Compass watches".
  - **Joiner fields:** which details the new-joiner form asks for, per directory, and in what order. Add, edit, reorder and remove them.
  - **Role field mappings:** which joiner fields a business role fills in. Read and set them.
  - **Membership rules:** a rule that adds or withholds a group based on what a person's roles add up to. Add, edit and delete rules, and preview who a rule would change. **Raise the catch-up request** that brings people in line, which waits for a second person like any request.
  - **Sign-in domains:** the domains new accounts may be given. Read and set them.
  - **Extra fields:** the extra details recorded on people, groups and policies. Add, edit and remove them. These are shared by every company.
  - **What Compass watches** for unrequested changes. Read and set it. This is shared by every company.
- **Example:** "Add a 'Cost centre' joiner field after Department, required, for the cloud directory." Or: "write a rule that withholds Payroll-Admins from anyone without the Finance Manager role, and show me who it would change."

## Notes (technical)

- Wraps:
  - `joiner_fields.py`: GET, POST, PUT order, PATCH, DELETE;
  - `role_field_mappings.py`: GET, PUT;
  - `membership_rules.py`: GET, POST, PATCH, DELETE, preview, raise;
  - `sign_in_domains.py`: GET, PUT;
  - `extra_fields.py` definitions: GET, POST, PATCH, DELETE;
  - `unrequested_watch.py`: GET, PUT.
- Per company: joiner fields, mappings, rules and sign-in domains. Global: extra fields and the watch list. The tools say which.
- Deletes are `destructive`. Removing an extra field definition loses its values, so its description says so. Raise is a write, not destructive, because it lands as a pending request.
- Consolidate to one `update_` per object. Sign-in domains and the watch list are a single "set" each, since they are whole-list PUTs. Expect about 15 tools.
- New module `tools/access_admin.py`.
- Tests: writes are hidden without manage-business-roles or review-unrequested; a rule preview returns the people it changes; a joiner-field change is recorded via assistant.

**Done when:** on staging, the assistant adds a joiner field, and the new-joiner form on the Requests tab asks for it.