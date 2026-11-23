---
id: 01M84B40D6WWXX4X0GQMSQG26D
created: 2026-11-23T13:56:53.286091Z
updated: 2026-11-23T13:56:56.172805Z
type: task
title: Browser smoke's import journey expects the import preview's new counts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2105
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: high
task_status: active
---
Sprint "Registers - Phase 2". Found by the Browser smoke on staging e2248892e (run 45185622599, 23 Nov 2026): 40 journeys passed, 1 failed.

## The problem
Journey 11 (import a register entry from a spreadsheet) still looks for "1 ready to add". COM-2089 changed the preview to its specified counts, "1 to add, 0 to update, 0 unchanged, 0 problems". The app is right and the journey is out of date.

## Done when
- Journey 11 expects the new counts.
- The Browser smoke is green against staging.

Test only: no change to the app, no migration, no API change. Independent.