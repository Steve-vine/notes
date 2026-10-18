---
id: 01M54K7WXVGPCGPD43HMDK98PP
created: 2026-10-17T09:31:43.931268Z
updated: 2026-10-18T07:50:07.598504Z
type: task
title: A control's assessment shows its "Evidence of operation" — the plan entries that prove it works, when each was last done with its evidence, when it's next due, and anything overdue or cancelled
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1051
sprint: sxflvhs
blocked_by:
- 01M54K6ZG540NVTQ88VSDASYAF
- 01M54K4NQ1YFFFXKNEDBQ3KS9X
comments:
- id: 01M55AV75QZTBRVFNPMFH7XT5N
  author: Steve Vine
  at: 2026-10-17T16:24:14.263115Z
  text: |-
    Done: merged in PR #1050.

    - A company's control page has an "Evidence of operation" card in the side column. It shows one row per plan activity linked to the control, with:
      - when it was last done and by whom, the outcome, and its evidence files to download;
      - when it's next due, and who owns it;
      - a warning for an overdue occurrence, or one cancelled in the last 12 months.
    - When nothing is linked, the card says "No plan activity evidences this control". Plan managers also get "Add to the plan", which opens Add entry with the control already linked.
    - It only shows information. Nothing on the card changes the control's assessment, gaps or compliance. People without "View the Security Assurance Plan" don't see the card at all.
    - The card is built so other modules can feed it later (COM-1060), without the control page having to change.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 75, SAP - Schedule (ADR in COM-1041; Steve, F and G). Built on COM-1050.

## Why

This is the pattern other modules will plug into later (Steve, G; backlog follow-up COM-1060). An assessor should be able to see a control is working without leaving the control's page.

## What people see

- On a company's assessment of a control (the control's page, Posture side), a new **Evidence of operation** card. It has one row per linked plan activity:
  - the activity's title and type, linking to the SAP entry;
  - **Last done:** the date, who did it, the outcome note, and its evidence files (download straight from here). Or "Never done";
  - **Next due:** the next occurrence's dates and owner. Or "Nothing planned";
  - a warning row when an occurrence is **overdue** ("Q3 access review: 20 days overdue, owner Jo Smith") or was **cancelled** in the last 12 months ("Cancelled: merged into Q4 after the restructure").
- An empty card says "No plan activity evidences this control", with **Add to the plan** for people with `sap.manage_plan`. That opens Add entry with this control already linked.
- The card has a source label ("Security Assurance Plan"). Later sources (vendor reviews, recertifications, content reviews) add their own rows under their own labels.
- The **control's library page** (Playbook side, shared) shows nothing new. Evidence of operation is per company, so it lives on the assessment.

## Rules

- **Show only** (Steve, F). Nothing here changes the control's status or maturity, raises a gap, or moves compliance. The assessor reads it and decides.
- A person sees the card if they can see the assessment and have `sap.view`. Without `sap.view` the card isn't shown at all, rather than shown empty.
- The evidence files are read through from the SAP entry, never copied, so there's one copy.

## Notes (technical)

- Build the backend as the generic contract the ADR records. Something like `core/evidence_of_operation.py` with a registry of sources, each returning `{source, activity, last_done, evidence[], next_due, warnings[]}` for (company, control). SAP is the first and only source; the shape is what COM-1060's sources must fit, the same way action sources work (ADR 0055).
- One endpoint, `GET /assessments/{id}/evidence-of-operation` (or company + control), so the page makes one call. Watch the page tests' prefix stubs (memory: sub-resource routes vs prefix stubs).
- Download links reuse COM-1044's route and its permission check.

**Done when:** the card shows on a company's control assessment with last done, next due and warnings from linked SAP entries, links to them, downloads their evidence, and changes nothing about the assessment.