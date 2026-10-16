---
id: 01M52H1754E5SGEWMKGCP4R9YW
created: 2026-10-16T14:14:39.012329Z
updated: 2026-10-16T23:56:33.850484Z
type: task
title: The assistant can read and change the vendor rules and Portal settings — compliance rules, approval areas with their approvers and thresholds, and how the Vendor Portal greets suppliers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1040
sprint: shcfcmf
blocked_by:
- 01M52GY5TNNT0MAM8EZMW8HSJW
comments:
- id: 01M53JAPTKVH96T6M73PZAESHA
  author: Steve Vine
  at: 2026-10-16T23:56:32.979193Z
  text: |-
    Done — merged to main (PR #1020). Goes to staging with the rest of sprints 73 and 74. This completes sprint 73.

    What the assistant can now do, for a named company (writes need "Manage the register"):
    - Compliance rules: read ("when Criticality is Critical or above, the vendor must have a data processing agreement"), add, change, switch off, delete.
    - Approval rules: read each area's approvers and what brings it in; add an area; rename, retire, and change its conditions. "Raise Finance's threshold to £25,000" is one call — the old condition out, the new one in. Tested end to end: after the change, a £20,000 request no longer brings Finance in and a £30,000 one does.
    - Change an area's approvers by name: adding Jo keeps everyone else. It asks first, because it decides who can approve and gives or takes the approver's access.
    - Portal: read and change the title, introduction, sender name and From address. It asks first, because the From address changes how every email to a supplier appears. The server checks the address is valid.

    The logo: stays on screen, as planned. Saving the Portal from the assistant sends the existing logo back unchanged (tested byte for byte). One consequence: on the Portal, a logo replaces the title, so while there's a logo the assistant refuses to set a title and says to remove the logo on screen first.

    Found while building (not changed): approval areas, compliance rules and Portal settings aren't recorded in Activity, so these changes don't show "via assistant" anywhere. This is the last of that gap for vendors — see my summary at the end of the sprint.

    My call: switched-off compliance rules can still be found by name (so they can be switched back on); the list shows only active ones unless asked.
assignee: steve
label:
- feature
priority: medium
task_status: review
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