---
id: 01M4JC8T9WZJN9SECZ1MVB6QS3
created: 2026-10-10T07:43:34.204756Z
updated: 2026-10-10T10:15:01.170924Z
type: task
title: 'Planner top bar: [Projects | Tasks] toggle choosing what the columns show'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 520
sprint: sqcp1k3
blocked_by:
- 01M4JBWJHXP0TSPG7EZT6WNS30
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
So that any Planner selection can be read at either level: the sidebar picks *which* initiatives or projects are in play, and a new segmented control on the board's top bar picks whether the columns hold their **projects** or their **tasks**. It sits after the existing [Kanban | Timeline] group (`Main.svelte` `.view-seg`, DEV-949/955) in the same idiom.

## Agreed work

- [ ] `Main.svelte` top bar: a second `.view-seg` group, **Projects | Tasks**, rendered after the Kanban/Timeline group (both anchor to the right edge; the new one is outermost). `aria-label="Show projects or tasks"`.
- [ ] State: `KanbanState.cards: "projects" | "tasks"` in `tabsStorage.ts`, default `"projects"`, persisted per tab and revived with that default for older tabs.
- [ ] Effective selection: keep `active.kanban.sel` as *what the sidebar picked* and derive the board's selection from it plus the toggle in Main — do not rewrite `sel` when the toggle flips, so switching back is lossless.
  - **All Projects** — Projects: the projects board as today. Tasks: the tasks of the projects the board would show (`{ kind: "some", ids }` over those project ids — so the NOT-517/518 Show active / Show closed toggles carry through: hidden projects' tasks are hidden too).
  - **An initiative row** — Projects: that initiative's projects board (`sel.initiative`, as today). Tasks: the tasks of that initiative's projects, the same `some` selection over `initiativeProjects(id)`.
  - **A project row, All Tasks, Loose Tasks** (anything from the Tasks section, or a `some` selection) — Tasks is forced on and the **Projects** segment is disabled (`disabled` + `aria-disabled`, the muted style), with a title explaining why. The stored `cards` value is left as it was so it comes back when a projects-level row is picked again.
  - **All Initiatives** — the columns hold initiatives, which is neither; hide the control on that board (same `{#if}` gate style as the Kanban/Timeline group).
- [ ] The Kanban/Timeline group follows the effective selection: Timeline is still offered only when the effective board is the projects board, Gantt only when it is scoped to one project. A multi-project `some` board shows no time view, as today — so flipping to Tasks on All Projects while on Timeline falls back to Kanban (reuse the `ganttActive` gating, don't add a second rule).
- [ ] Board preferences (`boardScope.ts`) key off the effective selection, so the per-scope sort, view-by and filters a user set on a given task board are the ones they get here too. Note in the file comment that an initiative's Tasks board shares the key of the equivalent multi-project selection by construction.
- [ ] `KanbanView`'s `addViaForm` on the derived Tasks board pre-fills a task for a single-project `some` selection as today and no project for a multi-project one (existing behaviour, just confirm).
- [ ] Tests: `tabsStorage.test.ts` for the new field; a `.ts` helper (`effectiveBoardSel(sel, cards, projectIds)` or similar) with unit tests covering the four cases above, including the disabled rule.

## Notes

Depends on NOT-518 (the Show active / Show closed semantics the Tasks reading inherits) and on NOT-517's done-flagged rows. Pulling an initiative's project ids for the Tasks reading means one extra `initiativeProjects` call when the toggle flips — fine for a sidebar action; cache it alongside the board load if it shows.

Open question for Steve: on All Projects, should "Tasks" include **loose** tasks (making it identical to All Tasks)? This task says no — tasks of the shown projects only — since Loose Tasks has its own row.