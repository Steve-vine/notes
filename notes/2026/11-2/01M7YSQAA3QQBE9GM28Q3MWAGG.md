---
id: 01M7YSQAA3QQBE9GM28Q3MWAGG
created: 2026-11-21T10:16:39.491356Z
updated: 2026-11-21T10:16:39.491356Z
type: task
title: 'Control screen is for viewing only: its add, link, raise and request buttons go (they live on the Assessment screen)'
task_status: todo
assignee: steve
priority: medium
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2061
---
Raised by Steve while testing sprint 120 (2026-11-21). Part of one change:
- **the Control screen is purely for viewing a control;**
- **the Assessment screen is where it's assessed and evidence is added.**

**Needs ASSESSMENT_TASK first**, which brings Ask Polaris to collect and Add decision to the Assessment screen, so nothing is lost. Related: COM-2056, COM-2057, FLOWCHART_TASK.

**What goes, and where each one is done instead**

| Control screen | Button that goes | Done instead |
|---|---|---|
| Overview | **Add decision** (the box for linking a decision record) | Assessment screen ▸ Decisions ▸ Add decision (ASSESSMENT_TASK) |
| Evidence | **Add to plan** | Assessment screen ▸ assessment box ▸ Add to SAP (COM-2057) |
| Evidence | **Link content** (the selector) | The document's own page ▸ Links ▸ Controls, as today |
| Evidence | **Ask Polaris to collect this** | Assessment screen ▸ Evidence ▸ Automated Collection (ASSESSMENT_TASK) |
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