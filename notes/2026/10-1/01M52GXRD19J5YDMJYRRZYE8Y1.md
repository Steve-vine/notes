---
id: 01M52GXRD19J5YDMJYRRZYE8Y1
created: 2026-10-16T14:12:45.601876Z
updated: 2026-10-16T21:11:35.946558Z
type: task
title: 'ADR: the assistant reaches Vendor Management — the register, requests and approvals, questionnaires and the module''s settings, as the person and the same as on screen'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1033
sprint: shcfcmf
blocked_by:
- 01M52D91MBAZ225T7KZ5N06YNV
comments:
- id: 01M538WMK97E0KXHBZG251XQQ0
  author: Steve Vine
  at: 2026-10-16T21:11:34.760868Z
  text: |-
    Done — ADR 0112 "The assistant reaches Vendor Management" merged to main (PR #1012). It amends ADR 0109's scope (Vendor Management is in) and §5 (the assistant can now link a vendor to a risk and raise one from a vendor). 0109's other sections stand.

    Recorded as written in this task, with two additions found while checking the code:
    - A vendor's History panel reads its own revision table, not the activity log, so that table gets the "via assistant" marker in COM-1034 — the same as risk and assessment histories got in sprint 70.
    - Saving the Portal settings replaces the logo along with everything else, so the tool reads the current logo and sends it back unchanged. The assistant can never clear or replace the logo.

    Offboarding is flagged as destructive too: it is the end of the relationship, and only an admin can reverse it.

    My calls still awaiting your confirmation (all in the ADR): approvals the same as on screen; deleting the same as on screen, including the admin's permanent delete; vendors link to risks; vendors found by name only (⌘K unchanged); logo stays on screen; both portals and the Admin rubrics out; no new grant.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 73, MCP - Vendor Management. Scoped with Steve on 2026-10-16. This record is the first task, and the rest wait for it. It follows sprint 72's record for Access Control (COM-1012), which is written first and settles the shared rules for bringing a module in. Sprint 74 (Inventory, COM-1023) follows the same pattern.

Sprint 70 (ADR 0109) connected an AI assistant to Overview, Playbook and Posture. This sprint adds **Vendor Management** under the same rules: the assistant acts as the person, does exactly what their role allows on screen, and every change is marked "via assistant".

## What Steve decided (2026-10-16)

- **Every Vendor Management tab is in scope:**
  - Register and Requests;
  - the vendor page and all of its tabs;
  - Assessments, Assessment rules, Compliance rules, Approval rules, and Portal.
- **Sending a questionnaire is the same as on screen.** If your role can send one, the assistant can too. Sending emails the vendor's compliance contacts a link into the Vendor Portal, from the company's own address. So the assistant flags it as an outside action, and a client that asks before acting asks first. Withdrawing one is the same.

## What the record has to settle (Claude's calls, not confirmed by Steve)

- **Approvals are the same as on screen.** This carries over Steve's Access Control answer (COM-1012). If you're an approver for an area, or the vendor's owner, the assistant can approve, reject or ask for more information as you. The rules don't change:
  - you can't decide your own request;
  - holding the permission isn't enough, you must be that area's approver;
  - a decision is final.
- **Deleting is the same as on screen**, including an admin's permanent delete of an offboarded vendor. That is flagged as destructive.
- **Links into other areas are made the same as on screen**, as in COM-1023: link a vendor to a risk, or raise a risk from a vendor. Decisions can't be linked to vendors on screen today, so the assistant can't either.
- **No file uploads**, as in ADR 0109. The Vendor Portal's logo stays on screen. Its other settings, such as the title, introduction, sender name and From address, are in scope.
- **Recording a supplier's answers internally** (filling in or completing a questionnaire on their behalf) is the same as on screen.
- **Finding a vendor by name.** Vendors have no reference like AST-12, and the ⌘K search doesn't cover vendors today. The assistant finds a vendor by its name within the company, and asks when more than one matches. Adding vendors to ⌘K would change the screen, so it isn't part of this sprint.
- **Out:**
  - both portals: the Compass Portal's vendor pages and My requests, and the external Vendor Portal suppliers use;
  - the shared rubrics on the Admin page: criticality, risk tiers, access levels, sensitivity, data types and entities. The assistant reads them to fill in a form, but doesn't change them.
- **No new grant**, as in COM-1012. The vendor permissions decide which vendor tools a person gets.

## Notes (technical)

- Write the next free `decisions/NNNN-*.md`. It amends ADR 0109's scope and §5 for Vendor Management. Use the `vendors_` prefix and one `update_` per object.
- `POST /vendors/{id}/assessments/start` mints capability tokens and emails the supplier. Mark it `destructive`, say so in its description, and **never return the link or token** (the route doesn't either; keep it that way).
- `vendors.decide_approvals` is defined but no route checks it. Decide routes check area membership or ownership inside `decide_from_body`. The tool gate therefore can't be a permission alone. Offer decide tools to anyone who can see vendors, and let the route refuse.
- The branding PUT carries the logo as base64. The tool never sends a new logo and keeps the existing one (COM-1040).
- The existing `overview_vendor_register` and the Actions vendor lens stay as they are.
- About 50–60 tools across 8 tasks.

Tasks:
- COM-1034 Register and the vendor record (first);
- COM-1035 engagements, assurance, certifications and contacts;
- COM-1036 reviews, risks and lifecycle;
- COM-1037 Requests and approvals;
- COM-1038 questionnaire library and Assessment rules;
- COM-1039 sending questionnaires;
- COM-1040 compliance and approval rules, and Portal settings.

**Done when:** the record is accepted and the tasks below match it.