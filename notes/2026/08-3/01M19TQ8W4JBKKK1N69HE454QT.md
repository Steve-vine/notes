---
id: 01M19TQ8W4JBKKK1N69HE454QT
created: 2026-08-30T17:15:52.580098Z
updated: 2026-08-30T19:16:25.924878Z
type: task
title: The Applicable toggle only responds to its own switch and label, not the empty space beside it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 541
sprint: s2fcksg
comments:
- id: 01M1A1M0P4R29P65QRS86231R9
  author: Steve Vine
  at: 2026-08-30T19:16:25.92459Z
  text: |-
    Done — PR #549, merged to main.

    The "Applicable (in scope)" toggle is now operated by its switch and its label only; the empty space to the right does nothing. Mantine renders the whole switch as one label, and as a direct child of the panel's stack that label stretched the full card width — constraining it to its content is the whole fix. Nothing else in the panel was laid out as a full-width block switch.

    Covered in the panel's tests: the switch root carries the constraint, and a click on the label still toggles and reveals the justification field. jsdom does no layout, so the constraint itself is what's asserted rather than a click on empty space.

    The sweep across the rest of the app is COM-542.
assignee: steve
company: null
label:
- bug
priority: medium
task_status: active
---
On a control's Assessment panel, clicking anywhere on the "Applicable (in scope)" row flips it — including empty space far to the right of the words. A stray click while reading a control silently takes it out of scope, and taking a control out of scope is a decision that changes the compliance figure and opens a justification field. The hit area should be the switch and its label text, nothing more.

**Expected** — the switch itself and the words "Applicable (in scope)" toggle it. The empty space to their right does nothing.

**Implementation** (`app/frontend/src/components/AssessmentPanel.tsx`, ~line 194)
- Mantine renders the whole `Switch` as one `<label>` root, and as a direct child of the panel's `Stack` that root stretches the full card width — so the entire row is a click target. Constrain the root to its content (`w="fit-content"`, or wrap the row in a `Group`); the switch and label keep working as before.
- Check the same panel's other controls while in there — anything else laid out as a full-width block switch behaves the same way.
- Cover it in `AssessmentPanel` tests: a click on the row's trailing whitespace must leave `applicable` unchanged, while label and thumb clicks still toggle.

**Not in this task** — the app has ~20 other `<Switch>` uses and any of them sitting as a full-width block child has the same oversized hit area (Domains, Gaps, Roles, Integrations, mail preferences…). Worth a separate sweep, or a shared wrapper, if it bothers you elsewhere; this task fixes the one you hit.
