---
id: 01M62A88NQZZ9XE6GFATXQQBRY
created: 2026-10-28T22:31:51.7352Z
updated: 2026-10-28T22:31:51.7352Z
type: task
title: 'Audit ▸ Audits — a register of the company''s internal and external audits: kind, frameworks in scope, audit firm and auditors, lead, dates and observation period, status, linked to its SAP Audit activity'
label: feature
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1426
---
Sprint 97, Audit Management (ADR 0133, COM-1425).

## What people see

- **Audit ▸ Audits** (new item under Audit, follows the company picker): a table of audits showing reference (AUD-12), name, kind, frameworks, audit firm, dates, status, requests progress ("31 of 48 accepted") and open findings. Filters: status, kind, framework, year. The table is sortable.
- **New audit:**
  - name, kind (Internal; Certification; Surveillance; Recertification; SOC 2 Type I; SOC 2 Type II; Other external);
  - **frameworks in scope** (one or more, each with its level if it has levels, e.g. HITRUST i1);
  - scope statement;
  - audit firm (pick a vendor or type a name);
  - auditors (names and emails; internal audits pick Compass users);
  - **audit lead** (a Compass user);
  - dates: planned start and end, fieldwork, optional stage 1 and stage 2, and for SOC 2 Type II the **observation period**.
- **The audit's page** has tabs:
  - **Overview**: facts, status and the timeline of status changes;
  - **Requests** (COM-1427);
  - **Findings** (COM-1429);
  - **Auditors** (COM-1431);
  - **Activity**.
- **Status:** Planned → Fieldwork → Reporting → Closed (COM-1433), or **Cancelled** with a reason. A Closed or Cancelled audit is read-only.
- **SAP:** linking a SAP Audit activity shows "Audit AUD-12" on the activity and "On the plan: SAP-40" on the audit. **Create the audit** from an Audit activity pre-fills its name, dates and controls.
- **Compliance timeline:** an audit's fieldwork shows as a note on the chart automatically.
- **Evidence of operation:** a closed internal audit shows on INA.2 (internal audit function), with its last date and next due from SAP.

## Who can do what

- *View audit* to see audits.
- *Manage audits* (new) to create, edit, cancel and link them.
- Everything is audited in the activity log.

## Notes (technical)

- New tables `audits` (company-scoped, numbered by sequence, AUD-n) and `audit_frameworks(audit_id, framework_id, level)`, plus `audit_auditors` (name, email, firm, user_id nullable). Revisions as for other governed records.
- SAP link: an optional `audit_id` on `sap_entries`, one each way.
- Posture annotation: derive it at read time from the audit's dates; don't write `posture_annotations` rows.
- Evidence of operation source on key `INA.2`.
- New permission `audit.manage_audits`; give it to the built-in Admin.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve creates an ISO 27001 surveillance audit from a SAP Audit activity, sees it in the register and both ways on the plan, and cancels a test audit with a reason.