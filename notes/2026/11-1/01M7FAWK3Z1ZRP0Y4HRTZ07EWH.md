---
id: 01M7FAWK3Z1ZRP0Y4HRTZ07EWH
created: 2026-11-15T10:08:47.23192Z
updated: 2026-11-15T14:29:42.370606Z
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
- id: 01M7FSTBB2637AB92SZ0VAKDHA
  author: Steve Vine
  at: 2026-11-15T14:29:42.37036Z
  text: |-
    **Passed** — pre-UAT, staging build 20261115-1354 (36d3de6c), E2E Test Company, as E2E Admin A, on CHK-2 (ACC.13 ▸ Evidence).

    - **Edit rule layout:** "The rule, in words" has its own full-width row (1000 px). "One item is a" sits on its own row below it.
    - **Long rule in Edit rule:**
      - Typed a 444-character rule. The box grew to 3 lines with the whole sentence visible, and no sideways scroll (scrollWidth = clientWidth).
      - Pressing Enter mid-typing added no line break.
      - Try it, then Save and approve. The live panel shows "Rule: …" as one sentence, wrapped over two lines.
    - **Long rule in the proposed-rule box:**
      - Asked Polaris to propose a rule change for CHK-2 (see COM-1846). On its Review card, "Polaris proposes a rule ▸ The rule" showed the same 444-character sentence wrapped over 3 lines, with no sideways scroll and no line break in the value.
      - Approving kept it on one line: CHK-2's page ▸ About shows it as one paragraph.
    - I couldn't fake a paste with a line break in it from the test browser (the synthetic paste inserted nothing), so the "pasted line break becomes a space" behaviour wasn't checked here. Vitest covers it.

    **Restored:** CHK-2's rule wording is back to "E2E test: no more than ten directory-role assignments grant Global Administrator."

    Screenshots: ~/compass-uat/spsp226/COM-1845/
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