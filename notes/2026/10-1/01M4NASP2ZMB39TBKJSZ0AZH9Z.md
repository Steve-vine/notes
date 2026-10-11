---
id: 01M4NASP2ZMB39TBKJSZ0AZH9Z
created: 2026-10-11T11:15:33.087861Z
updated: 2026-10-11T12:25:53.301004Z
type: task
title: 'Note view: associated sprints on a roadmap entry, with progress'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 532
sprint: sn8d5g8
blocked_by:
- 01M4NASAMK50CJKJR5FYVJFH60
comments:
- id: 01M4NETE9AR99YR5VMGN2AER99
  author: Steve Vine
  at: 2026-10-11T12:25:52.170341Z
  text: |-
    Built and merged (squash, PR #523), CI green. The branch is deleted.

    What landed:
    - NotePane: a Sprints block under each roadmap row's meta line — one line per linked sprint ("Sprint" on a project, "Project · Sprint" on an initiative) with the progress snippet and an unlink ×; the title opens the sprint's board. "Add sprint" opens the Add-project picker idiom over the remaining candidates. Hidden when the row is collapsed.
    - Pools/progress: project → `doc.sprints` + `sprintCounts` / `barState`; initiative → each member project's `project_sprint_progress` rows, fetched for referenced members and for all members when a picker opens, refreshed on noteRev. Initiative lines read "done" when every task is done, else normal (no slippage — that needs the sprint slots).
    - `roadmap.ts` (pure, reused by NOT-534): `SprintPool`, `sprintLabel`, `sprintCandidates`, `linkedSprints`.
    - noteDocs: `addRoadmapSprint` / `removeRoadmapSprint`; `removeSprint` drops the sprint's refs locally and schedules the roadmap flush.
    - Core: the app saves sprints through `update_note`, not `ops::set_project_sprints`, so the NOT-528 cleanup never ran for the editor — `update_note` now drops this project's roadmap refs to a sprint it removed. The initiative's file converges on its next save (read-time resolution hides the ref meanwhile).

    Verification: npm check 0 errors, npm test 607 passed, npm build ok; core roadmap tests (with the new update_note case) and clippy clean; CI's cargo test --workspace green. Not run in the app.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
So that a roadmap entry can say which sprints deliver it: each expanded row gets a Sprints block where the user adds or removes existing sprints, and each associated sprint shows as a line with its task progress on the right. On a project the candidates are the project's own sprints; on an initiative they are the sprints of its member projects, shown as "Project · Sprint".

## Agreed work

- [ ] `NotePane.svelte` roadmap row body: a "Sprints" sub-list under the description. Each line: sprint title (prefixed by the project title on an initiative), the `progress` snippet (~L937) on the right, and a × to remove. An "Add sprint" control opens a picker (a `<select>` / popover listing the remaining candidates, project-grouped on an initiative); picking appends a `{project, sprint}` ref. Clicking the sprint title opens that sprint's board via `onOpenSprint` as the sprint rows do.
- [ ] Candidates: project → `doc.sprints`; initiative → `initiativeProjects` (~L637) plus `projectSprints(id)` per member project, loaded lazily when a picker opens.
- [ ] Progress: project → the existing `sprintCounts` (~L729); initiative → `project_sprint_progress(project)` from the commands task, fetched once per member project referenced by any entry, refreshed on `notes-changed`.
- [ ] Buffer mutators: `addRoadmapSprint`, `removeRoadmapSprint`; saved through `set_roadmap` like the rest of the row.
- [ ] When a sprint is deleted in the Sprints section below, drop its refs from `doc.roadmap` locally too (the core cleans the file; the buffer must not resend a stale ref and get a validation error).
- [ ] Dangling refs (a member project deleted, or a project unlinked from the initiative) are skipped on read by core — show nothing, no error.
- [ ] Tests for the buffer mutators and the candidate derivation on an initiative.

## Notes

The entry's `done` tickbox stays manual — it is not derived from the sprints' progress. If that turns out to be wanted, it is a follow-up.