---
id: 01M5G0VP5T8EZJAD2H5DSP7G8K
created: 2026-10-21T20:01:22.618592Z
updated: 2026-10-21T20:21:45.284263Z
type: task
title: The Evidence register — every piece of evidence the company holds in one list, with where it came from, what it is, the period it covers and whether it's current; open one to see every core control and framework control it supports
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1205
sprint: sno3i7m
blocked_by:
- 01M5G0TW81FF2JDY5YM6G4DAA1
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1200 and COM-1204.

**Chain:** on the chain — API

## What people see

**Audit ▸ Evidence ▸ Register** has one row per piece of evidence the company holds:
- files and links from assessments, risks, the assurance plan, incidents, data subject requests, the trust centre and vendor certificates;
- the policies, standards and procedures that cover the company's controls, always in their current published version.

**The list:**
- Columns: name, evidence type, where it came from (e.g. "Assessment · ACC.8", "Plan · Quarterly access review", "Incident INC-12", "Trust centre", "Vendor · Acme Ltd"), period covered, valid until, status, added by, added on.
- Status is Current for now; the out-of-date task (COM-1210) adds the warnings.
- Sortable, paged, and filterable by where it came from, evidence type (from the rubric, COM-1217) and status.

**Opening a piece of evidence** shows:
- all its facts (from COM-1200) and its fingerprint;
- a link back to the record it belongs to;
- open / download;
- **Supports**: each core control it supports and, under each one, the framework controls that control maps to. These are grouped by framework, with how much each mapping covers:

```
Supports
  ACC.8  Privileged access is reviewed
    ISO 27001:2022   A.5.18 Access rights (full) · A.8.2 Privileged access rights (partial)
    SOC 2            CC6.2 (partial)
    NIST CSF 2.0     PR.AA-05 (full)
```

**Which controls a piece of evidence supports** comes from where it sits:
- an assessment's file → that control;
- a plan activity's file → the activity's linked controls;
- an incident's or data subject request's file → the controls those modules already feed;
- a policy → its domain's controls;
- trust centre documents and vendor certificates → none until someone links them (COM-1209).

Framework controls always follow from the library's mappings; nobody links them by hand.

**Retired controls:** evidence of a retired or switched-off control still appears, marked "Retired control". Today it can't be reached from any screen.

## Notes (technical)

- A read model, `core/evidence_register.py`: a source registry like Evidence of operation. Each source declares its company scope, the permission it needs, its owner label and link, and the core control keys it supports.
- Sources: attachments by owner type, evidence links, vendor certificates, trust centre documents, and policies (content items bound to a domain; their evidence type is Policy or procedure).
- Control → framework requirement via `control_mappings`, using its strength / coverage.
- `GET /audit/evidence` (filters, sort, paging) and `GET /audit/evidence/{kind}/{id}`.
- Restricted incidents and data subject requests are filtered by permission (COM-1199).

**Done when:**
- the register lists evidence from every source for the selected company;
- opening an assessment's file shows its control and that control's framework controls;
- someone without the incident restricted permission doesn't see a restricted incident's files.