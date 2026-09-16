---
id: 01M2JYGY6V0FR6VF79SX3TQR3H
created: 2026-09-15T16:31:11.067754Z
updated: 2026-09-16T13:52:01.77222Z
type: task
title: Add placeholder capability for code blocks
project: 01KY6W9951TW0904DT0GGJVGE7
number: 422
comments:
- id: 01M2N7T721QYRXAR8YH72KQ0G7
  author: Steve Vine
  at: 2026-09-16T13:52:01.087829Z
  text: |-
    Done — PR #421 (`brief-422-code-placeholders`), plus ADR 0060.

    **Built as specified**: `<|name|>` inside a fence, a field per distinct name under the block, typing substitutes into the code, multiple tags per block, and Copy takes the filled-in version.

    **Decisions made on the fly, all recorded in ADR 0060:**

    1. **The value never reaches the note.** Typing rewrites the rendered spans; the markdown keeps its tokens, clearing a field restores one, and a re-render returns the block to source. A note that silently absorbed the last value typed into it would be worse than the copy-paste-undo dance this replaces. It also makes Copy correct for free — both surfaces already copy `code.textContent`, so there's no second representation to keep in step.
    2. **ADR 0055 forced an opt-in.** The fields are interactive controls emitted by `renderMarkdown`, so they'd have appeared dead on stickies, comments, history and release notes. They now need `codeFills`, which the read view and Live's code widget pass. The placeholders themselves still render (tinted) everywhere — which parts of a snippet are blanks is content, not affordance.
    3. **An unfilled slot shows and copies as `<|name|>`.** An empty gap would hide that something needs filling, and a copy of an untouched snippet should give back what the source said.
    4. **Live mode's widget needed `ignoreEvent` to return true inside the field**, or CodeMirror treats the keystrokes as editor events and types them into the document — the trap ADR 0054's table widget documents, in the other direction. `mousedown` in the fill row is stopped too: the fall-through moves the caret into the fence, which replaces the widget and takes the field with it.
    5. **Insert menu entry** ("Code placeholder", inserts `<|name|>` with the name selected), following the precedent ADR 0057 set for `[[toc,3]]`.

    **Verified by driving the real pipeline**, not by eye: 3 fields, 1 row (only the block that needs one), every occurrence substituted, copy text = the filled-in command, light and dark; an opted-out surface renders 5 placeholder spans and 0 fields.

    `npm run check`, `npm test` (334, +11 new), `npm run build` clean. Frontend only.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech:
- svelte
---
When writing code blocks it can be helpful to pre-fill certain text before copying it but this means editing the code.
Create a feature that will allow text to be temporarily entered to complete a code block. E.g.

Within the code block use special tags <|my-text|> 
```
echo <|my-text|>
```

When this is rendered, Notuvia see's the special <| |> tags and renders a text box underneath the code block E.g.
my-text: [         ]

As the user enters text into the text box, it gets replaced in the code block so that when they click Copy it copies the code block with the replaced text.  It should be possible to add multiple replacement tags like this in a single code block.