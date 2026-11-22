---
id: 01M7YSQAA3QQBE9GM28Q3MWAGG
created: 2026-11-21T10:16:39.491356Z
updated: 2026-11-22T08:13:22.342833Z
type: task
title: 'Control screen is for viewing only: its add, link, raise and request buttons go (they live on the Assessment screen)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2061
sprint: s9hexqn
comments:
- id: 01M7Z24CYNTAB4JC60HW7WAC71
  author: Steve Vine
  at: 2026-11-21T12:43:36.789776Z
  text: |-
    Done — merged to main as PR #2063 (not yet on staging; goes out with the round-5 deploy).

    What changes for people
    - The Control screen still lists everything, but no longer offers Add decision, Add to the plan, Link content, Ask Polaris to collect, Add evidence, Raise gap, or Request an exception / Renew. Unlinking a decision or a document is gone from it too.
    - Each tab ends with one quiet line pointing to the Assessment screen, linked to this control there — "Raise gaps on the Assessment screen", "Request exceptions on…", "Add evidence, add to the plan and ask Polaris to collect on…", and on Overview "Link decisions on…". It shows only to people who may do those things, with a company chosen, on a switched-on control.
    - Nobody's permissions change.

    Calls Steve might overturn
    - Other changing actions on the Evidence tab went too: the coverage answer's "Say how it is covered", a collected check's own menu, a built-in check's Run now / Switch off, and reviewing a proposed check. All are still on the Assessment screen.
    - Set status, in a piece's history window under Manual Collection, stays on the Control screen — the task didn't name it.
    - Known gap: someone who can manage evidence in the register but can't record assessments has lost Add evidence on the Control screen (the box offers it only to people who record assessments). They now add evidence from Audit ▸ Evidence.

    Also: Browser smoke journey 8 now adds its web address with the box's Add evidence on the Assessment screen, then sets its status from the Overview's Evidence ▸ Manual Collection. It runs with the deploy.
    Checked: Vitest as an administrator (none of those buttons on any tab; each pointer line links to the control on the Assessment screen); the collection, checks, queue and screen-conventions suites pass; Control screen tabs checked in headless Chromium at desktop and phone width.
- id: 01M7Z4ZG4J7D669JAMAM63CTZ7
  author: Steve Vine
  at: 2026-11-21T13:33:21.938175Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps: As Admin A, went tab by tab through RIM.9 and INS.10 (117 gaps, 1 risk, 40 evidence) on the Control screen. Followed a pointer link. Checked as Viewer.
    Seen:
    - No tab offers Add decision, Add to plan, Link content, Ask Polaris, Add evidence, Raise gap or Request exception. Unlink, "Say how it is covered" and the evidence actions are gone too.
    - Every record is still listed.
    - Each tab ends with a pointer line ("Link decisions…", "Add evidence, add to the plan and ask Polaris to collect…", "Raise gaps…", "Request exceptions… on the Assessment screen"). The one I clicked landed on RIM.9's assessment.
    - The Viewer sees no pointer lines.
    - Each action still works from the Assessment screen.
    Screenshots: ~/compass-uat/s9hexqn/COM-2061/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Raised by Steve while testing sprint 120 (2026-11-21). Part of one change:
- **the Control screen is purely for viewing a control;**
- **the Assessment screen is where it's assessed and evidence is added.**

**Needs COM-2060 first**, which brings Ask Polaris to collect and Add decision to the Assessment screen, so nothing is lost. Related: COM-2056, COM-2057, COM-2062.

**What goes, and where each one is done instead**

| Control screen | Button that goes | Done instead |
|---|---|---|
| Overview | **Add decision** (the box for linking a decision record) | Assessment screen ▸ Decisions ▸ Add decision (COM-2060) |
| Evidence | **Add to plan** | Assessment screen ▸ assessment box ▸ Add to SAP (COM-2057) |
| Evidence | **Link content** (the selector) | The document's own page ▸ Links ▸ Controls, as today |
| Evidence | **Ask Polaris to collect this** | Assessment screen ▸ Evidence ▸ Automated Collection (COM-2060) |
| Evidence | **Add evidence** | Assessment screen ▸ assessment box ▸ Add evidence |
| Gaps | **Raise gap** (both places it appears, including the empty state) | Assessment screen ▸ assessment box ▸ Raise gap |
| Risks | **Request an exception** (and Renew exception) | Assessment screen ▸ assessment box ▸ Request exception / Renew exception |

**What people see after this**
- The Control screen's Overview, Evidence, Gaps and Risks tabs still show everything they show today: decisions, evidence under its four headings, gaps and risks. They just offer nothing to add, link, raise or request.
- **My calls (Steve to overturn), in the same spirit:**
  - **The other changing actions on these tabs go too.** That covers unlinking a decision, and each evidence piece's edit details, replace, archive and take off the control (those move to the Assessment screen with COM-2056). Viewing a piece, opening its preview and following a link to where something lives all stay.
  - **Each tab points to the Assessment screen.** Where a tab used to offer an action, a short line or link says it's done on the Assessment screen (for example "Add evidence, raise gaps and request exceptions on the Assessment screen", linking to this control there). Shown only to people who can record assessments, and only with a company chosen.
- Nothing changes in what anyone is allowed to do: the same people can do the same things, on the Assessment screen. Polaris's tools are unaffected.

**Implementation notes**
- Overview: `LinkedDecisions` in `pages/ControlDetailPage.tsx`. Give it a read-only mode (no add or unlink) rather than hiding it.
- Evidence: `control/EvidenceTab.tsx`:
  - the Add to plan action on `EvidenceOfOperationCard`;
  - the Link content selector;
  - `CollectionCard`'s Ask Polaris button;
  - Add evidence and its window.

  `ManagedContent` already has a `readOnly` mode, used by the Assessment screen.
- Gaps and Risks: `ControlGapsCard` / `ControlRisksCard` already take `actions={false}` (the Assessment screen uses it). Pass it from the Control screen too.
- Update tests and the Browser smoke journeys that use these buttons on the Control screen. Move them to the Assessment screen where the journey adds something.
- Frontend only. Independent: no migration or API change.

**Done when**
- On the Control screen, as an administrator with every permission, no tab offers Add decision, Add to plan, Link content, Ask Polaris to collect this, Add evidence, Raise gap or Request an exception, and every record is still listed.
- Each of those can still be done from where the table says, by the same people.