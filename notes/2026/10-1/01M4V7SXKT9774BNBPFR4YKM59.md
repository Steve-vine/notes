---
id: 01M4V7SXKT9774BNBPFR4YKM59
created: 2026-10-13T18:18:41.658159Z
updated: 2026-10-13T20:01:27.775489Z
type: task
title: The role boxes on the joiner and mover forms sit two to a row, arranged by how many are shown
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 945
sprint: s192kdq
blocked_by:
- 01M4V7SFSYK1ZP44G71BVDTDWY
comments:
- id: 01M4VDP0EHWCZHXMBBRCY568G2
  author: Steve Vine
  at: 2026-10-13T20:01:24.945661Z
  text: |-
    Merged to main (PR #940, 2026-10-13). Not on staging until all seven tasks in this batch are in review.

    What to look at, on the joiner form, the mover form and the approver's edit:
    - With Additional role 2 and 3 both unticked in Role mappings: Primary role and the one Additional roles box sit side by side, half the form each.
    - With one of them ticked (two additional boxes): Primary role is full width, and the two additional boxes sit side by side on the row below.
    - With both ticked (three additional boxes): Primary role and the first additional box share the first row; the second and third share the next.
    - "Created in …" and the mover's "Changes from …" stay under Primary role, in its half.
    - On a narrow window the boxes stack in one column, in the same order.

    Different from the task text: nothing.

    Looked at in a real browser (headless Chromium, 1440 wide, stubbed data), and measured. Every box is 392 wide in the half-width cases and Primary role is 798 when it has the row to itself. Boxes on the same row start at the same height. With three roles in the first additional box and a two-line "Created in" under the primary, the second row starts below both. The mover form gave the same columns with titles set. At 700 wide all four stack.

    Technical: front end only, in JoinerRoleFields.tsx. One two-column grid; the primary spans both columns only when exactly two additional boxes are shown. The order in the page is always the primary and then the additional boxes in their own order, so the tab order does not change with the count.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Part of the POC Tweaks sprint. Needs COM-944, which decides how many Additional roles boxes a company's forms have. This is how they are arranged. It replaces the layout from COM-940 (the primary on its own line, three boxes in thirds below it).

## What people see

Every role box is half the width of the form. Which row each sits on depends on how many additional boxes the company shows:

- **One additional box:** Primary role and the additional box side by side on one row.
- **Two additional boxes:** Primary role on a row of its own, full width, and the two additional boxes side by side on the next row.
- **Three additional boxes:** Primary role and the first additional box on the first row, the second and third on the next.

And in every case:

- **"Two additional boxes" is any two**: the first and second, or the first and third.
- **The lines under Primary role stay under it**: "Created in …", the mover's "Changes from …", and the note when its filter matches no role. They sit in the primary's half and do not push the box beside it out of line: the two boxes on a row start level.
- **The same arrangement everywhere the boxes are drawn**: the new-joiner form (each joiner on a request with several), the mover form, and the approver's edit of either.
- **On a narrow window the boxes stack into one column**, in the same order.
- **Nothing but the arrangement changes**: the titles, the filters, what is offered and what is raised are as they are.

## Notes (technical)

- **Front end only**, in `access/JoinerRoleFields.tsx`. A two-column grid (`SimpleGrid cols={{ base: 1, sm: 2 }}` or `Grid` with spans), with the primary spanning both columns only when exactly two additional boxes are shown. The primary's `Stack` (box plus its lines) is one grid cell; align cells to the top.
- **Order in the markup is primary, then the additional boxes in their own order**, whatever the arrangement, so tab order and screen-reader order do not change with the count.
- **jsdom lays nothing out**, so the tests can hold the order and which boxes exist but not the arrangement. Look at all three arrangements in a real browser before it is called done, at full and narrow width, on the joiner and mover forms: the harness from COM-940 to COM-943 (`harness-keep/` in that session's scratchpad, and the headless-Chromium memory note) mounts the raise-request window directly. Put the measured positions in the PR.
- **Check a box that has grown**: an Additional roles box holding several roles is taller than the primary beside it. The row should grow with it and the next row start below.

**Done when:** on staging the joiner and mover forms show the three arrangements above as Additional role 2 and Additional role 3 are ticked and unticked in Role mappings, with every box half the form's width.