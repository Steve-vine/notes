---
id: 01M0ZSMWHYJBCJCCZHCQ8WC8BP
created: 2026-08-26T19:44:41.534453Z
updated: 2026-08-27T21:33:46.435773Z
type: task
title: Write the two rules down so the next screen is built right — pills never truncate, no subtitles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 441
sprint: smnkt3k
comments:
- id: 01M12J9B2300RN6T8MABFWS0F7
  author: Steve Vine
  at: 2026-08-27T21:33:46.435635Z
  text: |-
    Done — PR #460. Docs only; no source changed.

    A new "Screen conventions" section in brief/information-architecture.md, sitting directly after App shell — the shell is the frame, this is what goes inside it. Nothing better presented itself while writing, so your assumption held. A pointer from app/frontend/README.md with the two rules restated briefly, since that is where someone writing a screen actually is, and a line in CLAUDE.md's frontend standards.

    Written from what the sprint did rather than what it planned.

    The pill rule says where it lives and that a new screen inherits it rather than restyling its own. It names all three components Mantine draws as a pill and how each fails differently — Badge and Pill clip with an ellipsis, Chip has no overflow rule at all and spills its text over its neighbour — because that is what COM-435 had to derive from the CSS, and the next person should not have to. It also records the thing most likely to waste the next sweep's time: a fixed column width is a preference, not a cap, so once a pill refuses to clip the column simply widens. COM-435 checked all 118 and changed none. What does need fixing is a hard width on the pill itself.

    The subtitle rule carries all three exceptions the sprint found, not only the empty-state one you anticipated: a line that is the whole body of an empty state; a line that states data the title does not; and a section heading with its description inside a card. It also records the call COM-438 had to make — a paragraph at the top of a tab goes even when it teaches something, because keeping the useful ones is how the inconsistency grows back — with a note that such a rule belongs on the control it governs, as helper text.

    Two more the sprint settled are recorded alongside them: on a tabbed screen the shell owns the title and the tab's page does not repeat it (COM-437), and no screen wears a frame around the whole of itself (COM-439, COM-440).

    No ADR. You flagged that a shared pill or a page-header component would need one. Neither was introduced, and the section says why rather than leaving it implicit: StatusPill does exist, but the no-truncate rule deliberately does not live on it, because a rule there would miss every bare Badge, every MultiSelect value and every Chip. That is exactly why it is a theme override.
assignee: steve
company:
- moneypenny
label:
- chore
priority: medium
task_status: active
---
COM-433 fixed truncating pills once; COM-435 has to fix them again. Nothing in the repo says a pill must show its whole label, or that a screen does not get an explanatory line under its heading — so every new screen is free to reintroduce both, and the next sweep is only a matter of time.

## What changes

Not the app. The written rules, so the fix holds without another sweep.

## Scope

There is no design-system or UI-conventions document today — the closest is `brief/information-architecture.md`, which covers navigation and screens but says nothing about how a screen is dressed. Assume a new **Screen conventions** section there unless something better presents itself while writing it, with a pointer from `app/frontend/README.md` and a line in `CLAUDE.md` so it is found without being looked for.

Two rules, stated so someone can apply them without asking:

- **A pill shows its whole label.** No ellipsis, no clipping, no shrinking to fit. Where a pill cannot fit, the layout gives — the column widens, or the table scrolls. Say where the shared rule lives so a new screen inherits it and does not restyle its own.
- **A screen does not explain itself.** No dimmed line under a page title or a tab heading restating what the title already said. Note the one exception the sprint found: text that is the entire body of an empty state ("Select a company to see its gaps.") is content, not a subtitle, and stays.

Last task in the sprint — it records what COM-435 through COM-440 settle, so write it after they land and describe what was actually done, not what was planned.

Not an ADR: neither rule changes the architecture. If writing it turns up a decision that does — a shared pill component, say, or a page-header component every screen must use — that is worth an ADR of its own, raised separately.