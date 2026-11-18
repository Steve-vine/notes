---
id: 01M7Q5N3CRQQZPRAECZXNSFK6A
created: 2026-11-18T11:11:14.328306Z
updated: 2026-11-18T11:11:28.253666Z
type: task
title: Browser smoke journey 6b passes again after Done waits for the flowchart's picture
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1937
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Staging deploy of a182f6be, 2026-11-18 11:10 GMT: Browser smoke 35/36 passed. Journey 6b ("draw a flowchart of its own and describe it") failed at journeys.spec.ts:306.
- After pressing Done, the test fills `getByRole('textbox', { name: 'Description' })`. That now matches two boxes: the standalone flowchart's Description (StandaloneFlowchart.tsx) and the selected step's Description on the canvas (FlowchartEditor.tsx).
- So the canvas was still open after Done. Since COM-1936, Done waits for the picture to be saved before closing.
- It passed at 27151cd9, before COM-1936.

**Done when**
- If Done doesn't reliably close the canvas once the picture is saved, that's fixed in the app. Otherwise the journey waits for the canvas to close before going on.
- Either way, the step's Description box isn't confused with the flowchart's: they're distinguishable by name for anyone using a screen reader.
- Browser smoke is green on staging.

Independent.