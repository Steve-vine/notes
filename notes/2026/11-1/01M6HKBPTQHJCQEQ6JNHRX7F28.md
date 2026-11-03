---
id: 01M6HKBPTQHJCQEQ6JNHRX7F28
created: 2026-11-03T20:59:38.199003Z
updated: 2026-11-03T22:02:13.363754Z
type: task
title: Add a risk, decision or content item to an initiative directly, without a control — and leave out a linked item that isn't part of the work, listed under "Left out" and put back at any time
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1556
sprint: snyzymp
blocked_by:
- 01M6HKBB0WXGQWJP7VVGYM3W7B
assignee: steve
label:
- feature
priority: high
task_status: active
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