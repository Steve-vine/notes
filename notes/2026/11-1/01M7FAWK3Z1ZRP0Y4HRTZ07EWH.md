---
id: 01M7FAWK3Z1ZRP0Y4HRTZ07EWH
created: 2026-11-15T10:08:47.23192Z
updated: 2026-11-15T10:08:50.020288Z
type: task
title: A check's rule box grows to fit the whole rule instead of scrolling off the end of one line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1845
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: todo
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