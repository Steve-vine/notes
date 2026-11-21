---
id: 01M7YW3MMDAFAKAV3852EVB1GN
created: 2026-11-21T10:58:20.429557Z
updated: 2026-11-21T11:22:57.829141Z
type: task
title: Flowchart palettes tick the colour in use when Text colour is on Automatic and a lane's colours are on Default
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2067
sprint: s9hexqn
comments:
- id: 01M7YXGHQ7W54QNRJHWFHK6AA0
  author: Steve Vine
  at: 2026-11-21T11:22:52.007571Z
  text: |-
    Done and merged to main (PR #2056). This changes the screen only; no migration.

    What changes:
    - On Automatic, Text colour ticks the swatch the words are actually drawn in. Dark words on a pale step tick Text, and light words on a dark fill tick White. Hovering the ticked swatch reads "Text (Automatic)", as Fill, Border and Line do.
    - A lane's colours on Default or Automatic tick too:
      - Header ticks Light shade.
      - The first lane's Background ticks White.
      - Name colour ticks Text, or White on a dark heading of the lane's own.
      - Each ticked swatch says "(Default)" or "(Automatic)" on hover.
    - Where no single swatch is the colour in use, the Default/Automatic button itself shows as selected, tinted and with a tick. That happens on every second lane's shaded band, and when several selected shapes have different automatic text colours.
    - The same rule now covers Fill, Border and Line. A step and a note selected together on Default show Default as the choice, where before nothing was ticked.

    Checked: Vitest for each case (6 of the 7 new tests fail without the fix), and headless Chromium at the panel's 320px width in light and dark, with nothing overflowing.

    Calls for you to overturn:
    - On the dark canvas, the tick follows the colour the document is published and printed with (e.g. Light shade), not the darker shade drawn for display.
    - A shaded lane band shows the Default button as selected rather than ticking a near-match.
    - The selected-button rule applies to every palette, not just Text colour and lanes.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in Claude's pre-UAT recheck (staging d4a5f0b5a, 2026-11-21), on COM-2050.

**Steps:** on the E2E draft flowchart "E2E pre-UAT COM-2016 new standalone", select a step and look at Text colour. Then add a lane and open its colours (Header, Background, Name colour). Tried on dark and light canvas.
**Expected (COM-2050's Done when):** "The selected swatch is still clearly marked, so the colour in use can still be seen without the label."
**Seen:** no swatch is ticked in those four palettes while they're on Automatic or Default. Fill, Border and Line do tick their default swatch, and hovering it reads e.g. "Light shade (Default)".
**Screenshots:** ~/compass-uat/s9hexqn/COM-2050/step-panel-text-colour.png, lane-palettes.png, lane-palettes-light-bg.png

**Done when**
- On Automatic or Default, Text colour and each lane palette tick the swatch that matches the colour actually in use, with the hover text "<colour> (Default)" or "<colour> (Automatic)", as Fill, Border and Line do.
- Where the colour in use matches no swatch (an automatic text colour that isn't in the palette), the Default/Automatic button itself shows as the selected state, so it's still clear what's in use.
- Tests cover Text colour and a lane palette on default.

Frontend only. Independent.