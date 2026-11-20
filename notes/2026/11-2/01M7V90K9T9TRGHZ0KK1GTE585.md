---
id: 01M7V90K9T9TRGHZ0KK1GTE585
created: 2026-11-20T01:26:54.522013Z
updated: 2026-11-20T01:56:18.214226Z
type: task
title: A new standalone flowchart opens with its Start shape again
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2016
sprint: s6y6p7g
comments:
- id: 01M7VAP9M8T70KP493E1EBZ8TJ
  author: Steve Vine
  at: 2026-11-20T01:56:14.088752Z
  text: |-
    Done — PR #2011, merged d8749c62.
    A new standalone flowchart (New content ▸ Flowchart ▸ Edit ▸ Draw the flowchart) now opens on a Start shape. It's the same starting chart a document's own new flowchart gets. A flowchart that's already drawn opens exactly as it was saved. Cancel on an untouched new canvas has nothing to discard.
    The canvas still waits for the house style so it opens in its colours, but never more than about three seconds. That now holds even when Compass can't find out which house style it is, so the canvas always opens.
    Cause: COM-2014 didn't break this. A standalone flowchart has opened empty since it was first built. COM-2013's new smoke step was the first to expect a Start there.
    Checked: journeys 6 and 6b both pass against a local copy of Compass, including COM-2013's end-handle drag. With the fix taken out, 6b fails at the same line as on staging.
    Assumption: a saved flowchart whose shapes were all deleted also reopens with a Start.
    To check on staging: the Browser smoke's journey 6b is green after the next deploy.
assignee: steve
label:
- bug
priority: urgent
task_status: review
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