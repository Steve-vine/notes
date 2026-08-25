---
id: 01KZ195WMCX1Y1Q3VF41KYW2ZM
created: 2026-08-02T13:03:58.092279Z
updated: 2026-08-25T09:01:11.594036Z
type: task
title: Scheduled notes details
project: 01KY6W9951TW0904DT0GGJVGE7
number: 384
sprint: segj1dz
comments:
- id: 01KZ1FHR0SQAK2GGHSQK4H2R82
  author: Steve Vine
  at: 2026-08-02T14:55:18.038338Z
  text: |-
    Done on branch not-384-schedule-target — PR #375 (commit e8e591f). New ADR 0049 records the design.

    Model (as we agreed — option A): a schedule note is an ordinary note with its own Properties/Taxonomies, plus one managed `target:` frontmatter section holding the note it mints — the target's Type + properties + taxonomies. The minted note's title and body come from the schedule note itself. Target Type can be anything (memo, task, project, sticky, even schedule).

    Backend:
    - `target` added to the canonical key order + managed keys; SCHEMA_VERSION 8→9 (I'll rebuild the debug MCP before you test in-app, per our process).
    - load_note returns the stored target, or synthesises one from a pre-existing schedule's own fields so the editor shows the current template; it migrates to `target` on the next save (never just on open).
    - mint now builds the note from `target` (any Type; task number + project taxonomy inheritance only for a project-linked task), falling back to the schedule's own fields when there's no target — so existing schedules keep firing unchanged.
    - New Rust tests cover target-overrides-own and minting a non-task type.

    Frontend: the right panel gains Target Properties + Target Taxonomies sections on a schedule note (Target Type picker + project/date/meta pickers + taxonomy editor for that type). Changing the target Type no longer touches the schedule's own type.

    Verified: cargo test -p notuvia-core 362 pass (incl. 2 new); npm run check 0/0; npm test 224 pass; cargo check --workspace + npm run build clean.

    Note: no screen-capture here, so the visual pass on the Target sections is yours. Also, because the schema bumped, the debug MCP needs rebuilding before in-app testing to avoid index-version skew. Moving to Review — say the word and I'll squash-merge #375.
- id: 01KZ8DTX42MXV594S2Y2ZPA60V
  author: Steve Vine
  at: 2026-08-05T07:40:02.047035Z
  text: 'Shipped: PR #375 (plus the rustfmt follow-up #378), released in 0.13.0. Moving to Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
When editing a scheduled note, it isn’t possible to edit the properties and taxonomies of the note to be created (target note) only the scheduled note itself. 
In the right hand pane create a 2 new sections called Target Properties and Target Taxonomies.  In here show the properties and taxonomies of the note that will be created by a scheduled note. 