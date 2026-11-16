---
id: 01M7JWYYSCGTZSGX6JKGVMENSW
created: 2026-11-16T19:22:22.380141Z
updated: 2026-11-16T23:24:04.797389Z
type: task
title: 'Check page: move Changes to the bottom so every section is full width'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1873
sprint: s7nqsy0
comments:
- id: 01M7KASEDK5YDCZQZP8DTT6NN8
  author: Steve Vine
  at: 2026-11-16T23:24:01.842666Z
  text: |-
    Done — PR #1867, merged 8ecd83bb.
    On a collected check's page (Evidence Collection ▸ a check) there's no right-hand column any more. Details, Evidence, History and Workflows run the full width, in the same order as before, and Changes is the last section, also full width.
    A check with no changes still says "No change yet." at the bottom.
    The layout is shared, so the built-in check page (COM-1881) lays out the same way.
    To check on staging: open any collected check (e.g. CHK-7) at desktop and phone width, in light and dark.
assignee: steve
priority: medium
task_status: review
---
From Steve's testing of round 2 (staging 43d03f09).

On a check's page (Evidence Collection ▸ a check), the Changes box sits in a column on the right, which narrows everything else. Move it to the bottom of the page, under the other sections, so that every section runs the full width of the page.

**Done when**
- Changes is the last section on the check page and is full width.
- Every other section (Details, Workflows, Evidence, History) is full width. There is no right-hand column left.
- The order of the other sections is unchanged.
- It works at phone width, in light and dark, and for a check with no changes.