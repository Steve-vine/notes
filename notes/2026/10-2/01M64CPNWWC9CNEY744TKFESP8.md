---
id: 01M64CPNWWC9CNEY744TKFESP8
created: 2026-10-29T17:53:10.044194Z
updated: 2026-10-29T20:17:55.311556Z
type: task
title: 'Operators Manual: Modules — vendors, access control, inventory, SAP, incidents, attestations, data subject requests'
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 18
sprint: sstqjgj
blocked_by:
- 01M64CNWM12FKRY4C9ZPVKB4XW
comments:
- id: 01M64MZQKFS79864RXYWQ6GECY
  author: Steve Vine
  at: 2026-10-29T20:17:55.311428Z
  text: |-
    Pushed to staging (7fd2b3a and the commit after it). The "Modules" group now has a collapsible sub-group for each module, in the app's menu order. That's 39 pages, all checked against the v0.16.0 code:
    - Vendor Management (6): register, request and approve, engagements and risk tier, reviews and compliance, send a questionnaire, dormant and offboarding.
    - Access Control (6): connect a directory, business roles, access requests, validation, recertification, coverage and reports.
    - Inventory (6): registers, technology, data and software assets, owners and reviews, discovery.
    - SAP (4): plan the year, record work as done, link to controls, approve and export.
    - Incidents (7): register, report and triage, work an incident, timeline and evidence, notifications, review and close, restrict.
    - Attestations (3): assign to a role, sign in the portal, see who has signed.
    - Data Subject Requests (7): log a request, deadlines, verify and decide, fulfil and tell recipients, letters and closing, disclosures, compliance and exports.

    Screenshots: about 40, in light and dark. Access Control and Attestations are written from the code with almost no screenshots, because the demo install has no directory or business roles. Out of the box, only the Admin role holds the permissions for SAP, Incidents, Attestations, Data Subject Requests and Inventory, and the pages say so.

    Possible app issues found while writing, for COM:
    - Vendor questionnaire buttons are gated on "Manage the vendor register", but the API checks the questionnaire permissions.
    - The Validation "Decide" button is gated on the wrong permission.
    - The portal's My assets "Classification" column shows criticality.
    - An access request waiting for approval creates no action or notification for anyone.
    - An attestations-only role can't assign content, because it also needs View access.
    - Incident notification rows read "Tell The police…".
    - An incident's Governance card asks for an "ISE incident" reference, which looks organisation-specific.
    - Assorted wording slips (Non-Production, "Access write", the delete dialogs still mention controls).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
How to use each module in the released version (v0.16.0 menu): Vendor Management, Access Control (Microsoft Entra ID), Inventory, SAP (the security assurance plan), Incidents, Attestations and Data Subject Requests. One page per job. Checked against the released version.