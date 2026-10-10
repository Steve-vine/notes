---
id: 01M4JKBYS3X12DXEY1HF37N51Y
created: 2026-10-10T09:47:37.123771Z
updated: 2026-10-10T12:04:28.536969Z
type: task
title: A request window asks before throwing away what you've filled in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 897
sprint: sme8esk
blocked_by:
- 01M4JJS02Q228B1F8NS4065WZE
comments:
- id: 01M4JSGPKCX4762PJZ9BK293N2
  author: Steve Vine
  at: 2026-10-10T11:35:04.044103Z
  text: |-
    Done 2026-10-10 — PR #888, merged to main as dd049cdb. On staging 2026-10-10 (dd049cdb, image staging-20261010-1133).

    What landed
    - Cancel, the X and Escape on a request window with something filled in ask first: "Unsaved changes — You have changes you haven't saved. Leaving now loses them." with Keep editing / Discard changes. Same words and look as the suggestions and new-decision windows.
    - An untouched window closes at once; submitting never asks.
    - What a window arrived holding doesn't count: delete-a-group opened from a group, change access opened from a person / group / mailbox.
    - A reload or closed tab with something filled in gets the browser's own "leave site?".
    - All six request windows (the task said four — the two group windows came for free).
    - Shared pieces: components/DiscardPrompt.tsx and components/useDiscardGuard.ts. SuggestionsModal's hand-rolled prompt now uses DiscardPrompt.

    Decided at build time (the task left it open)
    - The browser's Back button is NOT guarded. The app-wide prompt is the only thing that could ask there and it offers "Save and continue" — for a request that would mean raising it. Written into the IA brief. A no-save variant of the app-wide guard is the follow-up if Steve wants Back covered.
    - "Filled in" for a move or a leaver starts at choosing the person; for a new joiner at anything typed or picked, or a second joiner added; a typed justification counts everywhere.

    Checked
    - RequestWindows.test.tsx: untouched closes at once; Cancel / X / Escape each ask and Keep editing loses nothing; Escape on the prompt keeps the window; Discard changes closes; a justification or a chosen person counts; seeded windows don't; submit never asks.
    - vitest src/access + suggestions + assessments + screen-conventions: 49 files, 682 tests.
    - Headless Chromium on the move window: box → prompt → Keep editing, one Escape each; the prompt paints above the window; Cancel → Discard changes closes.

    Not checked: Safari; the browser's own reload prompt (it can't be driven headless).
assignee: steve
priority: medium
task_status: done
---
## What Steve asked (2026-10-10)

Follow-on from COM-896 (Escape closes the popup, not the window). Offered as a separate question — "asking 'discard your changes?' when Escape closes a window that has something filled in" — and Steve said: "Add the discard changes requester."

## Behaviour wanted

- A request window (new starter, move, leaver, change access) that has **something filled in** asks before it closes without being submitted.
- It asks on every way of closing that isn't submitting: **Escape, the X, and Cancel**. (Clicking outside a window already does nothing, app-wide.)
- The prompt is the one Compass already uses elsewhere, word for word: title "Unsaved changes", "You have changes you haven't saved. Leaving now loses them.", buttons **Keep editing** and **Discard changes**.
- **Keep editing** (and Escape on the prompt) returns to the window exactly as it was. **Discard changes** closes it.
- A window with nothing filled in closes straight away, as today. Submitting never asks.
- "Filled in" means changed from how the window opened. What Compass put there itself doesn't count — a window opened from a group or a person with that already chosen is still untouched.

## Scope

- **In:** the four request windows — all `RaiseRequestModal` kinds, wherever opened (`RequestsPage`, `UserDetailModal`, `GroupDetailModal`, `SharedMailboxDetailPage`).
- **Not in:** the other windows in the app (77 files use `Modal`; most are short forms). Build the piece so they can take it up, but converting them is its own decision.
- Already do this, leave alone: the suggestions window (`SuggestionsModal`, COM-595/601) and New decision (`NewDecisionModal`, COM-589).

## What exists to build on

- `assessments/unsaved.ts` — `UNSAVED_CHANGES_MESSAGE` (the settled wording, COM-595), `useUnsavedChanges`, `useGuardedExit`.
- `assessments/UnsavedChangesProvider.tsx` — `UNSAVED_CHANGES_Z_INDEX = 300`, so the prompt paints above the window it interrupts (two modals at one z-index paint in DOM order; COM-595 was the prompt opening unseen behind its dialog).
- `SuggestionsModal.tsx` is the local-state pattern to copy: `requestClose` on Cancel / X / Escape, a second `Modal` for the prompt. Lift that into a shared piece (a hook or a small wrapper: "window that guards its own close") rather than a third hand-rolled copy, and move `SuggestionsModal` onto it if it falls out cleanly.
- `theme.ts` already sets `closeOnClickOutside: false, closeOnEscape: true` for every `Modal`.

## Build notes

- `RaiseRequestModal` passes one `onClose` to both `Modal` and `RaiseForm` (`onDone`: Cancel *and* submit success). Split them: success closes unasked, Cancel goes through the guard.
- `RaiseForm` owns the fields, so it must report "dirty" upward (as `DecisionEditor.onDraftChange` does, COM-589) or own the guard itself. Dirty per kind: subject picked, roles, group adds/removes, mailbox adds/drops, account details, Run at, justification, the joiner's fields — compared with the opening state including `initialGroupId` / `membershipSeed`.
- The "No roles after this move" confirm inside the form is a third modal on the stack — check the prompt still lands on top and Escape does one thing at a time.
- Order of Escape with COM-896 in place: popup open → closes the popup; no popup, dirty → the prompt; prompt open → Keep editing; clean → closes.
- **Browser Back / reload / closing the tab** with a dirty request window: today the window is local state on a page, so Back loses it silently. `useUnsavedChanges` would cover it, but the app-wide prompt offers "Save and continue", and submitting a request is not a save. Either register with a no-save variant or leave Back out and say so on the task — decide at build time; do not offer a button that raises a request.

No backend change, no migration, no ADR.

## Done when

- Each of the four windows: untouched → Escape, X and Cancel close at once. With one thing changed → each of the three shows the prompt; Keep editing returns with everything intact; Discard changes closes.
- Opened pre-filled from a group or person and not touched → closes at once.
- Submit → closes, no prompt.
- Escape on the prompt closes only the prompt.
- Tests for the shared piece and for the move form (roles + a group add + a mailbox removal survive Keep editing).

## Smoke test (Steve — Safari)

1. Raise a move, pick the person and a role, add a group. Press Escape: "Unsaved changes" appears on top. Keep editing: all still there.
2. Same with the X and with Cancel.
3. Discard changes: the window closes; reopen it and it is empty.
4. Open a move and press Escape straight away: it just closes.
5. From a group's page, raise a change for that group and close without touching it: it just closes.
6. Submit a request: no prompt.
7. Repeat step 1 on a new starter and a leaver.