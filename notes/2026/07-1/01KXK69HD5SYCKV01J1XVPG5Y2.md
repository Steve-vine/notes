---
id: 01KXK69HD5SYCKV01J1XVPG5Y2
created: 2026-07-15T15:28:28.069081Z
updated: 2026-07-15T15:29:02.914031Z
type: task
title: Vendor Managment inception
assignee: steve
priority: medium
sprint: s1lenxu
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 166
---
In this Sprint we will define what the new Vendor Management section will provide, what features it will have, and what good looks like.

### Overview
The Vendor Management section will be used to track vendors (suppliers), from initial on-boarding requests and assessments, through annual re-assessments, performance reviews and risk management to off-boarding.

### Tracking requirements
- Vendor states (New, Active, Non-Compliant, Dormant, Offboarded).
- Flags, ability to add flags to a vendor to indicate a status or requirement, should be user definable.  E.g. PCI, Healthcare, Breach.
- Status, E.g. Compliant, Under Review, Non-compliant
- Review history, frequency of review, last review, next review, review findings/actions, risks
- Owner/reviewer
- Scope, data types, data residency, access requirements, sub processors / fourth party risk
- Vendor details, criticality, Security certifications, Financial stability and company viability
- Contractual protections (DPA, security clauses, liability, audit rights)
- Incident response and breach notification obligations
- Business continuity / disaster recovery capability
- Regulatory and legal compliance (GDPR, sector-specific)
- External security posture (ratings, breach history, vulnerabilities)
- SLAs and support arrangements
- Exit strategy (data return/deletion, portability, lock-in)
- Insurance coverage (cyber liability)
- Reputation and references
- Approval workflow, there should be a list of approvers covering different areas (cyber security, operations, finance etc.) based on the criteria a workflow of approval is required.

### Workflow
Vendors are initially added as ’New’ and must to through a sign-off process (information gathering, assessment, approval) to become active.
Vendors that fail initial or future assessments become 'Non-Compliant’.
Vendors that are no-longer used and don’t need regular assessment become dormant.
Vendors that are no-longer dealt with are offboarded.

### Assessment and signoff
An onboarding request form should be completed which asks the basic questions about the vendor and the engagement.  These should be configurable in the app.
An initial assessment is completed for compliance against requirements based on the engagement criteria.
An approval workflow is then created with emails users to come and review the request and approve, reject or ask for more information.
Once everyone has approved it, the vendor moved to Active.

### Approach
Based on these requirement, create a set of tasks in Notuvia to build this feature.  This is a complex feature so an iterative approach should be taken.  The initial sprint is Sprint 26 - “Vendor Management - Phase 1”.  In this sprint we should get the basic framework in place and then build on it in the next sprint.