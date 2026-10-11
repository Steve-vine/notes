---
id: 01M4P085VCM501B0QC5MXDA3VY
created: 2026-10-11T17:30:28.07691Z
updated: 2026-10-11T17:34:48.969831Z
type: task
title: 'Note view: roadmap entry rows break on the backend''s sparse JSON — "Add sprint" dead'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 535
sprint: sn8d5g8
comments:
- id: 01M4P0F5S02DF6A3X84KAEHX9Q
  author: Steve Vine
  at: 2026-10-11T17:34:17.375742Z
  text: |-
    PR #526 (branch brief-535-roadmap-sparse-wire), CI green, awaiting merge.

    Landed: `fillRoadmap()` in src/lib/notes.ts, applied in loadNote, noteRoadmap and setRoadmap; new src/lib/notes.test.ts (3 cases); a `SparseRoadmapEntry` type documenting the wire shape. Core, MCP, HTTP API and the on-disk frontmatter are unchanged.

    Verified in a uilab page (uilab/roadmap.html with a canned `invoke` in uilab/shims/core.ts, ?wire=1 emits the backend's sparse JSON): before the fix the roadmap row did not render at all in headless Chrome; after it the row renders, "Add sprint" opens the picker listing the project's sprints, and picking one links it (doc.roadmap carries the ref, no error). svelte-check 0 errors, vitest 613 passing.

    Also fixes the same crash in the Planner's Roadmap view and in the Main toolbar probe, which read noteRoadmap, and in noteDocs' removeSprint, which reads entry.sprints — all unexercised in-app so far.
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
Steve: "The '+Add sprint' button doesn't work in the Roadmap."

## Cause

`RoadmapEntry` in core serialises with `skip_serializing_if` on `title`, `description`, `done` and `sprints` (keeps the `roadmap:` frontmatter compact, the `Sprint` idiom). The same struct is the wire type for `load_note`, `note_roadmap` and `set_roadmap`, so an entry with no linked sprints reaches the frontend with `sprints` absent. `linkedSprints`, `sprintCandidates`, `referencedMembers` and the chart's `roadmapSprintBars` all iterate `entry.sprints`, so the row's render effect throws and the picker's `{#if}` never mounts: the button looks live but does nothing. Reproduced in the uilab with a canned backend emitting the wire shape — the roadmap row fails to render at all in Chrome.

## Agreed work

- [x] `notes.ts`: a `fillRoadmap()` normaliser that gives every entry the full `RoadmapEntry` shape (`title`/`description` `""`, `done` false, `kind`/`start`/`end` null, `sprints` `[]`), applied on every ingress — `loadNote`, `noteRoadmap`, `setRoadmap`.
- [x] Unit test for the normaliser.
- [x] Doc comment on `RoadmapEntry` saying the wire is sparse and where it's filled.
