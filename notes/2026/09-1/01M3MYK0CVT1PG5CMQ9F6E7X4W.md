---
id: 01M3MYK0CVT1PG5CMQ9F6E7X4W
created: 2026-09-28T21:26:29.531192Z
updated: 2026-09-28T22:06:23.143084Z
type: task
title: 'Website: Features page'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 486
sprint: spqrtwg
blocked_by:
- 01M3MY1APNGC5GRXYGCCWJJ9T3
comments:
- id: 01M3N0W1X7C66R52W3NS6DY9M1
  author: Steve Vine
  at: 2026-09-28T22:06:23.142909Z
  text: |-
    Built and pushed to staging (37c3219, 7660d89).
    - /features/: the design's six groups of four (Capture, Find, Plan, Write, Own, Connect), with the icon and blurb column beside the items and fading rules between groups. The data lives in src/data/features.ts.
    - Every item is checked against the app. Reworded where the design overclaimed:
      - Sticky notes live on workspace canvases, not the desktop.
      - History exists only with Git sync on.
      - The capture Type default is a setting, and every field is optional.
      - The dashboard shows open tasks, favourites, and recent and most-viewed notes; there is no "due" panel.
      - Import covers markdown files or folders.
      - The HTTP API is off until turned on.
      - Dependencies are shown, not enforced.
      - Gantt: "sprints, start and due dates", with no milestones.
    - Checked and kept as they were: tray, fuzzy search, Gantt, schedules, live editing, panes and tabs, tables, table of contents, comments, encryption, trash, semantic merge, MCP and export. There are no Pro markers.
    To look at: /features/ at desktop and phone widths, in both themes.
assignee: steve
label:
- brief
priority: medium
task_status: active
tech: null
---
The design's Features page, "Small on the surface. Deep when you need it.", from the Claude Design project "Notuvia website design".

## Scope

- [ ] Six groups (Capture, Find, Plan, Write, Own, Connect), each with an icon, a one-line blurb and four items, as in the design's `featureGroups`.
- [ ] Check each item against the app today. Watch for "Menu-bar presence" (tray), "Sticky notes", "Workspace canvas", "Schedules" and "Import and export" in particular. Any item that isn't shipped is dropped or marked as planned.
- [ ] If the pricing decision puts features behind Pro, mark them here.

**Done when:** the page matches the design at desktop and phone widths, and every item is true of the released app.