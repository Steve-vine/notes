---
id: 01KZB1EDWSEPTYMQNY9GN62VS9
created: 2026-08-06T08:01:13.625322Z
updated: 2026-08-25T09:01:11.608248Z
type: task
title: New note modal - sprint selector
project: 01KY6W9951TW0904DT0GGJVGE7
number: 396
sprint: segj1dz
comments:
- id: 01KZEENANS3JVQ8Y8KERWAT3SW
  author: Steve Vine
  at: 2026-08-07T15:49:54.485844Z
  text: |-
    PR #388. The capture window's Type / Project / Sprint dropdowns now cap at 14rem and scroll, matching the Status/Priority pills already on that row (they use MetaTaxonomyPicker, which is why Task Status already had one). The arrow-key highlight scrolls into view too — both while walking the list and on open, so a sprint far down a 35-entry list is actually visible rather than merely styled. The ghost picker opts out: its inner list already scrolls under a search box that has to stay put.

    Not visually verified — worth a look at the Sprint dropdown on a many-sprint project before merging.
assignee: steve
label: null
priority: medium
task_status: done
---
There are now so many sprints in a project of mine that the sprint selector is no-longer able to display them all. Rather than making the dropdown box bigger than the modal, add a scroll bar to it.  This should also be added to the other dropdown on the New note modal like Project, although it looks like Task Status already has one.