---
id: 01M0W2DWCZ073HSZEZ2KQ2BP68
created: 2026-08-25T09:01:11.455257Z
updated: 2026-08-29T08:54:42.499878Z
type: task
title: Checkboxes are clickable on surfaces that can't save them
project: 01KY6W9951TW0904DT0GGJVGE7
number: 404
sprint: segj1dz
comments:
- id: 01M16BMGPX06RQCS7V4NB6HSZS
  author: Steve Vine
  at: 2026-08-29T08:54:30.365224Z
  text: |-
    Done — PR #396 (branch `brief-404-checkbox-opt-in`).

    Both decisions in the description were taken, and the second one is recorded as ADR 0055 ("Rendered interactive controls are inert unless the surface opts in") since it's a standing rule for future surfaces, not just this fix.

    Decision 2 (the safer default), done first because it makes decision 1 checkable:
    - `renderMarkdown(src, opts)` now takes an options object, absorbing the positional `toAssetUrl`, and renders task checkboxes `disabled` unless `opts.liveTasks` is set. The compiler caught every call site, so there was no silent-default failure mode during the change.
    - Extracted the checkbox HTML as an exported `taskCheckboxHtml(checked, index, live)` so it could be unit-tested — `renderMarkdown` itself isn't testable in the node env, as DOMPurify needs a `window`. Two tests added.

    Decision 1 (make them real):
    - **Stickies** — toggle through the shared `DocHandle`: acquire on demand, `toggleTaskMarker`, `markEdited`, `flush`, `release`. It flushes immediately rather than relying on autosave, because unlike an inline sticky edit there's no focus-out to end the interaction. The flush bumps noteRev, so the canvas reloads through the existing effect.
    - **Comments** — toggled too (the description said "possibly"): the flip goes through `updateComment`, the same command the comment editor already uses, so it was a few lines and genuinely persistent.
    - **History, release notes, and Live mode's callout/code-block widgets** — left inert, which is what they always were in substance. Live mode's own checkboxes are `CheckboxWidget`, a separate path, and are unaffected.

    Problems encountered / things worth knowing at review:
    - The sticky's `iconPointerDown` calls `setPointerCapture`, which retargets the subsequent click to the sticky div and would have swallowed the checkbox click. Fixed by bailing out of the drag *and* the capture when the press lands on a task checkbox. Also guarded `ondblclick` so double-clicking a box doesn't open the inline editor.
    - Added `DocHandle.ready()`. The sticky toggle acquires a handle purely to make one edit, so it needs a point where the buffer actually holds the note rather than the empty initial state. It resolves the constructor's load and never re-reads, so it can't clobber a pane's unsaved buffer. A locked note is skipped — its buffer holds the empty placeholder body (NOT-375), and flushing a toggle against that would seal the emptiness over the real contents.
    - Svelte quirk: `<!-- svelte-ignore a b -->` with two codes on one line only suppressed the first here; splitting into two comments was needed. Existing combined uses elsewhere in the codebase may be half-effective — not chased, no warnings are firing.
    - Stale-index risk (a `data-task` index resolved against a source that moved under the render) is unchanged — the note pane has always had it, and the new surfaces inherit it rather than adding a new class of problem. Noted in the ADR consequences.

    Verification: `npm run check` (0 errors, 0 warnings), `npm run build`, `npm test` (276 tests) all green. An in-app check that a sticky checklist ticks and persists is worth doing at review.
assignee: steve
label:
- follow_up
priority: medium
task_status: review
---
Follow-up from NOT-402 (the Live-view checkbox fix), found while tracing it.

`renderMarkdown` emits task checkboxes as live, non-disabled `<input>`s on every
surface, but only the note pane implements a toggle. Everywhere else the click
flips the input natively, writes nothing, and is wiped on the next render — a
control that lies.

Affected:

- **Stickies** (`WorkspaceView.svelte`, `stickyHtml`) — a checklist on a canvas
  is exactly the "tick things off a list" case, so this is the one that matters.
  It has no `data-task` handler at all.
- **Comments** (`NoteComments.svelte`) — same, and comment text is editable, so
  a toggle could be made real.
- **History** and **release notes** — legitimately read-only, but their
  checkboxes still appear interactive.

Two decisions to make:

1. Make stickies (and possibly comments) actually toggle. The shared `DocHandle`
   is the natural route — `acquire`/`toggleTaskMarker`/`flush`/`release` — which
   also keeps any open pane on the same note in step. A sticky only holds a
   handle while being edited today, so it needs one on demand.
2. Have `renderMarkdown` render checkboxes **disabled unless the caller opts
   in**, so a surface can never again ship a checkbox with no handler behind it.
   Safer default than the current always-live.