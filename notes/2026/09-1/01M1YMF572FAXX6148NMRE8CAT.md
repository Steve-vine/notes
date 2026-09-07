---
id: 01M1YMF572FAXX6148NMRE8CAT
created: 2026-09-07T19:10:38.306176Z
updated: 2026-09-07T19:31:43.606342Z
type: task
title: Filter by tier on the Controls list and the Assessments queue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 605
sprint: sqc2gdq
blocked_by:
- 01M1YNME010YPQCCD5V8GD2CF1
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Someone working the playbook, or working the assessment queue, can narrow to **Essential**, **Expected** or **Specialised** and see only those controls. Tiering 383 controls is only useful if you can act on it in the two places the work actually happens.

**Follow COM-551 exactly.** The framework filter is the same shape of problem and is already solved: one server-side query parameter, one shared picker component, dropped into both pages.

- Add `tier` to `GET /api/v1/controls`, beside `domain` and `framework` (`api/v1/controls.py`). An unknown tier 404s, as the domain and framework filters already do — an empty list would read as "no controls are Essential".
- One shared `TierFilterSelect`, alongside `FrameworkFilterSelect` in `frontend/src/frameworks/components.tsx` or its own module. Both pages use it; neither builds its own.
- `ControlsPage.tsx` — add to the existing filter Group; `useControls` already carries `domain`/`framework`.
- `AssessmentsQueuePage.tsx` — same Group. Tier is server-side, so it joins the React Query key: `['controls', domain, framework, tier]`. Domain and framework are already there for the same reason.

**The tier needs to be visible, not just filterable.** A filter for something the rows don't show is a guess. The tier belongs on the row in both tables — as a pill, per the screen conventions in `brief/information-architecture.md`.

**The tier reads the same on both pages.** It is a property of the Core control, not of a company's assessment of it, so the Controls list and the Assessments queue show the same pill for the same control. No company-specific promotion — whether a control applies to a company is applicability's job, and tier never means "not for you".

**Layout is the one thing to watch.** The Assessments queue filter bar already carries Domain, Framework, Status, Maturity and an "Owned by me" switch. Tier makes six. Check it against the screen conventions before adding a fifth Select in a row — it may want wrapping or grouping rather than another box on the end.

Sorting Essential-first is the obvious companion and is deliberately **not** in this task — it changes the queue's default order, which is its own decision.

**Blocked by** COM-606: there is no tier to filter on until it's on the control.