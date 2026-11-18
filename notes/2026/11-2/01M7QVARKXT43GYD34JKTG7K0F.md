---
id: 01M7QVARKXT43GYD34JKTG7K0F
created: 2026-11-18T17:30:04.285229Z
updated: 2026-11-18T17:30:09.781909Z
type: task
title: More icons and colours to choose from for a Library folder
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1969
sprint: s2q1gxe
assignee: steve
label:
- improvement
priority: low
task_status: todo
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