---
id: 01M1YMF572FAXX6148NMRE8CAT
created: 2026-09-07T19:10:38.306176Z
updated: 2026-09-07T19:10:38.306176Z
type: task
title: Filter by tier on the Controls list and the Assessments queue
label: feature
assignee: steve
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 605
---
Someone working the playbook, or working the assessment queue, can narrow to **Essential**, **Expected** or **Specialised** and see only those controls. Tiering 383 controls is only useful if you can act on it in the two places the work actually happens.

**Follow COM-551 exactly.** The framework filter is the same shape of problem and is already solved: one server-side query parameter, one shared picker component, dropped into both pages.

- Add `tier` to `GET /api/v1/controls`, beside `domain` and `framework` (`api/v1/controls.py`). An unknown tier 404s, as the domain and framework filters already do — an empty list would read as "no controls are Essential".
- One shared `TierFilterSelect`, alongside `FrameworkFilterSelect` in `frontend/src/frameworks/components.tsx` or its own module. Both pages use it; neither builds its own.
- `ControlsPage.tsx` — add to the existing filter Group; `useControls` already carries `domain`/`framework`.
- `AssessmentsQueuePage.tsx` — same Group. Tier is server-side, so it joins the React Query key: `['controls', domain, framework, tier]`. Domain and framework are already there for the same reason.

**The tier needs to be visible, not just filterable.** A filter for something the rows don't show is a guess. The tier belongs on the row in both tables — as a pill, per the screen conventions in `brief/information-architecture.md`.

**Two things to decide while building**

- **Layout.** The Assessments queue filter bar already carries Domain, Framework, Status, Maturity and an "Owned by me" switch. Tier makes six. Check it against the screen conventions before adding a fifth Select in a row — it may want wrapping or grouping rather than another box on the end.
- **Whether the two pages can disagree.** If COM-604 lands on profile-driven tiers, the Assessments queue is company-scoped and would show the company's tier, while the Controls list is the company-agnostic playbook and would show the flat one. The same control would carry two different pills depending on the screen. That needs an answer before the filter is built, not after.

Sorting Essential-first is the obvious companion and is deliberately **not** in this task — it changes the queue's default order, which is its own decision.

**Blocked by** COM-603 (no tier data exists yet) and COM-604 (the tier count and names aren't final).