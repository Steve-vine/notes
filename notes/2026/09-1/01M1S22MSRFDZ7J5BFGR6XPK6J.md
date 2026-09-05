---
id: 01M1S22MSRFDZ7J5BFGR6XPK6J
created: 2026-09-05T15:13:01.752278Z
updated: 2026-09-05T16:14:33.642681Z
type: task
title: assessing one control carries its answers onto the next one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 564
sprint: s2fcksg
comments:
- id: 01M1S5JTZG3BD847373HVDRXFQ
  author: Steve Vine
  at: 2026-09-05T16:14:18.095958Z
  text: |-
    Done — PR #573 (https://github.com/Steve-vine/compass/pull/573), branch feature/com-564-assessment-panel-resets, base main. Independent of the Actions stack.

    `key={control.ref}` at the call site in `AssessmentsQueuePage`, as the ticket specified — the whole fix. It remounts the editor, so the form, the gap modal and any save error reset together rather than only the fields the comparison happened to look at.

    COM-543's behaviour is preserved: a refetch of the same control does not change the key, and its "Keep editing leaves the form exactly as it was" test still passes.

    The regression test is at the level the bug lives — two controls that have never been assessed. Fill in the first (notes, out of scope with the reason), Save and continue, and the second arrives blank: notes empty, applicable again, the justification field not even asked for; leaving it again asks nothing, because there is nothing to lose. Verified it fails against the old code, holding "locked down in March" on the second control.

    Still outstanding, and not something this PR touches: the six RIM assessments created between 15:06 and 15:11 today, all `implemented` at maturity 2. This stops it happening again; it does not clean up what already landed. Worth deciding which of those were meant before or after the deploy.
assignee: steve
label:
- bug
priority: urgent
task_status: review
---
Found by Steve on staging, 2026-09-05.

Assess a control, then move to another one — Next, or by clicking a different row. The unsaved-changes prompt offers **Save and continue**; it saves and moves, as it should. But the control you land on **arrives with every field already filled in with the answers you just gave the previous one**: status, maturity, applicability, notes, evidence links.

**This writes a false governance record, and it does it quietly.** The carried-over values count as unsaved changes, so the next exit offers Save and continue again — and clicking through a run persists a copy of the first control's answers onto every control after it. Nothing warns you, and the result reads like a completed assessment.

The staging data already shows the shape: six RIM assessments created between 15:06 and 15:11 today, every one `implemented` at maturity 2. **Worth checking which of those were actually meant** before this is fixed, and correcting any that were not.

## Cause

The editor panel is reused across controls, and it decides whether to reload the form by comparing the **assessment id** it last loaded. A control that has never been assessed has no assessment, so its id is *nothing* — and moving from one unassessed control to another compares nothing against nothing, concludes the record has not changed, and leaves the form exactly as you typed it.

So it bites precisely where a run does most of its work: consecutive controls that have not been assessed yet. Move to a control that *has* been assessed and the form reloads correctly, which is why it does not show up everywhere.

The panel is also rendered without a `key`, so nothing else resets either — the same instance is carried from control to control with all of its state.

## What changes

- **The panel resets when you move to a different control.** `key={control.ref}` at the call site in `AssessmentsQueuePage` is the whole fix and is the right one: it remounts the editor, so the form, the gap modal and any save error all reset together, rather than only the fields the comparison happens to look at. Correcting the identity check to include the control ref would fix the reported symptom alone and leave the rest.
- Keep the existing behaviour that a **refetch of the same control** must not clobber in-progress edits (COM-543) — keying on the control ref preserves that, since a refetch does not change the key.
- Regression test, at the level the bug lives: open an unassessed control, fill it in, move to a second unassessed control, and assert every field is back to its default. A test that uses two *assessed* controls passes today and would not have caught this.

## Related

- COM-527 — the panel that assesses beside the queue.
- COM-543 / COM-544 — the unsaved-changes guard whose Save and continue is the path Steve took.
