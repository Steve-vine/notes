---
id: 01M2A6QS7AHPZ37MDNT5VBA0R8
created: 2026-09-12T07:01:34.058696Z
updated: 2026-09-12T07:21:44.621195Z
type: task
title: Modal field rows still do not line up when one field has a description — fix it in the browser, not the DOM test
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 682
sprint: skdc1az
assignee: steve
label:
- bug
priority: high
task_status: active
---
Smoke finding, 2026-09-12 (Steve): after COM-679 the New technology asset and New data asset modals still show inputs at different heights where one field in a row has a description (Status "Whether it is live or still being built." beside Environment / Kind; RTO beside RPO is fine because both are described).

**Why COM-679 did not fix it**: it shipped a `FieldRow` (CSS grid with `subgrid` rows; `index.css` under `[data-field-row]`) and a jsdom test, `expectLevelRow`, that checks the DOM shape. jsdom has no layout engine, so the test passes whether or not the grid takes effect in a browser. The fix was never seen working.

**This task**
1. Reproduce on staging in Chrome devtools on the New technology asset modal. Check, in order: is `[data-field-row]` `display: grid` with four rows; is each field a direct child with `display: grid; grid-template-rows: subgrid` actually applied (Mantine's own root class may win on specificity or source order — `@mantine/core/styles.css` vs `index.css`); are `.mantine-InputWrapper-label`, `-description`, `.mantine-Input-wrapper`, `-error` **direct children** of that field root, or does Mantine nest them one level deeper for `Select`/`NumberInput`; does the browser support `subgrid` (Chrome ≥ 117, Safari ≥ 16, Firefox ≥ 71 — it should).
2. Fix whichever it is. If the subgrid can be made to work, keep it and raise the selector specificity or move the rules after Mantine's. If the parts are not direct children, target them with descendant selectors scoped to the field root, or fall back to the guaranteed mechanism: **every field in a `FieldRow` renders a description slot** — an empty description (`description=" "` or a `min-height` on the description track) so the label, description and input tracks are the same height for all fields in the row. Descriptions stay above the input either way.
3. Verify by eye in the browser on all three modals (technology asset, data asset, recert Add schedule) and attach a screenshot to the PR. Then write a test that could actually fail: a Playwright-free option is a unit test on the CSS rule text (`index.css` contains the selector and property) plus the DOM-shape test; say in the PR that layout was verified by hand.
4. Update the screen-conventions note from COM-679 only if the mechanism changes.

**Acceptance**: on the three modals, every input in a row sits level with its neighbours in Chrome, with descriptions still above the inputs; screenshot in the PR.