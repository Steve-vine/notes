---
id: 01M7FAWK3Z1ZRP0Y4HRTZ07EWH
created: 2026-11-15T10:08:47.23192Z
updated: 2026-11-15T11:36:14.969573Z
type: task
title: A check's rule box grows to fit the whole rule instead of scrolling off the end of one line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1845
sprint: spsp226
comments:
- id: 01M7FFWPX1920Z74R5336V9CJ6
  author: Steve Vine
  at: 2026-11-15T11:36:13.985543Z
  text: |-
    Built and merged — PR #1834 (94b249c5).

    - "The rule" box grows to fit on the "Polaris proposes a rule" panel (Evidence card and Review card) and in Edit rule: it wraps up to about six lines, then scrolls. No sideways scrolling.
    - It stays one sentence: Enter adds no line break, and a pasted line break becomes a space, so the rule saves exactly as typed on one line.
    - In Edit rule, "The rule, in words" has its own full-width row, with "One item is a" below it.
    - Checked the read-only places: the rule line on the Evidence card, the check page and the Review card already wrap. The Review list's Note column deliberately shows two lines as a summary; opening the card shows it in full.
    - Tests: Vitest for the multi-line box, Enter, pasted breaks, and the Edit rule layout.

    Will be on staging with the rest of the sprint.
assignee: steve
label:
- bug
priority: low
task_status: review
---
## What happened

Steve, testing Checks (2026-11-15): when Polaris proposes a rule for a check, the rule sits in a box one line high, so a longer rule runs off the end and has to be scrolled sideways to read. That's the "Polaris proposes a rule" panel, field "The rule" (`collection/RulePanel.tsx`, a single-line `TextInput`). Editing a rule by hand has the same problem: "The rule, in words" in Edit rule is also one line, squeezed beside "One item is a".

## What people see

- **"The rule" grows to fit**, both when Polaris proposes a rule and when editing one by hand. The whole sentence wraps onto as many lines as it needs (up to about six, then it scrolls), so it can be read and edited without scrolling sideways.
- In Edit rule, "The rule, in words" takes the full width on its own row, with "One item is a" below it, instead of the two side by side.
- The rule still saves as one sentence. Pressing Enter doesn't add a line break.
- Anywhere else a check's rule is shown read-only (the check page, the Evidence card's Details, Review) already wraps. Confirm this while making the change.

## Done when

- On staging, a proposed rule of two or more lines' length shows in full on the Review card without sideways scrolling, and so does a long rule in Edit rule.
- Approving or saving keeps the sentence exactly as typed, on one line.
- Vitest covers the multi-line rule box. `screen-conventions.test.ts` still passes.

**Independent** (screen only).