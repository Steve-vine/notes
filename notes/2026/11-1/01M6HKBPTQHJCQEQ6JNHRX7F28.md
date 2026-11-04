---
id: 01M6HKBPTQHJCQEQ6JNHRX7F28
created: 2026-11-03T20:59:38.199003Z
updated: 2026-11-04T07:45:43.146327Z
type: task
title: Add a risk, decision or content item to an initiative directly, without a control — and leave out a linked item that isn't part of the work, listed under "Left out" and put back at any time
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1556
sprint: snyzymp
blocked_by:
- 01M6HKBB0WXGQWJP7VVGYM3W7B
comments:
- id: 01M6HRH0XBNRZ31PT4ZQWGQHEY
  author: Steve Vine
  at: 2026-11-03T22:29:55.243172Z
  text: |-
    Done: PR #1570 merged (5b9b39b8), migration 0770.

    What's there:
    - **Add directly.** The Risks, Decisions and Content tabs each have an Add button (Add a risk / Add a decision / Add content), for the owner or anyone with Manage initiatives.
      - The picker offers this company's risks, and the shared decisions and content.
      - A directly added item reads "added directly" where linked ones read "via IDM.1". It shows both if a control brings it too.
      - Its row menu offers "Remove from the initiative".
    - **Leave out.** An item a control brings has "Leave out" in its row menu, with an optional reason.
      - It moves to a **Left out** list at the foot of its tab, showing who, when and why, with Put back.
      - It drops out of the tab count, and later out of actions and the percentage.
      - It stays left out whatever its links do later.

    My calls:
    - A gap can be left out, but never added directly, because gaps come with their control.
    - A directly added item is removed, not left out. Adding an item that was left out puts it back as added.
    - Decisions on a directly added risk aren't brought in. Only decisions on the controls, or on risks those controls bring, are. Add a decision directly if it's wanted.

    To test on staging (after the sprint deploys), as admin in E2E Test Company:
    1. Add a risk that isn't linked to any of the initiative's controls: it shows "added directly".
    2. Leave out the domain policy with a reason: it moves to Left out with that reason.
    3. Click Put back: it returns.
- id: 01M6HYYX5A6612XMYR1PSV7NZ6
  author: Steve Vine
  at: 2026-11-04T00:22:21.610534Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04, E2E Test Company): **Passed** (through the API; the Playwright browser wasn't connected this session).

    Steps and what I saw, as E2E Admin A on INI-1:
    1. Added R-43, a risk on no control: it shows "added directly", with no "via".
    2. Left out the IT Acceptable Use Policy with the reason "Covered by another initiative": it shows as left out, by E2E Admin A, with that reason.
    3. Put it back: it's no longer left out.
    4. Left out gap G-60: its action left the Actions tab. Put it back.

    For you to look at: the row menus, and the Left out list at the foot of a tab.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). Builds on COM-1555.

## What people see

- **Add directly.** The Risks, Decisions and Content tabs each get **Add** (owner or *Manage initiatives*), a searchable picker:
  - risks from this company;
  - decisions and content from the shared library.

  A directly added item shows **"added directly"** where a linked one shows "via AC-3". If it's also linked through a control, it shows both.
- **Leave out.** Any item a control brought has **Leave out** in its row menu, with an optional reason ("covered by the IAM initiative"):
  - it moves to a **Left out** section at the foot of its tab, showing who left it out, when and why;
  - **Put back** returns it;
  - left out means left out of the initiative's actions and percentage too (COM-1559, COM-1560).
- **What leaving out remembers.** It holds for that item even as links change. If the item is unlinked from the control and later relinked, it is still left out.
- **What leaving out isn't.** You can't leave out a control. Remove the control instead. A directly added item is removed, not left out.
- **Live.** A new gap raised on a control is never left out automatically. It always arrives in the initiative.

## Notes (technical)

- `initiative_items` (initiative_id, item_type enum risk | decision | content_item | gap, item_id, mode enum added | left_out, reason, actor and timestamp; unique on initiative + type + id). Audited.
- Gaps take only `left_out`; you can't add a gap directly, because gaps come with their control.
- The COM-1555 resolver applies it: (control-derived ∪ added) − left_out, with every source kept for display.

**Chain:** on the chain (migration + API).

**Done when:** on staging, as admin in E2E Test Company:
- a risk not linked to any of the initiative's controls can be added and shows "added directly";
- leaving out the domain policy moves it to Left out with the reason;
- Put back returns it.