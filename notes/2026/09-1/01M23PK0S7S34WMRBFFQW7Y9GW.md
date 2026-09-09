---
id: 01M23PK0S7S34WMRBFFQW7Y9GW
created: 2026-09-09T18:23:54.151141Z
updated: 2026-09-09T18:32:03.942413Z
type: task
title: Every list loses its alternate row shading — the Assessments trial is adopted app-wide
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 633
sprint: sa2t9sq
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Asked for by Steve, 2026-09-09, after smoke-testing the COM-630 trial on the Assessments queue: adopt it everywhere.

**Change.** Every table in Compass loses its alternating row background, the way the Assessments queue did in COM-630. The thin line between rows stays, the hover highlight stays, and any row that is deliberately coloured for a reason — the selected row on the Assessments queue, the parent/child colouring on the Portal requests list, the group heading rows — keeps its colour. Only the odd/even shading goes.

**One place, not forty.** The shading is an app-wide default that most lists then repeat by hand. Turn it off in the default, remove the hand-written repeats so they cannot bring it back, and remove the Assessments queue's exception now that it is no longer an exception. After this there is no list in Compass that says "striped" at all.

---

*Implementation notes.*

1. `theme.ts:205` — `Table.extend({ defaultProps: { highlightOnHover: true, striped: 'odd', verticalSpacing: 'sm' } })` → drop `striped` (Mantine's own default is off). Update the comment at `theme.ts:49` that describes a pill "inside a striped row" — the flattening reasoning still holds against the flat body colour, the wording just no longer mentions stripes.
2. Remove the explicit `striped` prop from every `<Table striped …>` in `app/frontend/src` (about 40 sites — `git grep -n 'striped' -- 'app/frontend/src/**/*.tsx'` lists them: the Access pages and Group modal, Actions, the Admin sections, Content, Activity, Controls/Domains/Frameworks/Decisions/Gaps/Risks/Vendors registers, the Portal pages, `vendors/detail/cards.tsx`, `content/components.tsx`, `FrameworkDetailPage.tsx`). A plain prop removal — nothing else on those lines changes.
3. Remove the now-redundant `striped={false}` from `AssessmentsQueuePage.tsx:277`, `AppearanceSection.tsx:367`, `PortalVendorsPage.tsx:236` and `RequestGroupTable.tsx:65`; keep the `PortalRequestsPage.tsx:185` comment that explains why *that* list was never striped (still true, now trivially).
4. Check the Appearance preview (COM-631/632) — its sample table is the one place that shows a user what rows look like; it should show two flat rows with a line between, as the app now does.
5. Tests: `git grep 'striped'` across `*.test.tsx` — any assertion on the `mantine-Table-striped` class or `data-striped` attribute goes. Prettier on every touched file (the format gate). No backend change, no migration.

Follow-up if wanted, not in scope: the row-separator colour is a Border token in Appearance since COM-631, so if the flat lists want a slightly stronger line it is a palette tweak, not a code change.