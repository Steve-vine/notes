---
id: 01M7RPAVHHCSJC9CF86EA221RB
created: 2026-11-19T01:21:58.83374Z
updated: 2026-11-19T02:48:49.73196Z
type: task
title: A green Library folder looks green, not the same as teal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1983
sprint: s2q1gxe
comments:
- id: 01M7RQYY786TYJJJD37ATV1F8M
  author: Steve Vine
  at: 2026-11-19T01:50:25.512099Z
  text: |-
    Fixed in PR #1979, merged to main as cb56605e.

    What changes for a person:
    - In New folder and Edit folder, Green is now a leaf green that is clearly different from Teal. A green folder's card, icon and pill read green in light and dark mode.
    - Nothing else in the app changes colour. Green still means "good" everywhere, the same as teal (badges, compliance and so on).
    - Existing folders keep their colour. A folder saved as green just looks properly green now, and teal folders stay teal.

    Checks: a new test makes sure all 13 folder colours look different from each other in both modes. Green and teal used to be identical. They are now well apart, and the leaf green is held to the same contrast standard as every other colour in the app.

    Assumption: the closest pair is now violet and grape in dark mode. They were already that close before this change, are still easy to tell apart, and I left them alone because they are also status colours.
- id: 01M7RV9WA3R03ZK7GZKR9QKRJR
  author: Steve Vine
  at: 2026-11-19T02:48:49.731721Z
  text: |-
    Pre-UAT re-check (staging 0c012ebb, E2E Admin A): **Passed**.
    - Green is now rgb(54,123,36) light and rgb(54,130,35) dark, against Teal's rgb(5,124,89) and rgb(36,129,96). All 13 swatches differ in both schemes. The closest pair is Violet and Grape, still easy to tell apart.
    - A green "E2E" folder's card and pill read green in light and dark with good contrast. The folder was deleted afterwards.
    - Status colours are unchanged: --mantine-color-green-6 is still #057c59.
    Screenshots: ~/compass-uat/library/COM-1983/.
assignee: steve
label:
- bug
priority: medium
task_status: review
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