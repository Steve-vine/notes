---
id: 01M5G0W0PRSB6K27S3PXWE4K0W
created: 2026-10-21T20:01:33.400667Z
updated: 2026-10-21T20:05:02.778404Z
type: task
title: Find the evidence for a core control — pick one from the library and see every piece of evidence for it, what the modules have done for it, and the policies that cover it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1206
sprint: sno3i7m
blocked_by:
- 01M5G0VP5T8EZJAD2H5DSP7G8K
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1205.

**Chain:** on the chain — API

## What people see

**Audit ▸ Evidence ▸ By core control:**
- The library's domains and controls, each showing how much evidence the company holds for it: "4 current · 1 out of date", or **None** in red.
- Filters: only controls with no evidence; only controls with out-of-date evidence (once COM-1210 lands); domain; tier.

**Picking a control** shows, in one place:
- the company's assessment of it: status, maturity, last reviewed, with a link to the assessment;
- **Evidence**: every piece of evidence that supports it, from wherever it sits, with the same columns as the register;
- **Evidence of operation**: the same lines as on the control's page (plan activities, handled incidents, signatures, reviews);
- **Policies**: the policies, standards and procedures that cover it, with their current version.

**Retired controls:** when a control replaced a retired one, the retired control's evidence is shown too, marked "from ACC.3 (retired)". That keeps evidence from going missing when the library is renumbered. *(My call.)*

This view is reused by By framework (COM-1207) and by the audit pack (COM-1214).

## Notes (technical)

- `GET /audit/controls` (counts per control) and `GET /audit/controls/{key}/evidence`.
- Evidence of operation via the existing registry (`core/evidence_of_operation.py`); policies by domain membership.
- Retired evidence follows `superseded_by`.
- Look up controls by `CoreControl.key`, not ref.

**Done when:**
- picking ACC.8 shows its assessment, every file and link supporting it from every module, its Evidence of operation and its policies;
- a control with no evidence shows None, and the "no evidence" filter finds it.