---
id: 01M5G0WFRXBBM4F0PC4ZYGYNC4
created: 2026-10-21T20:01:48.829205Z
updated: 2026-10-22T00:51:22.364398Z
type: task
title: Find the evidence for a framework control — pick a framework, pick one of its controls, and see the evidence for every core control that covers it, with the framework controls that have no current evidence easy to spot
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1207
sprint: sno3i7m
blocked_by:
- 01M5G0W0PRSB6K27S3PXWE4K0W
comments:
- id: 01M5GHENAWKCVZXB9BA3WYANJY
  author: Steve Vine
  at: 2026-10-22T00:51:21.564396Z
  text: |-
    Done — merged in PR #1221.

    - **Audit ▸ Evidence ▸ By framework** has a framework picker. It lists the frameworks the library maps controls to.
    - A framework's controls are shown in its own order. Where it splits into parts (ISO's Clauses / Annex A), they're grouped under those parts, with child controls indented beneath their headings.
    - Each framework control shows how far the library covers it (Fully covered / Partly covered / Not covered, as on its page in Posture). It also shows the evidence the company holds through the core controls covering it ("6 current", or **None** in red) and how many core controls cover it. "Out of scope" and "Above level" are marked on the row.
    - **Evidence → No current evidence** lists the framework controls the company has to answer that have nothing current: the gaps an auditor finds first.
    - **Opening a framework control** shows each core control covering it, full cover first, marked Full cover or Partial cover. Under each is the By core control view: its assessment, evidence, Evidence of operation and policies.
    - A framework control the library doesn't cover reads "Not covered by the library — no evidence can attach here." A heading lists the controls it's made up of.
    - The framework's page in Posture now has an "Evidence for this framework" link for anyone who can view audit, and this view links back.

    My calls (beyond the task):
    - **Counted once:** a piece of evidence that supports two of the core controls covering one framework control counts once.
    - **Never gaps:** headings, out-of-scope and above-level framework controls are never counted as gaps.
    - **Level:** figures use the level the company is working towards (e.g. "· at i1"), with no level picker on this screen.
    - **Fixed order:** the list keeps the framework's own order and isn't sortable, as on the plan's coverage tab.
assignee: steve
label:
- feature
priority: high
task_status: review
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