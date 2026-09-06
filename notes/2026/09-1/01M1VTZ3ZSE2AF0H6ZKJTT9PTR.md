---
id: 01M1VTZ3ZSE2AF0H6ZKJTT9PTR
created: 2026-09-06T17:06:29.497357Z
updated: 2026-09-06T17:37:05.832619Z
type: task
title: on a gap with a long title, the Edit button is squeezed off the screen — you can just read "[Edi]"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 594
sprint: s2fcksg
comments:
- id: 01M1VWQ4M0JSQ5C3BKSME99MRS
  author: Steve Vine
  at: 2026-09-06T17:37:05.152085Z
  text: |-
    Done — PR #604 merged to main (squash).

    On the gap page header, the title now takes the leftover width and wraps within it (flex: 1, minWidth: 0 — on the heading when reading and on the title field when editing); the Edit button holds its size (flexShrink: 0) like the pill already does. Cancel/Save live in the description card's wrapping row and were never affected, so no change there.

    Per the task, this is one header only — no theme-wide Button rule.

    Not testable in jsdom. Smoke test on staging: open a gap with a long title — the title wraps onto more lines, the pill and Edit stay whole; press Edit and check the title field and pill still sit on one line.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
A gap whose title runs long pushes the header row past the edge of the screen. The status pill holds its size, but the **Edit** button is crushed to a sliver — "[Edi]" — so the only way to correct a gap is unreadable and barely clickable, on exactly the gaps whose titles most need correcting.

## Why

Introduced by COM-588. Its header row is a `Group` with `wrap="nowrap"` — added so the title field and the status pill stay on one line while editing — and the `Title` inside it has no width constraint. With wrapping off, a long heading takes all the room and the remaining items shrink to fit. The pill survives because the theme gives every `Badge` `flexShrink: 0` (COM-433); `Button` was never given the same, so it is the only thing left that can shrink, and it absorbs the whole overflow.

## Fix

- [ ] The title takes the leftover space and gives it back: `flex: 1` with `minWidth: 0`, and allowed to **wrap** rather than ellipsise — a gap title is a sentence somebody wrote, and clipping it loses meaning the way COM-433 argued about pills.
- [ ] The pill and the Edit button hold their size — `flexShrink: 0` on the button, matching what the theme already guarantees for the pill.
- [ ] Check the same header while editing: the `TextInput` already carries `flex: 1`, so it should be unaffected, but the Cancel/Save pair wants the same treatment.

The risk page's header does **not** have this problem — its `Group` wraps — so this is one header, not a pattern. Worth a look at the other `wrap="nowrap"` rows if it turns up again.

**Question for whoever picks this up:** a `Button` clipped mid-word is arguably worse than the truncated pills COM-433 fixed in the theme — a label you cannot read is cosmetic, an action you cannot read is not. If this recurs anywhere else, the same one-line theme rule for `Button` is the version that stays fixed. Do not do it pre-emptively on the strength of one screen.

**Not catchable in a test.** jsdom has no layout, so no Vitest assertion will see a squeezed button; this is a visual check on a gap with a deliberately long title.

## Related

- COM-588 — a gap's title and description can be corrected. The change that introduced this.
- COM-433 / COM-435 — a pill never truncates. Same family of problem, already solved in the theme for badges, pills and chips.
