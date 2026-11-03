---
id: 01M6HKBB0WXGQWJP7VVGYM3W7B
created: 2026-11-03T20:59:26.108175Z
updated: 2026-11-03T21:01:25.295874Z
type: task
title: Add controls to an initiative — each brings its gaps, linked risks, decisions and content, kept live; the Controls, Gaps, Risks, Decisions and Content tabs list them with their own owners and status
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1555
sprint: snyzymp
blocked_by:
- 01M6HKAW0ZEHMN8JEV15XMBARN
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). Builds on COM-1554.

## What people see

- **Add controls** on the Controls tab, for the owner or anyone with *Manage initiatives*:
  - a searchable picker with several chosen at once;
  - filtered by domain, with "all controls in this domain" as a shortcut;
  - controls already in the initiative are shown as added.
- **Controls tab.** One row per control, showing:
  - reference and title;
  - its assessment in this company (status, maturity);
  - the assessment owner;
  - next review date;
  - counts of open gaps and risks.

  A control can be **removed**, which also removes what it brought, unless that item was also added directly or came through another control.
- **What each control brings,** each on its own tab:
  - **Gaps:** the control's gaps in this company, open and closed.
  - **Risks:** risks in this company linked to the control.
  - **Decisions:** decisions linked to the control, or to one of those risks.
  - **Content:** content linked to the control, plus its domain's policy (policies cover their domain's controls by membership).
- **Live.** What a control brings is worked out each time, never copied:
  - a gap raised on it next month appears by itself;
  - a risk unlinked from it disappears.
- **Each row** shows the item's reference, title, status pill and **its own owner**:
  - gap and risk owner;
  - content reviewers;
  - decisions show who created them and who decided them (COM-1553).

  It also shows **where it came from** ("via AC-3", or "via AC-3, AC-7"). Each row links to the item's own page, and the trail leads back to the initiative.
- Items finished before they joined (a closed gap, a closed risk) show as such. Counting comes in COM-1560.

## Notes (technical)

- `initiative_controls` (initiative_id, core_control_id, added_at, added_by; unique pair). Audited.
- Linked items are **resolved at read time** from the existing links:
  - gaps via the company's assessment for the control;
  - `risk_control_links` filtered to the initiative's company;
  - `decision_links` targeting the control or the resolved risks;
  - `content_control_links`, plus the domain's policy.
- One resolver (e.g. `core/initiatives/members.py`) returns every item with its sources. COM-1556, COM-1559 and COM-1560 all read it. Keep it set-based: an initiative with 40 controls must not issue a query per control.
- `GET /initiatives/{id}/items?kind=` serves the tabs. Mind the page tests' prefix stubs for new sub-routes (memory: subresource routes vs prefix stubs).

**Chain:** on the chain (migration + API).

**Done when:** on staging, as admin in E2E Test Company:
- adding a control that has a gap, a linked risk, a linked decision and linked content shows each on its tab, with its owner and "via" the control;
- raising a new gap on that control from its own page then shows it in the initiative without touching the initiative.