---
id: 01M7Q5N3CRQQZPRAECZXNSFK6A
created: 2026-11-18T11:11:14.328306Z
updated: 2026-11-19T18:45:28.79665Z
type: task
title: Browser smoke journey 6b passes again after Done waits for the flowchart's picture
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1937
sprint: s6y6p7g
comments:
- id: 01M7Q6EQ20YZ9RN5YNZ1CA4MW6
  author: Steve Vine
  at: 2026-11-18T11:25:13.664422Z
  text: |-
    Done — PR #1930, merged 9d0c107d.
    Done on the canvas closes it reliably. Since COM-1936 it saves the chart with its picture first, about 0.16 s, as tester A found, and closes even if a save fails.
    The browser journey was racing that close: it looked for "Description" while the canvas was still saving and found two boxes. It now waits for the canvas to close first.
    The canvas's box is now "Step description", and the standalone flowchart's is "Flowchart description" (the panel is still headed Description). Screen readers and tests can no longer mistake one for the other.
    To check on staging: the next Browser smoke should be green on journey 6b.
assignee: steve
label:
- bug
priority: high
task_status: done
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