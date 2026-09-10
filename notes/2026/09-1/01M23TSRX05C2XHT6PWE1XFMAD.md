---
id: 01M23TSRX05C2XHT6PWE1XFMAD
created: 2026-09-09T19:37:29.760942Z
updated: 2026-09-10T11:11:44.937158Z
type: task
title: 'Every list links the same way: the name is a real link, and the whole row follows it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 642
sprint: sa2t9sq
comments:
- id: 01M25CYJ2NDVF38W0PVJX1Y4GN
  author: Steve Vine
  at: 2026-09-10T10:13:55.413223Z
  text: |-
    Done — merged to main in PR #657 (https://github.com/Steve-vine/compass/pull/657), squash c5dfc53.

    One rule for every list now: the name is a real link (blue, the name only), and a plain click anywhere on the row goes to the same place. Ctrl/cmd-click, middle-click, "open in new tab" and copy-link work on every row; a click on something interactive inside a row (a picker, a checkbox, a button) does that thing and does not navigate.

    Rows that used to be click-only gained a real link on their name: the Assessments queue (the control ref), Access ▸ Roles, Requests, Validation, and the portal's Recertifications. Registers that had only the blue name gained the row: Controls, Domains, Frameworks, Content, Decisions, Risks, Gaps, Vendors, Actions, the Dashboard's domain table, a domain's controls, Directory roles, the Report library, the portal's Vendors and the vendor request groups. The convention is written into brief/information-architecture.md ("A row is a link") and pinned by screen-conventions.test.ts.

    Findings, not fixed here (listed in the PR): the Access lists that open a modal with no URL of its own — Users, Groups, Devices, Conditional Access, Recertification schedules and instances, and a group's device rows — keep their click-only rows until the modal convention gives them an address.

    Smoke test: the Assessments queue (click a row, ctrl-click the ref, the selected-row highlight), the Gaps register (changing an owner or status in a row must not open the gap), Access ▸ Requests, the portal Recertifications list.

    Deploying to staging now.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Two conventions grew up for how a row in a list opens the thing it names, and they split along module lines. The Assessments queue, the portal's recertifications and nearly all of Access (users, groups, devices, roles, requests, validation, recert) make the **whole row** the click, with the text plain — most of them opening a modal or panel over the list. The core registers — Risks, Gaps, Controls, Domains, Frameworks, Content, Decisions, Vendors, Actions, the Dashboard tiles, the portal's vendors — make the **name a blue link** and the row does nothing.

**The row-click camp breaks something the conventions already promise.** `brief/information-architecture.md` says *the link stays a link*: a real anchor with a real `href`, so ctrl/cmd-click, middle-click, "open in new tab" and copy-link work, and a pasted URL resolves to a page. A `Table.Tr` with an `onClick` has none of that. You cannot open three controls in tabs from the Assessments queue the way you can three risks from the register, and a keyboard user cannot reach the row at all.

**One rule, both halves.** In every list:

- The name (or reference) cell is a **real link** — `Anchor component={Link}` with the row's `to`. Blue, as the registers are today. The link colour is for the name only, never the whole row.
- The **whole row follows the same link** on a plain left click: pointer cursor, row hover. Modifier clicks are left to the browser (they hit the anchor, or nothing). A click on anything interactive inside the row — a menu, a checkbox, a pill with its own action, a switch — does **not** navigate: test `event.target.closest('a, button, input, [role=menuitem]')` (or a `data-no-row-link` opt-out) before navigating.
- Where a row opens a **modal** rather than a page the rule holds unchanged: the modal convention already requires the modal to have its own URL, so the `to` is that URL and the anchor is real.

**Mechanics:**

- One shared component, `LinkRow` (`components/LinkRow.tsx`): renders `Table.Tr`, takes `to`, wires the click filter and the cursor, forwards `data-selected-row` and `style` so the Assessments queue's selected-row treatment still works. Its tests: plain click navigates; ctrl-click does not call navigate; a click on a button inside the row does not navigate.
- A `RowLink` (the anchor) beside it, so the name cell is one line in every list and nobody hand-rolls the `Anchor` again.
- **The sweep**: every `Table.Tr` that today has an `onClick` navigate or a `cursor: 'pointer'` becomes a `LinkRow` and gains the anchor on its name; every register that today has only the anchor gains the row. ~40 files — the list from the survey is the file list of `grep -rl "Table.Tr" src | grep -v test`; the Admin sections and read-only tables (Activity, Coverage, rubrics) have no row link and stay as they are.
- A paragraph in `brief/information-architecture.md` → *Screen conventions*: "A row is a link" — the rule, the blue-name-only decision, and the interactive-cell exception, so the next list copies it.

Not in this task: changing what any row opens (page vs modal), and the Access lists that open a modal without a URL of their own — if any exist, they are a finding for the modal convention, listed in the PR, not fixed here.