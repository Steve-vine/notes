---
id: 01M7CRT0HWVZHCWEGJ9P0TY18H
created: 2026-11-14T10:14:19.452983Z
updated: 2026-11-14T13:51:16.4279Z
type: task
title: '"Edit the reads (advanced)" on a live check gets a Cancel that closes it without saving, and its schedule and Switch off move out of it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1820
sprint: spsp226
comments:
- id: 01M7CYQBH1SW3D8QJJAWRHGCBT
  author: Steve Vine
  at: 2026-11-14T11:57:43.840797Z
  text: |-
    Built — PR #1815 (f5ed33a3), stacked on COM-1818's #1808; retargeted to main once that lands. Frontend only.

    What you now see:
    - Cancel sits beside Try it (and beside Keep these reads once tried). With nothing changed it just closes; if the reads were edited (or left unreadable) or the ticks changed, it asks first. Esc in the editor does the same.
    - Details shows "Collected: weekly · Change"; Change opens the period picker, which saves as soon as a period is chosen (and picks up COM-1815's Quarterly/Yearly).
    - The ⋯ menu ends with Switch off, behind a confirmation ("Switch CHK-14 off? Compass stops collecting it until it's switched on again. What it has already collected stays in the Evidence register.").
    - A switched-off check now has a ⋯ menu holding Switch on (also confirmed). Before, an off check had no menu at all, so nothing could switch it back on.

    Choices: the discard prompt is the app's usual one ("Unsaved changes" — Keep editing / Discard changes) rather than "Discard your changes to the reads?"; Switch off/on confirms with a browser confirm box, like Remove the rule; the period word moved off the facts line into the new "Collected:" line.

    Tests: vitest for Cancel with/without changes, Esc, the moved schedule and switch; eslint/tsc/prettier clean; full suite 4134 with one load flake (passes alone).
- id: 01M7D578EBJKXD79SCD7GD73FX
  author: Steve Vine
  at: 2026-11-14T13:51:16.427673Z
  text: |-
    Pre-UAT on staging 53965a3b (E2E Test Company): **Passed**.

    Seen on CHK-2 (ACC.13) as Admin A: Cancel beside Try it before trying and after a failed Try; with nothing changed it closes at once. Breaking the JSON then Cancel asks "Unsaved changes — Keep editing / Discard changes"; Keep editing keeps it; Esc asks again; Discard closes and reopening shows the original reads. Esc with nothing changed just closes; a whitespace-only edit doesn't ask (compared by meaning). The reads editor no longer has the schedule or Switch off. Details shows "Collected: yearly · Change"; Change opens the picker (Daily…Yearly) with Cancel. ⋯ Switch off asks "Switch CHK-2 off? Compass stops collecting it until it's switched on again. What it has already collected stays in the Evidence register."; dismissing changes nothing; accepting shows OFF and the section reads "Not automated"; the off check's ⋯ holds only Switch on ("Switch CHK-2 on? Compass collects it on its schedule again."), and accepting brings it back. Screenshots ~/compass-uat/spsp226/COM-1820/.

    Observation: switching back on moved the next collection from "early January 2027 (yearly)" to "14 Nov 2026" — switching on collects at once. CHK-2 has never captured anything this year, so that's consistent. Test data: CHK-2 switched off and back on (both in its history), schedule still yearly.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## What happened

On 2026-11-14 Steve chose **Edit the reads (advanced)** from a collected check's ⋯ menu on a control's Evidence tab. The reads editor opened, but there's no way to close it again. Checked on origin/main: `EditReads` in `collection/CollectionCard.tsx` has no Cancel. Its only button, **Keep these reads**, appears after **Try**, and it's the only thing that closes the editor (`onDone`). "Change the fields it keeps" next to it does have a Cancel.

Also found while checking: the editor carries the check's **Schedule** picker and **Switch off / Switch on**. Both save the moment they're touched, so a Cancel there wouldn't undo them, and neither is an "advanced reads" job.

## What people see

1. **Cancel** sits beside Try / Keep these reads, and is there before and after trying. It closes the editor and keeps the check exactly as it was.
2. **If something was changed** (the reads were edited, or tried with a different result), Cancel asks "Discard your changes to the reads?" first (the usual discard prompt). With no changes, it just closes.
3. **Esc** does the same as Cancel while the cursor is in the editor.
4. **After Keep these reads** the editor closes, as today.
5. **Schedule and Switch off move out of the editor** (my addition; Steve can drop it). The check's Details shows "Collected: weekly" with a Change link, and Switch off / Switch on goes in the ⋯ menu with a confirmation. Both still save at once and are recorded in the history. COM-1815's Quarterly / Yearly choices will live in the same place.

Opening Edit the reads already scrolls to it and puts the cursor in it, per COM-1818.

## Done when

- Edit the reads (advanced) can always be closed with Cancel (or Esc), and the check is unchanged.
- Cancel asks before discarding edits, and only when there are some.
- Schedule and Switch off / on are reachable from the check's Details and the ⋯ menu, not from inside the reads editor.
- Vitest covers Cancel with and without changes, Esc, and the moved schedule and switch.

**Independent** (front end only).