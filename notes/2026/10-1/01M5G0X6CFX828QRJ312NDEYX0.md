---
id: 01M5G0X6CFX828QRJ312NDEYX0
created: 2026-10-21T20:02:11.983979Z
updated: 2026-10-21T20:21:54.041651Z
type: task
title: Add evidence straight into the register, and link one piece of evidence to every control it proves — so one firewall review supports three controls without being uploaded three times
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1209
sprint: sno3i7m
blocked_by:
- 01M5G0WT0R042QBZS2WB44XR11
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1208 (chain order); uses the register (COM-1205).

**Chain:** on the chain — migration + API

## What people see

- **Add evidence** on the Register tab:
  - upload a file or add a link, with its facts (what it is, evidence type, period covered, valid until);
  - pick the core controls it supports, searching by number or name.
  - It then shows on each of those controls' assessments as evidence, the same as a file added there.
- **Also supports** on any piece of evidence's detail adds or removes core controls.
  - The control it was added to stays: an assessment's file always supports its own control, and a plan activity's file its activity's controls.
  - Trust centre documents and vendor certificates are linked the same way, for example the company's ISO 27001 certificate to the certification and management-review controls.
- The Supports list on the detail updates straight away, framework controls included.
- Each link and unlink is recorded in Activity with who and when. An unlinked control shows in the evidence's history ("No longer supports NES.3 — removed by …"), so it's never silently lost.
- Needs **Manage evidence**. An assessor can also add a file on the assessment card as today, and link it to more controls there.

## Notes (technical)

- `evidence_control_links`: evidence id (attachment or link), core control, company, added by/at, removed by/at. Soft-unlink only; audited.
- Register-owned evidence (no parent record) is a new attachment owner type, `evidence`, scoped to the company.
- The register's "supports" = the source's implied controls ∪ the active links.

**Done when:** a file added in the register and linked to three controls appears on all three assessments and under all their framework controls; unlinking one leaves a record.