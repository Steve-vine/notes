---
id: 01M7GJMAQDBJSZM4A9KHF1NJ6T
created: 2026-11-15T21:43:19.533652Z
updated: 2026-11-15T22:03:47.385836Z
type: task
title: 'Browser smoke on staging fails twice after the Automation sprint: one admin''s menu now rightly shows Workflows, and the All checks status check looks in the wrong place'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1859
sprint: s7nqsy0
comments:
- id: 01M7GKSS3RJGPBENDSCNVAJ7F6
  author: Steve Vine
  at: 2026-11-15T22:03:46.680802Z
  text: |-
    Fixed and merged (PR #1854).
    - The menu test now expects admin a to see Workflows beside Evidence Collection.
    - The All checks test now finds the collected check's row and its status pill.

    Passed: I re-ran the Browser smoke against staging (the product build is unchanged; only the tests moved). All 33 tests pass, run 43766038936.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by the staging deploy of sprint "Automation - Workflows" (run 43762737877, build f8665615). The product is right; the smoke specs are out of date. Both are fix-forward.

## What was seen

- **Admin a's menu fits the role:** the spec still lists Workflows under "should not offer". COM-1849 hid it until COM-1851, which un-hid it but left the spec. Anyone who can see Evidence Collection can read workflows (ADR 0155 §7), so admin a should see Workflows.
- **Every screen opens (admin a, assessor, viewer):** All checks shows the collected check's status ("Unchecked" on CHK-2 in E2E Test Company), but the spec looks for the row with a selector that starts at `main`, inside the row, so it never finds it.

## Done when

- The roles spec expects Workflows for admin a.
- The All checks row is found and its Compliant / Non-compliant / Unchecked / Off pill is seen.
- Browser smoke is green on staging.

Independent (spec only).