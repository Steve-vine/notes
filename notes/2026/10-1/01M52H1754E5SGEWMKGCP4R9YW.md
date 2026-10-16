---
id: 01M52H1754E5SGEWMKGCP4R9YW
created: 2026-10-16T14:14:39.012329Z
updated: 2026-10-16T23:36:40.756778Z
type: task
title: The assistant can read and change the vendor rules and Portal settings — compliance rules, approval areas with their approvers and thresholds, and how the Vendor Portal greets suppliers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1040
sprint: shcfcmf
blocked_by:
- 01M52GY5TNNT0MAM8EZMW8HSJW
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 73, MCP - Vendor Management (ADR in COM-1033). Built on COM-1034.

## What people can ask of it

- **Read (for a named company):**
  - **Compliance rules:** when a condition applies, what the vendor must have. For example, a DPA, or breach notification within so many hours.
  - **Approval rules:**
    - each approval area and its approvers;
    - the rules that bring the area in: always, from a criticality, a data sensitivity, an **annual cost** or a risk tier.
  - **Portal:** the Vendor Portal's title, introduction, sender name and From address.
- **Write (whatever the person's role allows on screen):**
  - add, edit or delete a compliance rule;
  - add or edit an approval area;
  - **set who its approvers are**;
  - add or remove its rules, including the annual-cost threshold;
  - change the Portal's title, introduction, sender name and From address.
- **Stays on screen:** the Portal's logo, which is a file upload (COM-1033).
- **Example:** "Who approves for Finance, and from what annual cost?" Then: "raise Finance's threshold to £25,000 and add Jo as an approver."

## Notes (technical)

- Wraps:
  - `compliance_rules.py` (CRUD);
  - `approval_areas.py`: list, assignable-users, POST, PATCH, `PUT /{id}/approvers`, and rules POST/DELETE;
  - `vendor_portal_branding.py` GET/PUT.
- **The branding PUT carries the logo too.** Check whether it replaces the whole record. If it does, the tool reads the current branding and sends the logo back untouched, so changing the title never clears the logo. The tool's input has no logo field.
- **Approvers decide who can approve what, and the From address decides how supplier mail appears.** Both are writes the screen allows to manage-register. Mark them `destructive` too, so a client asks first, and say why in the description.
- Approvers resolve among the assignable users only. The PUT replaces the whole list, so the tool reads it first and sends the result of adding or removing names. The assistant never has to restate the list.
- The From address is validated by the route (ADR 0053). Pass its refusal on as it is.
- New module `tools/vendors_settings.py`.
- Tests:
  - writes are hidden without manage-register;
  - adding one approver keeps the others;
  - changing the title keeps the logo;
  - a rule change is recorded via assistant.

**Done when:** on staging, the assistant changes an area's annual-cost threshold and adds an approver, and the next request above the threshold brings that area in.