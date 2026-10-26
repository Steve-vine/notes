---
id: 01M5WZX1EN9EJNY3J8VGHVDNZ8
created: 2026-10-26T20:54:45.973101Z
updated: 2026-10-26T22:20:39.771923Z
type: task
title: Polaris's conversation list is twice as wide, so conversation titles can be read
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1341
sprint: s4zhkvy
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
## What Steve saw

The box that opens to show his conversations (the list button beside "New conversation" in the Polaris window) is far too small. It needs to be about twice the width.

## Behaviour

- **The list is twice as wide as today:** about 680px instead of 340px.
- **It never runs off a narrow screen.** It keeps a 16px margin each side, so on a phone it fills the width.
- **Titles get the extra room.** A title still too long for one line ends with "…", and hovering shows it in full.
- **Nothing else changes:**
  - It still opens above the list button.
  - Escape closes the list and not the window.
  - Delete still asks "Delete … for good?" on the row.
  - The list still scrolls after about eight conversations.

## Notes for the build

- `PolarisConversationsMenu.tsx`: change the Popover `width={340}` to `width="min(680px, calc(100vw - 32px))"`, or the equivalent Mantine `styles`.
- Add `title={c.title}` to the truncated Text so the full title shows on hover.
- Tests:
  - vitest that the dropdown carries the wider width and the title attribute;
  - check phone width in a real browser or Steve's smoke test.
- Independent: no API change and no migration.