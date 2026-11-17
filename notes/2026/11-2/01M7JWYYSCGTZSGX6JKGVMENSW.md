---
id: 01M7JWYYSCGTZSGX6JKGVMENSW
created: 2026-11-16T19:22:22.380141Z
updated: 2026-11-17T19:50:15.181431Z
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
- id: 01M7MJ21XN1KM01B93E1FAXJJ3
  author: Steve Vine
  at: 2026-11-17T10:50:18.420941Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Changes is the last section, full width: as E2E Admin A in E2E Test Company, opened CHC-2 (Evidence Collection ▸ All checks ▸ CHC-2). Sections run Details → Evidence → History → Workflows → Changes, every one spanning the page (all start at the left margin and end at the right; no right-hand column). Passed.
    - Every other section full width, order unchanged: Details, Evidence, History, Workflows all full width, in the same order as round 2. Polaris's verdict and its proposal sit above them, also full width. Passed.
    - Phone width, light and dark, a check with no changes: checked CHC-2 at 390px wide in dark, and at desktop width in light and dark. Sections stack in order and read fine. A check with no changes: Test Company's CHC-7 (opened while looking at COM-1878) ends with "Changes — No change yet." at the bottom. Passed. One small thing: at phone width the Workflows table is about 40px wider than the screen, so the page moves sideways a little. Noted as an observation, not a failure.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1873/
assignee: steve
priority: medium
task_status: done
---
From Steve's testing of round 2 (staging 43d03f09).

On a check's page (Evidence Collection ▸ a check), the Changes box sits in a column on the right, which narrows everything else. Move it to the bottom of the page, under the other sections, so that every section runs the full width of the page.

**Done when**
- Changes is the last section on the check page and is full width.
- Every other section (Details, Workflows, Evidence, History) is full width. There is no right-hand column left.
- The order of the other sections is unchanged.
- It works at phone width, in light and dark, and for a check with no changes.