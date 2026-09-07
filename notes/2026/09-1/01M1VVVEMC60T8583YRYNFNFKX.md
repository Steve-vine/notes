---
id: 01M1VVVEMC60T8583YRYNFNFKX
created: 2026-09-06T17:21:57.900602Z
updated: 2026-09-06T17:50:38.690455Z
type: task
title: the unsaved-changes prompt opens behind the dialog it is interrupting, so Cancel looks dead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 595
sprint: s2fcksg
comments:
- id: 01M1VWNSMB0V2ZB86HFNYBM9QN
  author: Steve Vine
  at: 2026-09-06T17:36:21.13114Z
  text: |-
    Done — PR #603 merged to main (squash).

    The guard's "Unsaved changes" prompt now has an explicit z-index one layer above Mantine's modal layer (200 → 300, exported as UNSAVED_CHANGES_Z_INDEX with the reasoning beside it), so it opens above any dialog it interrupts — Cancel, X and Escape in the New decision dialog now visibly ask.

    Test added: renders the editor inside a plain dialog, raises the prompt, asserts its --mb-z-index is the higher number.

    Wording changed from "This assessment has changes you haven't saved" to "You have changes you haven't saved. Leaving now loses them."

    Smoke test on staging: type in New decision, press Cancel — the prompt appears on top with Keep editing / Discard / Save and continue.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Type anything into the New decision dialog and press **Cancel**: nothing happens. No prompt, no close. The X and Escape do nothing either. The only way out is to delete every character — because once the form is clean nothing blocks the navigation.

The guard is working. It blocks the route change and opens its "Unsaved changes" prompt exactly as designed. **You cannot see it: it renders behind the dialog it is interrupting.**

## Why

Both are Mantine `Modal`s and neither sets a `zIndex`, so both take the default and DOM order decides which paints on top. The provider is mounted high in the tree (`App.tsx`), so its modal lands *earlier* in the document than the dialog that opened later — and loses. Confirmed by reproduction:

```
#0 title="Unsaved changes"   ← earlier in the DOM
#1 title="New decision"      ← later, so it paints on top
```

Not specific to decisions. Any editor that lives inside a dialog and registers with the guard has the same silent trap, and the trap is the worst kind — the app appears frozen and the only escape destroys the work being protected.

## Fix

- [ ] Give the provider's confirm `Modal` an explicit `zIndex` above the default modal layer. It is the thing that interrupts other dialogs, so it belongs above all of them.
- [ ] Test it: assert the confirm's `zIndex` is higher than a plain modal's. jsdom will not paint, but the ordering is a number and can be asserted.
- [ ] Check the prompt's wording while in there — it says "This assessment has changes you haven't saved", which is wrong for a decision, a gap or anything else that now uses the guard.

## Related

- COM-543 / COM-544 — the guard and the data router it needs.
- COM-589 — the dialog that surfaced it; its note assumed every exit would ask, and every exit does ask, invisibly.
- COM-596 — the same dialog's height problem, found in the same testing pass.
