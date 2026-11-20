---
id: 01M7V90K9T9TRGHZ0KK1GTE585
created: 2026-11-20T01:26:54.522013Z
updated: 2026-11-20T01:26:58.72165Z
type: task
title: A new standalone flowchart opens with its Start shape again
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2016
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: urgent
task_status: todo
---
Found by the Browser smoke on staging 0ed475e8 (run 44651228349, journey 6b). It probably came in with COM-2014, which made a standalone flowchart's page wait for its house style before opening the canvas.

**Steps:** New content ▸ Flowchart, give it a title, then Create draft ▸ Edit ▸ Draw the flowchart.

**Seen:** the canvas opens empty, with no Start shape, so journey 6b times out waiting for "Start". A document's own new flowchart still opens with Start (journey 6 passed).

Screenshot: /tmp/claude-1000/-home-steve-code-compass/8b91df11-1d81-452f-b771-cfed74aa6d2e/scratchpad/smoke-art/test-failed-1.png

**Done when**
- A new standalone flowchart opens with its Start shape, the same starting chart as a document's own new flowchart, whether the house style loads quickly, slowly or never.
- An existing standalone flowchart opens with exactly its saved shapes.
- The house style still applies to the canvas once it loads (COM-2014).
- Browser smoke journey 6b is green on staging. That includes COM-2013's step of dragging a connection's end handle.
- A unit test covers a new standalone flowchart opening with Start when the house style arrives late and when it never arrives.

Independent: frontend only.