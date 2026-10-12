---
id: 01M4RQWGQKADHZMN0BW9Q60R46
created: 2026-10-12T19:02:00.69191Z
updated: 2026-10-12T21:14:19.652662Z
type: task
title: 'Bug: Sprint and Roadmap descriptions'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 541
sprint: sd52non
comments:
- id: 01M4RZESKMNBNG6DYZ5T66M7CV
  author: Steve Vine
  at: 2026-10-12T21:14:19.635523Z
  text: |-
    Fixed in PR #533 (merged 2026-10-12).

    Cause: the description textarea's auto-grow action fitted it on mount even inside a collapsed row, where it is display:none and lays out nothing — the fit pinned it to 0px and nothing refitted when the row unfolded (expanding doesn't change the value). Closing and reopening with the row open mounted it visible, hence the workaround.

    Fix: a fit while hidden is skipped and owed; a ResizeObserver settles it the moment the field is laid out again (and refits on a width change). Covers Sprints and Roadmap rows, which share the action. Not seen in-app — worth a glance at a note with every row collapsed.
assignee: steve
priority: medium
task_status: done
tech: null
---
When opening a project note, if all sprint or roadmap items are collapsed, the descriptions are missing. Expanding them closing the note and re-opening it makes them re-appear.