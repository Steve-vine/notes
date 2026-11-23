---
id: 01M84B40D6WWXX4X0GQMSQG26D
created: 2026-11-23T13:56:53.286091Z
updated: 2026-11-23T19:36:29.535311Z
type: task
title: Browser smoke's import journey expects the import preview's new counts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2105
sprint: ssj8zkq
comments:
- id: 01M84CK812SD1YEDJ3F76GYESP
  author: Steve Vine
  at: 2026-11-23T14:22:41.186786Z
  text: |-
    Fixed and merged to main: PR #2099 (4f55c7c4d). Test only: journey 11 now expects "1 to add, 0 to update, 0 unchanged, 0 problems". No change to the app.

    Browser smoke re-run from main against staging e2248892e: green (run 45190891737).
assignee: steve
label:
- bug
priority: high
task_status: done
---
Sprint "Registers - Phase 2". Found by the Browser smoke on staging e2248892e (run 45185622599, 23 Nov 2026): 40 journeys passed, 1 failed.

## The problem
Journey 11 (import a register entry from a spreadsheet) still looks for "1 ready to add". COM-2089 changed the preview to its specified counts, "1 to add, 0 to update, 0 unchanged, 0 problems". The app is right and the journey is out of date.

## Done when
- Journey 11 expects the new counts.
- The Browser smoke is green against staging.

Test only: no change to the app, no migration, no API change. Independent.