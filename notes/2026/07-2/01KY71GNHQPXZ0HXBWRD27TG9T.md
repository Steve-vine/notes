---
id: 01KY71GNHQPXZ0HXBWRD27TG9T
created: 2026-07-23T08:29:47.447686Z
updated: 2026-07-23T11:00:30.41889Z
type: task
title: Allow setting of default 'Type' taxonomy
assignee: steve
task_status: done
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 221
comments:
- id: 01KY71GSN83T1BZ67G3JY1P5RS
  author: Steve Vine
  at: 2026-07-23T08:29:51.655685Z
  text: |-
    Steve Vine · 2026-07-07:

    **Planned work (Claude, 2026-07-07):** a per-machine "Default Type for new notes" setting, following the theme/font pattern (localStorage store + `storage`-event mirror, so the capture window picks changes up live). The picker goes in **Settings → Taxonomies** at the top — it's a default for the Type taxonomy, sitting beside the other pool defaults. The capture form initialises its Type from the setting (instead of hardcoded memo) and resets to it after each save; the Kanban '+' path is untouched — its prefill already forces `task`, which wins over the default as specified.
- id: 01KY71GXFW313WN7SB24DTQ0X4
  author: Steve Vine
  at: 2026-07-23T08:29:55.579641Z
  text: |-
    Steve Vine · 2026-07-07:

    **Build complete — PR [#205](https://github.com/Steve-vine/notuvia/pull/205)**. "Default Type for new notes" segmented picker at the top of Settings → Taxonomies, persisted per-machine like theme/font and mirrored to the capture window live. The hotkey capture form starts on the chosen Type (window closes per save, so each open re-reads it); the Kanban '+' prefill still forces task, as specified. svelte-check/tests/build clean. Manual: set Task → Alt+Space opens on Task; Kanban '+' unaffected.
sprint: sx9znt9
label: null
---
Allow the user to set a default setting for the Type taxonomy in settings.  This setting should always be selected by default on the new note form when initiated via the hot key.  When initiated from the Kanban it should always be task.

---

Linear DEV-874 · Backlog · created 2026-07-07 · done 2026-07-07