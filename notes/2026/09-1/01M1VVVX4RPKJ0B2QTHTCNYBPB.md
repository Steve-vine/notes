---
id: 01M1VVVX4RPKJ0B2QTHTCNYBPB
created: 2026-09-06T17:22:12.760208Z
updated: 2026-09-06T17:50:42.024265Z
type: task
title: the new decision dialog wastes half its height, then grows past the screen and traps you
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 596
sprint: s2fcksg
comments:
- id: 01M1VWWVAJQW1ZVSJ6B7Q5HN8E
  author: Steve Vine
  at: 2026-09-06T17:40:12.242202Z
  text: |-
    Done — PR #605 merged to main (squash).

    DecisionEditor takes a `fill` prop; the New decision / Supersede dialog passes it, the decision page's inline Edit does not and is unchanged. In fill mode the editor fills the dialog body, the Markdown/Preview row takes the leftover height, the Markdown box is a plain textarea that scrolls inside itself (no autosize, resize: none) — that is the ceiling — and the Preview scrolls independently. The dialog body became a flex column rather than a scrolling box, so Create and Cancel stay pinned at the bottom.

    Test added: in the dialog the Markdown box carries the scroll-inside-itself contract (resize: none, flex-grow: 1).

    Smoke test on staging: open New decision — fields at the top, buttons at the bottom, editor filling the middle even when empty; paste 100+ lines of Markdown — the box and the preview scroll, the buttons do not move.
assignee: steve
label:
- bug
priority: high
task_status: done
---
The width COM-589 gave the dialog is right. The height is wrong in both directions.

**Empty, it wastes the space.** The dialog is 85dvh tall but its contents are only as tall as they need to be, so Create and Cancel sit halfway up a mostly empty dialog.

**Full, it overflows.** The Markdown box is `autosize` with `minRows={12}` and no ceiling, so past about twelve lines it grows without limit. Keep typing and the title, and then the buttons, scroll off the screen. Combined with COM-595 — the invisible unsaved-changes prompt — there is no way out but to delete what you have written.

## Why

`NewDecisionModal` fixes the dialog's height (`85dvh`) and lets the body scroll, but the editor inside does not fill it: nothing tells the editor to be as tall as the space it is in, so it is as tall as its content and grows unbounded with it.

## Fix

Make the editor fill the dialog instead of the dialog following the editor:

- [ ] `DecisionEditor` takes a fill mode (a prop) used by the dialog and not by the decision page's inline Edit, which scrolls with its page and is fine as it is.
- [ ] In fill mode the editor's root fills the body, the Markdown/Preview row takes the leftover height (`flex: 1`, `minHeight: 0`), and **the textarea scrolls inside itself** rather than autosizing — that is what puts a ceiling on the growth.
- [ ] The Preview column scrolls independently, so a long document does not push the buttons anywhere.
- [ ] Create and Cancel stay pinned at the bottom of the dialog, visible from the first keystroke to the last.

Then the editor is the same size whether the document is empty or long, which is what the 85dvh was for.

## Related

- COM-589 — the dialog this fixes.
- COM-595 — the invisible unsaved-changes prompt. Same dialog, same testing pass; together they are what makes this a trap rather than an annoyance.
