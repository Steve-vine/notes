---
id: 01M1VK4PKV17PEY7FA6D0PWHAH
created: 2026-09-06T14:49:43.803383Z
updated: 2026-09-06T15:19:18.603359Z
type: task
title: the treatment plan dialog is too small to write a treatment plan in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 592
sprint: s2fcksg
comments:
- id: 01M1VMTV29NE5BRHD2GCHDEP0B
  author: Steve Vine
  at: 2026-09-06T15:19:17.833255Z
  text: |-
    Done — PR #595 merged to main (78d8446).

    Both treatment dialogs (Add and Edit) open at the `lg` width and the Description / rationale box starts six rows tall (still autosize). The width and the row count are two constants shared by both dialogs, so a change to one cannot leave the other behind. I did not go as far as one shared component — as the note says, that is a bigger change and should not be smuggled in.

    Tests open each dialog and check the width; the row count is not visible to jsdom (autosize sets no `rows` attribute) so it lives in the shared constant.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Both treatment dialogs take Mantine's default width (`md`, around 480px) and give **Description / rationale** a two-row box. That box is where somebody explains what will be done about a risk and why — the substance of the treatment, and the thing an auditor reads. Two rows in a narrow dialog invites a sentence where a paragraph belongs.

## What is needed

- [ ] Widen both dialogs — `size="lg"`, or `xl` if the fields still feel cramped once the Description box grows.
- [ ] Give Description room to start with: raise `minRows` to around 6. It is already `autosize`, so it keeps growing as somebody types; this is about what the box invites before they start.
- [ ] **Change `AddTreatmentModal` and `EditTreatmentModal` together.** They are two components with the same fields; a change to one and not the other is how they start drifting, which is the problem COM-578 and COM-583 each had to go back and undo. If they are diverging anyway, consider one shared component — but that is a bigger change than this and should not be smuggled in.

## Related

- COM-582 — a treatment plan can be corrected, the task that added the Edit dialog.
- COM-589 — the same instinct on a bigger dialog: a document deserves room to write it in.
