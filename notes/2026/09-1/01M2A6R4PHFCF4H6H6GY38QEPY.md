---
id: 01M2A6R4PHFCF4H6H6GY38QEPY
created: 2026-09-12T07:01:45.809334Z
updated: 2026-09-12T08:37:24.768416Z
type: task
title: RTO and RPO — the Minutes/Hours unit is selectable but invisible
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 683
sprint: skdc1az
comments:
- id: 01M2A8AZW0BGJEJAZ68D0MHX3Q
  author: Steve Vine
  at: 2026-09-12T07:29:32.03208Z
  text: |-
    Done — PR #690 merged to main (f906c38).

    Cause, measured in headless Chromium 140: the unit picker was a Select inside the number field's right section. A Mantine input publishes its right-section width as a CSS custom property, which inherits, so the inner picker's own text box took the outer field's 110px as right padding inside a 112px box. The value was there, black and visible, with 2px to draw itself in.

    Fix: a native select in the right section (the Mantine recipe) carrying its own right-section width, inside a right section sized for "Minutes". Verified by eye in light and dark: "4" beside "Hours", "30" beside "Minutes"; switching to Minutes shows "Minutes" and keeps the 4. Storage in minutes is unchanged. Screenshots sent in the session; tests assert the selected unit is text in the DOM and that the inner picker's section width differs from the outer field's.

    Awaiting staging deploy with the rest of the sprint.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Smoke finding, 2026-09-12 (Steve): on the technology asset modal the RTO and RPO fields carry a unit picker (COM-676) that works — you can open it and choose — but nothing is drawn: the current unit is not visible in the field.

**Where it is**: `ObjectiveInput` in `ContainerModal.tsx` — a `NumberInput` whose `rightSection` is a `Select` with `variant="unstyled"`, `size="xs"`, `rightSectionWidth={110}`. Likely causes, check in the browser: the unstyled Select's input inherits a transparent/`--input-section-color` text colour inside the right section; the inner Select's own chevron right-section leaves the value input at zero width; or the NumberInput's right section clips overflow. A jsdom test cannot see any of this — verify by eye.

**Fix**: use the Mantine-documented recipe for a unit in a right section — a **`NativeSelect`** (`variant="unstyled"`, `rightSectionWidth` sized to the longest label, `rightSectionPointerEvents="all"`), which renders a native `<select>` the browser always paints; or, if that still fights the NumberInput, put the unit beside the number as its own small `Select` in the same `FieldRow` cell (label "Unit", or a `SegmentedControl` Minutes | Hours under the field). Either way the chosen unit must be readable without opening anything, in light and dark themes.

Keep COM-676's behaviour: stored in minutes, hours shown when the value divides by 60, switching the unit keeps the typed number; the detail page renders "4 hours" / "30 minutes".

Tests: the unit control has a visible accessible name and the current value is in the DOM as text (not only as a hidden input value); light/dark render. Screenshot in the PR.

**Acceptance**: opening a technology asset with RTO 240 shows "4" and "Hours" side by side, readable; changing to Minutes shows "Minutes"; saving stores 4 minutes as 4.