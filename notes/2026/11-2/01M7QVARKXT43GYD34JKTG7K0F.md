---
id: 01M7QVARKXT43GYD34JKTG7K0F
created: 2026-11-18T17:30:04.285229Z
updated: 2026-11-19T18:45:37.340161Z
type: task
title: More icons and colours to choose from for a Library folder
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1969
sprint: s2q1gxe
comments:
- id: 01M7RGG1GA98AKP1TRCFAHAFXD
  author: Steve Vine
  at: 2026-11-18T23:39:57.322382Z
  text: |-
    Merged — PR #1970, squash f5f484fa on main. No migration (the database doesn't check icon or colour names); the API's allowed lists grew.

    What changed for a person:
    - New folder and Edit folder offer 44 icons (18 new: fingerprint, certificate, clipboard-text, list-checks, file-text, archive, database, wifi-high, gear, wrench, warning, fire, lightning, target, flag, chart-line, briefcase, envelope) and 13 colours (7 new: red, green, cyan, indigo, grape, lime, grey).
    - Each has a screen-reader name ("Fingerprint", "Grey"); the current choice is marked. The icon grid wraps on a phone.
    - The original 26 icons and 6 colours are unchanged, so existing folders look the same. Colours use the colour family, never a fixed shade, so text keeps its contrast in light and dark.
    - Polaris's arrange tool accepts the new names through the same list.

    No assumptions beyond the picks already in the task.
- id: 01M7RPCC1EZE89MAYXQ4PX4RBS
  author: Steve Vine
  at: 2026-11-19T01:22:48.493866Z
  text: |-
    Pre-UAT (staging 25f02b9c, E2E Admin A): **Failed**: one defect, raised as COM-1983.
    - New folder and Edit folder offer 44 named icons and 13 colours, with the current choice marked. At 390 px the icon grid wraps with no sideways scroll. A Grape folder reads well in light and dark.
    - **Defect (COM-1983):** the Green swatch is identical to Teal: rgb(5,124,89) light and rgb(36,129,96) dark. The app's colour tokens map both to the same "good" tone, so a green folder looks exactly like a teal one, and there are really 12 colours.
    Screenshots: ~/compass-uat/library/COM-1969/ (01: swatches 3 and 8).
- id: 01M7RVAC86JS0ESZ6HNFVMB3JR
  author: Steve Vine
  at: 2026-11-19T02:49:06.054535Z
  text: 'Pre-UAT follow-up (staging 0c012ebb): the defect is fixed by COM-1983, re-checked **Passed**. Green is now its own leaf green, all 13 folder colours differ in light and dark, and status colours are unchanged.'
assignee: steve
label:
- improvement
priority: low
task_status: done
---
Steve, testing the Library on staging (18 Nov): the New folder dialog needs more icons and colours. Today it offers 26 icons and 6 colours (violet, blue, teal, orange, pink, amber).

**Add (my picks, for Steve to change)**
- **7 colours:** red, green, cyan, indigo, grape, lime and grey. That makes 13.
- **18 icons** (Phosphor, the app's set), chosen for governance and IT folders:
  - fingerprint, certificate, clipboard-text, list-checks, file-text, archive;
  - database, wifi-high, gear, wrench;
  - warning, fire, lightning, target, flag, chart-line;
  - briefcase, envelope.
  That makes 44.

**Done when**
- The New folder and Edit folder dialogs offer all of them. Each icon has a name a screen reader announces ("Fingerprint"), and the current choice is marked.
- The icon grid still fits a phone, wrapping with no sideways scroll. The colour swatches show each colour's own shade in light and dark mode.
- Every new colour reads on its folder card in both schemes: icon and pill use the colour family, never a fixed shade, so text keeps its contrast.
- Polaris's Library arrange tool accepts the new icon and colour names and lists them when asked.
- The existing 26 icons and 6 colours are unchanged, so current folders look the same.
- Tests: the API accepts each new name and refuses an unknown one. The dialog renders every option.

On the chain: the API's list of allowed icons and colours changes, which affects schema.d.ts, and so does the database's if it checks them.