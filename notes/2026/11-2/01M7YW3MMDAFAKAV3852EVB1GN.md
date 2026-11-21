---
id: 01M7YW3MMDAFAKAV3852EVB1GN
created: 2026-11-21T10:58:20.429557Z
updated: 2026-11-21T10:58:26.889581Z
type: task
title: Flowchart palettes tick the colour in use when Text colour is on Automatic and a lane's colours are on Default
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2067
sprint: s9hexqn
assignee: steve
label:
- bug
priority: medium
task_status: active
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