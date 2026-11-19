---
id: 01M7RPAVHHCSJC9CF86EA221RB
created: 2026-11-19T01:21:58.83374Z
updated: 2026-11-19T01:22:01.650991Z
type: task
title: A green Library folder looks green, not the same as teal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1983
sprint: s2q1gxe
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found at pre-UAT of COM-1969 (staging 25f02b9c, 19 Nov).

**What happens:** in New folder / Edit folder, the Green swatch (8th) is identical to Teal (3rd): rgb(5,124,89) in light and rgb(36,129,96) in dark. A green folder's card looks exactly like a teal one. So the 13 colours are really 12.

**Cause:** the app's colour tokens (tokens.ts, FAMILY_TONE) map both `teal` and `green` to the same "good" tone, so `--mantine-color-green-*` equals `--mantine-color-teal-*` (#057c59 at shade 6). That's deliberate for status colours, where green means good everywhere.

**Fix:** give folders a green that is visibly green and distinct from teal, without changing what green means for status colours across the app (badges, compliance, "good" tones). For example, folder colours can resolve to their own shades rather than through FAMILY_TONE, or Green can use a distinct palette entry for folders only. The name stays "green", so saved folders don't change.

**Done when**
- All 13 folder colours are visibly distinct from each other in light and dark mode. A test pins that no two folder colours resolve to the same shade.
- A green folder's icon and pill read with good contrast in both schemes.
- Status colours elsewhere in the app are unchanged.
- Existing folders keep their colour (a teal folder stays teal).

Independent: frontend only.