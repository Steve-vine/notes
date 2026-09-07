---
id: 01M1VHC5CTX30QTP3J4NNE068A
created: 2026-09-06T14:18:51.162218Z
updated: 2026-09-06T17:03:21.236527Z
type: task
title: in light mode a panel has no surface colour of its own — white on white, held together by a pale border
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 587
sprint: s2fcksg
comments:
- id: 01M1VN3N36MEWMHS9ME2GV5J2B
  author: Steve Vine
  at: 2026-09-06T15:24:06.62989Z
  text: |-
    Done — PR #597 merged to main.

    In light mode the page body is now gray-0 and panels stay white, so a card is the lighter thing standing on a faint ground — the light-mode counterpart of what dark mode does with its border. Set on the body, not on --mantine-color-body, so the cards did not move with the page. The header and navbar paint the body colour themselves, so they stay white and stand off the page like a card. Dark mode is untouched.

    One thing the walk turned up that the note did not list: a register's table sits straight on the page, not in a card, and its row stripes are gray-0 — the ground's new colour — so the stripes would have vanished. A table now paints the body colour in light mode, reading as a white sheet on the ground with its stripes and sticky header intact; inside a card that is white on white and nothing changes.

    Walked: the vendor criticality / access-level pickers, the portal settings preview card, the grouped tables, both shells, and a modal — all unchanged.

    Worth your eye on staging: gray-0 is the subtle end. If it is too faint on a bright display, gray-1 is the one-token step up.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
In light mode, cards and panels are the same white as the page behind them. The only thing separating a panel from the page is a very pale grey line, so a screen of stacked cards reads as one flat sheet with faint rules across it. In dark mode the same screens read correctly.

## Why

Mantine paints a `Paper`/`Card` in `--mantine-color-body` — the page colour — in **both** schemes. Dark mode gets away with it on the border: `dark-4` against a `dark-7` ground is a real edge, and the `sm` shadow reads on a dark surface. Light mode's border is `gray-3` on white, and the shadow is all but invisible there.

So dark mode was never given a special panel colour. Light mode simply has nothing doing the separating.

## Fix

Give the page a ground and let panels stay white — the panel becomes the lighter thing, which is the light-mode counterpart of what dark mode already does:

- [ ] In light mode only, paint the page a faint grey (`gray-0`, `gray-1` if that's too subtle on a bright display). Set it on the body ground, **not** by changing `--mantine-color-body` — `Paper` reads that variable, so changing it moves the cards too and nothing is gained.
- [ ] Leave dark mode exactly as it is.
- [ ] Walk the screens where a card sits on another card or on a tinted surface, which is where a new ground shows up worst: the vendor criticality and access-level pickers and the portal settings card (they set their own `bg`), the grouped tables in `index.css`, and both shells — the vendor portal has its own layout.
- [ ] Check a modal: its body is `Paper` too, and it sits on the overlay rather than the page.

The cheaper alternative — darkening the card border and leaving both surfaces white — was considered and not chosen. It makes the edge findable but leaves every panel still the same colour as the page, which is the actual complaint.

**Worth your eye before it ships**: this touches the ground under every screen in the app, and there is a judgement call in how far to drop it.

## Related

- COM-586 — the invisible calendar icon, same testing session, same scheme. One-line fix, deliberately kept separate.
- ADR 0022 — the design theme these tokens belong to.
