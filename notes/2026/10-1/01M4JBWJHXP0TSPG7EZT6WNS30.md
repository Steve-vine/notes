---
id: 01M4JBWJHXP0TSPG7EZT6WNS30
created: 2026-10-10T07:36:53.053823Z
updated: 2026-10-10T10:06:37.576213Z
type: task
title: 'Planner sidebar: Show active / Show closed drive the boards; drop the Active and Closed rows'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 518
sprint: sqcp1k3
blocked_by:
- 01M4JBW7A36R34HXVHNFAPZ8TJ
- 01M4JCVS7M8NNS582AZJ6M441G
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
So that one pair of toggles governs status everywhere on the Planner tab. The Active Initiatives / Closed Initiatives / Active Projects / Closed Projects rows (DEV-801 scoping, extended for initiatives in NOT-514) go; the Show active / Show closed toggles from NOT-517 take over what they did to the board.

## Agreed work

- [ ] `KanbanSidebar.svelte`: remove the four scoped rows. Each section keeps its single fixed "All …" row.
- [ ] `board.ts`: drop `scope` from the `projects` and `initiatives` `BoardSel` variants; `Main.svelte` `selectProjectsBoard` / `selectInitiativesBoard` lose their argument. `tabsStorage.ts` `reviveSel` tolerates a stored `scope` (ignores it) so old tabs load.
- [ ] `KanbanView.loadBoard`: for the projects and initiatives boards, the toggles decide which status columns carry cards — Show active off empties the not-done columns, Show closed off empties the done columns (the existing DEV-804 rule: the board never changes shape, columns just empty). Unstatused counts as active. Pass the two flags as props from Main.
- [ ] The per-initiative projects board (`sel.initiative`) and the per-project task boards are unaffected by the toggles — a task board already has its own hidden-column control (`ColumnsSection`).
- [ ] `boardScope.ts` comment updated: the projects scope key is no longer "shared by active/closed narrowing" because there is no narrowing.
- [ ] Tests: `tabsStorage.test.ts` for reviving a legacy `scope`d selection; `boardScope.svelte.test.ts` if the key logic changes; a `KanbanView` column-emptying test if one exists for DEV-801 (search for it — adapt rather than add).

## Notes

Order matters: this lands after NOT-517 (which introduces the toggles). The toggles are per tab, so two Planner tabs can show different mixes — that is intended, matching how Browse's options are per tab.