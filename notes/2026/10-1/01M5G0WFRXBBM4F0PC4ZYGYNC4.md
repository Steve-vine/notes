---
id: 01M5G0WFRXBBM4F0PC4ZYGYNC4
created: 2026-10-21T20:01:48.829205Z
updated: 2026-10-21T20:05:07.66835Z
type: task
title: Find the evidence for a framework control — pick a framework, pick one of its controls, and see the evidence for every core control that covers it, with the framework controls that have no current evidence easy to spot
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1207
sprint: sno3i7m
blocked_by:
- 01M5G0W0PRSB6K27S3PXWE4K0W
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1206.

**Chain:** on the chain — API

## What people see

**Audit ▸ Evidence ▸ By framework:**
- Choose a framework (ISO 27001:2022, SOC 2, NIST CSF 2.0, PCI DSS, CIS, HITRUST, ISO 42001…).
- Its controls are listed in the framework's own order and grouping. Each one shows:
  - how well the library covers it (full / partial / none, as on the framework's page);
  - how much current evidence the company holds through the core controls that cover it: "6 current · 2 out of date", or **None** in red.
- Filters: only framework controls with no current evidence (the gaps an auditor finds first); only out-of-date.

**Picking a framework control** shows:
- the core controls that cover it, each with full or partial;
- under each core control, the same view as By core control (COM-1206): its assessment, its evidence, its Evidence of operation and its policies.

A framework control that no core control covers says so: "Not covered by the library — no evidence can attach here".

Framework names and control numbers on this view link to the framework's page in Posture, and back.

## Notes (technical)

- `GET /audit/frameworks/{id}/requirements` (with counts) and `GET /audit/frameworks/{id}/requirements/{ref}/evidence`, composed from the COM-1206 per-control evidence.
- Counts use the mapping strength from `control_mappings`. A requirement covered only partially says so in its cover column; its evidence still counts.

**Done when:**
- choosing ISO 27001 and A.5.18 shows the core controls that cover it and all their evidence;
- the "no current evidence" filter lists exactly the framework controls whose core controls have none.