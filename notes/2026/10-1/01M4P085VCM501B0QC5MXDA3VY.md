---
id: 01M4P085VCM501B0QC5MXDA3VY
created: 2026-10-11T17:30:28.07691Z
updated: 2026-10-11T17:30:37.631545Z
type: task
title: 'Note view: roadmap entry rows break on the backend''s sparse JSON — "Add sprint" dead'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 535
sprint: sn8d5g8
assignee: steve
label:
- bug
priority: high
task_status: active
tech: null
---
Steve: "The '+Add sprint' button doesn't work in the Roadmap."

## Cause

`RoadmapEntry` in core serialises with `skip_serializing_if` on `title`, `description`, `done` and `sprints` (keeps the `roadmap:` frontmatter compact, the `Sprint` idiom). The same struct is the wire type for `load_note`, `note_roadmap` and `set_roadmap`, so an entry with no linked sprints reaches the frontend with `sprints` absent. `linkedSprints`, `sprintCandidates`, `referencedMembers` and the chart's `roadmapSprintBars` all iterate `entry.sprints`, so the row's render effect throws and the picker's `{#if}` never mounts: the button looks live but does nothing. Reproduced in the uilab with a canned backend emitting the wire shape — the roadmap row fails to render at all in Chrome.

## Agreed work

- [ ] `notes.ts`: a `fillRoadmap()` normaliser that gives every entry the full `RoadmapEntry` shape (`title`/`description` `""`, `done` false, `kind`/`start`/`end` null, `sprints` `[]`), applied on every ingress — `loadNote`, `noteRoadmap`, `setRoadmap`.
- [ ] Unit test for the normaliser.
- [ ] Doc comment on `RoadmapEntry` saying the wire is sparse and where it's filled.
