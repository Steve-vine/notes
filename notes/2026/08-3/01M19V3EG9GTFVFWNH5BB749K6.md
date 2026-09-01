---
id: 01M19V3EG9GTFVFWNH5BB749K6
created: 2026-08-30T17:22:31.561996Z
updated: 2026-09-01T13:55:53.018963Z
type: task
title: Stepping away from a half-finished assessment asks before it throws the work away
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 543
sprint: s2fcksg
comments:
- id: 01M1A1MBBZHEKYJPGX4RPT621C
  author: Steve Vine
  at: 2026-08-30T19:16:36.863443Z
  text: |-
    Done — PR #550, merged to main.

    Leaving a control with unsaved edits now asks: Save and continue, Discard changes, or Keep editing. Save and continue only moves on once the save succeeds; if it fails you stay on the control with your edits and the reason it failed — the panel had no way to show a failed save before, so that was added. A clean panel navigates silently, as it always did.

    Covers every way out of the open control (another row, Next, Previous, close), plus the browser's own prompt on tab close or reload.

    Structure: the panel registers what it holds and how to save it; the screen routes its exits through one guard. Dirty is the form against the loaded assessment, field by field — evidence files and gaps save through their own mutations and deliberately don't count. The registration is a ref written from an effect rather than state, so typing in the panel doesn't re-render a queue of hundreds of rows.

    Six cases pinned on the queue plus one on the panel (beforeunload armed only while dirty). The route-level hole — the left nav, browser Back — is COM-544, which reuses this dialog.
assignee: steve
label:
- bug
priority: high
task_status: done
---
On the Assessments queue, edit a control's assessment — change the status, write notes, set a maturity level — then click another control in the list, or Next/Previous, and the panel simply reloads on the new control. The edits are gone with no warning. Someone working down a filtered run loses a control's worth of typing to one stray click, and nothing on screen ever said it was at risk.

**Expected** — when the panel has unsaved edits, leaving the control asks first: **Save and continue**, **Discard changes**, or **Keep editing**. Save and continue only moves on once the save succeeds; if it fails you stay on the control with the error showing, edits intact. With nothing changed, navigation is silent as it is today.

**Covers** the ways out of the open control — clicking another row in the queue, Next, Previous, and the panel's close (X) — plus closing or reloading the browser tab, which gets the browser's own "leave site?" prompt.

**Implementation** (`components/AssessmentPanel.tsx`, `pages/AssessmentsQueuePage.tsx`)
- The panel already holds the whole edit in one `form` state initialised from the loaded assessment. Dirty = `form` differs from `fromAssessment(current)` (or `BLANK` when there is no assessment yet); no new state machine needed.
- Attachments and gaps save immediately through their own mutations and are not part of the form — they must not count as unsaved changes.
- The queue page owns the exits (`openControl`, `onNext`, `onPrevious`, `onClose`), the panel owns the dirty flag. Lift the guard so the page can ask before it navigates — pass the intended navigation through a confirm step rather than firing it directly.
- Add a `beforeunload` handler while dirty for tab close/reload.
- Tests: dirty + row click / Next / Previous / close each raise the prompt; Keep editing leaves the form untouched; Discard moves on; Save and continue navigates only after the save resolves and stays put on failure; a clean panel never prompts.

**Known remainder** — leaving the page entirely (the left nav, browser Back, or the same panel on a control's own detail page) will still drop edits without asking. Catching route changes needs `useBlocker`, which react-router v7 only provides under a data router, and the app mounts a plain `<BrowserRouter>` in `main.tsx`. Converting the router is a separate decision, not a rider on this fix.
