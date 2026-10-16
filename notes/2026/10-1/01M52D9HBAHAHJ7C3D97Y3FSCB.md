---
id: 01M52D9HBAHAHJ7C3D97Y3FSCB
created: 2026-10-16T13:09:17.29089Z
updated: 2026-10-16T17:14:36.785974Z
type: task
title: The assistant can read the directory — Users, Groups and Shared Mailboxes, who holds what and why, and trace a path in the Access Graph
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1013
sprint: scj9zdp
blocked_by:
- 01M52D91MBAZ225T7KZ5N06YNV
comments:
- id: 01M52VANTDPJKP4WPP5KVET955
  author: Steve Vine
  at: 2026-10-16T17:14:34.701634Z
  text: |-
    Done — merged to main (PR #1002), not yet on staging (the sprint deploys once all 11 are in Review).

    The assistant can now: search and read people (their roles, groups and why they hold each, shared mailboxes, account details, assets, extra fields); read groups (members direct and inherited, devices, contacts, who may send as the list); read shared mailboxes (who can open and send as each); trace "how does Jo come to be in Finance-Admins?"; and fill in extra fields on a person or group. Search also finds people, groups and — with a company named — business roles and requests.

    My calls:
    - When the directory is Active Directory only, the Shared Mailboxes tools aren't offered, the same as the tab.
    - A name that matches several people (e.g. "Sam") is refused with the candidates listed, never guessed.
    - Refusals now come back in Compass's own words. Before this, the assistant was getting the raw error text — that also improves every sprint 70 tool.
    - The lookups every other Access task uses (roles, requests, directory roles, policies) all landed here, so the remaining tasks can be built side by side.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 72, MCP - Access Control (ADR in COM-1012). **Do this one first.** Every other Access task finds people, groups and mailboxes through the lookups it adds.

## What people can ask of it

- **Read:**
  - **Users:** search the accounts (name, sign-in name, enabled, cloud or on-prem). For one person, as the user window shows it:
    - their business roles, and why they hold each;
    - their groups and shared mailboxes;
    - their account details;
    - the assets they're recorded against;
    - their extra fields.
  - **Groups:** security groups, Microsoft 365 groups and distribution lists. For one group:
    - its members, including devices and contacts;
    - who may send to it as the list (send-as, send-on-behalf);
    - the directory roles it grants.
  - **Shared Mailboxes:** each mailbox, who can open it and who can send as it.
  - **Access Graph:** "how does Jo come to be in Finance-Admins?" The assistant traces the path from a person to a group, or fans out from one object.
- **Write (whatever the person's role allows on screen):** fill in or change an extra field's value on a person or a group.
- **Search:** the assistant's existing search also finds people, groups, business roles and access requests.
- **Example:** "Who can send as accounts@? And why is Sam in the Payroll group?"

## Notes (technical)

- Wraps `directory.py`: users, groups, members, list-rights, shared-mailboxes, graph and setup. Also wraps `shared_mailboxes.py`, and the extra-field values GET/PUT in `extra_fields.py`.
- **Shared lookups in `tools/common.py`:** `find_account` (UPN, email, display name or "me"), `find_group` and `find_mailbox`. Like `find_control`, each refuses with candidates rather than guessing. The other Access tasks reuse them.
- The directory takes no company. `business-roles`, `groups` and `account-details` on a user take one, so the company is optional here and required only for those views.
- Hide the cloud-only tools (Shared Mailboxes here, and the ones in the next task) when the directory setup is AD-only, the same way the tabs hide.
- New module `tools/access_directory.py`. Add the Access paragraph to INSTRUCTIONS in `instance.py`, and add the Access types to `_SEARCH_TYPES` in `session.py`.
- Tests: lookups refuse ambiguity; the cloud-only tools are hidden on AD-only; a person without access view gets no Access tools; an extra-field edit is recorded via assistant.

**Done when:** on staging, the assistant answers "who can open the accounts@ mailbox, and how does each of them get it?"