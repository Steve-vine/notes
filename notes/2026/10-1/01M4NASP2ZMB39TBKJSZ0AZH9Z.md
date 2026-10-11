---
id: 01M4NASP2ZMB39TBKJSZ0AZH9Z
created: 2026-10-11T11:15:33.087861Z
updated: 2026-10-11T11:15:33.087861Z
type: task
title: 'Note view: associated sprints on a roadmap entry, with progress'
priority: medium
task_status: backlog
label: feature
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 532
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