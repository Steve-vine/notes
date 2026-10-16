---
id: 01M51XXMBKJC9QQ36JK69PT78R
created: 2026-10-16T08:40:38.51589Z
updated: 2026-10-16T10:56:57.470318Z
type: task
title: The house style designer has Undo and Redo — buttons and Cmd/Ctrl-Z — stepping back through every change since it was opened
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 998
sprint: s2ufsxd
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Asked for in Steve's smoke test of sprint 71 (COM-990), 2026-10-16. "cmd-z doesn't currently do anything."

## What is wrong

Content ▸ House styles ▸ edit a style: nothing is saved until you press Save, but you can't take back a change. The only way back is Cancel, which throws away every change.

## What people see

- **Undo and Redo buttons** in the designer's top bar, beside Cancel and Save. Each is greyed out when there's nothing to undo or redo.
- **Keyboard:** Cmd-Z undoes, and Cmd-Shift-Z redoes (Ctrl-Z and Ctrl-Y / Ctrl-Shift-Z on Windows). They work wherever you are in the designer.
- **Everything in the style can be undone:**
  - page size and margins;
  - fonts and sizes;
  - colours;
  - the cover's options;
  - header and footer slots;
  - the classification text;
  - the name.
- **Each change is one step:**
  - a burst of typing in one box is one step, not one per letter;
  - so is dragging a slider or a colour picker.
- The preview follows each undo and redo.
- **History lasts while the designer is open.** Save or Cancel ends it, and the next visit starts fresh.
- **Not undone:**
  - **Uploading or removing a logo** happens on the server straight away, as it does now. It can't be undone; uploading the old logo again puts it back.
  - **Uploading a font** works the same way. Choosing a different font for the style can be undone.

## Technical

- `houseStyles/HouseStyleEditor.tsx` keeps the whole style as one `draft` object (plus `name`), so a history of snapshots is enough:
  - write a small `useUndoable(initial)` hook: `past[]`, `present`, `future[]`, plus `set(next, {group?})`;
  - wrap `draft` and `name` together in it;
  - **group** a change into the previous step when the key path is the same and it arrives within ~800 ms. That covers typing, sliders and colour drags. A different field, or a pause, starts a new step;
  - cap the history at ~100 steps.
- Keyboard: a `keydown` listener on the modal (Mantine `useHotkeys` with `mod+Z` / `mod+shift+Z` / `mod+Y`). `preventDefault` so the browser's own per-box undo doesn't fight the designer's. One history, whatever has focus.
- The logo `onSuccess` handlers set `logo_key` **without** recording a step (or reset the step), so undo never points at a logo the server has removed.
- Tests (Vitest):
  - change a margin and a colour, Undo twice, and both are back;
  - Redo;
  - typing "Confidential" is one step;
  - mod+Z from inside a text box undoes the designer's step;
  - both buttons are disabled when there's nothing to undo or redo.

## Done when

- [ ] Cmd-Z and the Undo button take back the last change, wherever focus is, and the preview follows.
- [ ] Redo puts it back.
- [ ] A word typed is one undo, not one per letter.
