---
id: 01KXK69HD5SYCKV01J1XVPG5Y2
created: 2026-07-15T15:28:28.069081Z
updated: 2026-07-15T15:53:52.041115082Z
type: task
title: Vendor Management inception
assignee: steve
priority: medium
number: 166
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
sprint: s1lenxu
label:
- brief
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

---

## Agreed work (planned with Claude, 2026-07-15)

This is the **inception brief**: it delivers ADR 0039 (the full vendor domain design) plus the Notuvia task breakdown. No feature code — implementation starts with the Sprint 26 tasks it creates.

**Agreed scoping decisions:**
- Sprint 26 "basic framework" = Vendor entity + lifecycle + list/detail UI + user-definable flags. Reviews, approval workflow and onboarding form follow in later sprints.
- Vendors are **company-scoped** (CompanyScopedMixin, like risks/gaps).
- One **full-domain ADR 0039** now; schema/migrations land incrementally sprint-by-sprint.
- **Three new roles**: `vendor-owner` (submit onboarding requests), `vendor-manager` (edit vendors, set up assessments), `vendor-assessor` (approve/reject). New `Vendors` nav/permission section; viewer recommended to keep read access (confirm at ADR review).

**Checklist:**
- [ ] ADR 0039 `decisions/0039-vendor-management.md` — full domain design: Vendor + VendorRevision (RiskRevision pattern), state (new/active/non_compliant/dormant/offboarded) vs compliance_status (not_assessed/compliant/under_review/non_compliant), company-scoped user-definable flags, VendorReview (ContentReview pattern, Phase 2), engagement entity + configurable onboarding form (Phase 3), approval areas/approvers/typed rules/approvals + emails (Phase 3), assurance-profile field groups + certifications + offboarding (Phase 4), roles/capabilities, IA and Phase-1 API surface. Branch `feature/com-166-vendor-management-adr`, PR to main, merge to staging.
- [ ] Fix Sprint 26 title typo ("Vender" → "Vendor").
- [ ] Create Sprint 26 tasks (roles plumbing → models+migration → API → flags → list UI → detail UI) with blocked_by dependencies.
- [ ] Create Phase 2 backlog tasks (review cadence + VendorReview, outcomes drive posture, vendor–risk links, review reminders, review actions → Actions queue).
- [ ] Create Phase 3 backlog tasks (engagement entity, configurable form questions, onboarding submission, approval areas/approvers/rules, approval execution + emails, request-more-info loop).
- [ ] Create Phase 4 backlog tasks (assurance-profile field groups, certifications + expiry reminders, offboarding checklist, vendor reporting/dashboard).