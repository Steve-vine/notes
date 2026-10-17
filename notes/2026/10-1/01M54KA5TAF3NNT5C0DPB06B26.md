---
id: 01M54KA5TAF3NNT5C0DPB06B26
created: 2026-10-17T09:32:58.570236Z
updated: 2026-10-17T14:27:56.901602Z
type: task
title: What an SAP activity finds becomes a gap or a risk — raised straight from the entry, linked both ways, so a pen test's findings are tracked to closure
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1055
sprint: sxflvhs
blocked_by:
- 01M54K6ZG540NVTQ88VSDASYAF
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 75, SAP - Schedule (ADR in COM-1041; suggestion 6). Built on COM-1050, because a gap is raised against a control.

## What people see

- A **Findings** section on an entry's page, with two buttons:
  - **Raise a gap:** the usual Raise gap window. The control defaults to one of the entry's linked controls (pick another if needed). The title is prefilled from the entry ("Found in: Annual penetration test 2027"). Needs `posture.manage_gaps`.
  - **Raise a risk:** the usual Add risk window, its description prefilled the same way. Needs `posture.manage_risks`.
  - **Link existing:** attach a gap or risk that already exists.
- The section lists each gap and risk raised from the entry, with its number, title and current status, linking to it. Over time it shows how many are closed.
- **The gap's or risk's page** shows "Found in: Annual penetration test 2027", linking back to the entry.
- Findings can be raised and linked **after the entry is done.** Findings usually come with the report, so this is allowed on a frozen entry, like comments.

## Rules

- Raising a gap or risk follows that module's permissions. SAP grants nothing extra.
- Unlinking doesn't delete the gap or risk.
- Linking, unlinking and raising are in Activity.

## Notes (technical)

- A link table (`sap_entry_findings`: entry, kind gap|risk, target id), or reuse the polymorphic link pattern of `decision_link`. Gaps already carry `raised_via`; set it to `sap` for gaps raised here.
- Reuse `RaiseGapModal.tsx` and the risk add form rather than new forms.

**Done when:** gaps and risks can be raised from or linked to an entry (done or not), each shows on the other's page, and module permissions decide who can raise them.