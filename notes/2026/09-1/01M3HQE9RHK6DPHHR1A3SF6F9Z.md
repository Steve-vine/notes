---
id: 01M3HQE9RHK6DPHHR1A3SF6F9Z
created: 2026-09-27T15:23:51.953499Z
updated: 2026-10-10T17:01:45.449851Z
type: task
title: Mermaid diagrams from ```mermaid fences
project: 01KY6W9951TW0904DT0GGJVGE7
number: 459
sprint: s9peyxr
comments:
- id: 01M4KC6VF94WJN201B5HM10DSQ
  author: Steve Vine
  at: 2026-10-10T17:01:44.297194Z
  text: |-
    Done in PR #517 (branch brief-459-mermaid).

    What was done: a ```mermaid fence draws as a diagram in Read and Live. The read renderer only tags the code box (data-mermaid) and stays synchronous; src/lib/mermaid.ts loads mermaid on first use via a dynamic import (its own Vite chunk, so start-up is unchanged and a note with no diagram never loads it) and draws into tagged boxes: the note pane after each render, the Live code widget when it mounts (then CodeMirror re-measures). Once drawn the code and header hide, the copy button stays and copies the source, and clicking the diagram in Live drops the caret into the fence like any code box. A source that won't parse keeps its code box with the parser's first complaint under it. Labels are sanitised (securityLevel strict); the diagram theme follows the app theme at draw time.

    Decisions: lazy load rather than static, given the size; errors degrade to the code box rather than an empty space.

    Known limits: a diagram drawn before a theme switch keeps its colours until the note re-renders; the print stage prints the code box. Not run in the app: a visual pass is owed (flowchart, sequence diagram, a broken diagram, dark mode, Live click-to-edit).
assignee: steve
label:
- feature
priority: low
task_status: review
tech: null
---
Split from NOT-450. A ```mermaid fence renders as a plain code box in both views. Rendering it as a diagram means bundling mermaid (large) and drawing it in the read view and in Live's code-block widget, with the source shown while the cursor is inside as for any fence.