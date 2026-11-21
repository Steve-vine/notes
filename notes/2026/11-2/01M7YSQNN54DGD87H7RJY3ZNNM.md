---
id: 01M7YSQNN54DGD87H7RJY3ZNNM
created: 2026-11-21T10:16:51.109447Z
updated: 2026-11-21T13:33:16.763581Z
type: task
title: Flowcharts are listed under Managed Content with the control's other documents, not as a separate Flowcharts section (Control and Assessment screens)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2062
sprint: s9hexqn
comments:
- id: 01M7Z242SXK032T36W4HDW20M4
  author: Steve Vine
  at: 2026-11-21T12:43:26.397229Z
  text: |-
    Done — merged to main as PR #2062 (not yet on staging; goes out with the round-5 deploy).

    What changes for people
    - Flowcharts no longer have their own "Flowcharts" heading: each is a row under Managed Content among the control's documents.
    - The row shows the flowchart's title (with its caption where it has one) linking to it, a Flowchart badge, and its steps beside it.
    - The same on the Control screen's Overview and Evidence tab and on the Assessment screen — they share one component, so they changed together.

    Call: flowcharts are sorted in among the documents by title; the domain policy stays first.
    Checked: Vitest (the row, its badge and link, the by-title ordering, no Flowcharts heading on the Assessment screen) and headless Chromium at desktop and phone width.
- id: 01M7Z4ZB2VVE59S72MW886SYPX
  author: Steve Vine
  at: 2026-11-21T13:33:16.763412Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps: Used IMA.4, which has the published flowchart "E2E pre-UAT request flow". Opened Control screen ▸ Evidence ▸ Managed Content, then the Assessment screen, then clicked the row.
    Seen:
    - On both screens the flowchart is a row under Managed Content, after the Incident Management Policy. It shows its title and caption, a FLOWCHART badge and "Step: Do the work".
    - There is no Flowcharts heading anywhere, and the row opens the flowchart.
    Not seen: the Overview's linked-content panel, which shows only with no company chosen, and Admin A always has one.
    Screenshots: ~/compass-uat/s9hexqn/COM-2062/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Raised by Steve while testing sprint 120 (2026-11-21). Related: COM-2060 (Assessment screen Overview) and COM-2061 (Control screen view-only). If built alongside COM-2060, do it in the same component so both screens get it at once.

**Today.** On both the Control screen and the Assessment screen, a control's flowcharts appear under a separate **Flowcharts** heading below its documents. That happens in the Overview's linked content and under Managed Content in the Evidence section and tab.

**What people see after this**
- A flowchart is listed **under Managed Content, among the control's other documents**, with no Flowcharts heading of its own.
- It looks like the other rows: its title (with its caption where it has one) linking to the flowchart, and a type badge reading **Flowchart**, as a policy row reads Policy.
- **My call (Steve to overturn): flowcharts are sorted in with the documents** in the same order as the rest of the list, not gathered at the end.
- The same on both screens, and wherever else the Managed Content list is shown.
- The "nothing linked" message only shows when there are no documents and no flowcharts, as now.

**Implementation notes**
- `content/flowchart/ControlFlowcharts.tsx` renders its own "Flowcharts" heading and list. It is used:
  - in `control/EvidenceTab.tsx` (inside `ManagedContent`, which the Assessment screen's `ControlEvidenceSection` also uses);
  - in `pages/ControlDetailPage.tsx` (the Overview's linked content panel).
- Fold `control.flowcharts` into the rows those lists already render, and remove the separate section. The check `!control.flowcharts?.length` that guards the empty message stays correct.
- Frontend only. Independent: no migration or API change.

**Done when**
- A control with a linked flowchart shows it as a row under Managed Content, badged Flowchart, on the Control screen's Overview and Evidence tab and on the Assessment screen, with no separate Flowcharts heading anywhere.
- The row opens the flowchart.