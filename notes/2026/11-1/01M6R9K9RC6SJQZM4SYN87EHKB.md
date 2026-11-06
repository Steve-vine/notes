---
id: 01M6R9K9RC6SJQZM4SYN87EHKB
created: 2026-11-06T11:23:42.220872Z
updated: 2026-11-06T11:24:00.873052Z
type: task
title: 'A control''s collection card doesn''t update when a capture or Polaris job finishes: it says "being collected" or "Polaris is thinking…" until the page is reloaded'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1618
sprint: s1jcke1
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in Claude's pre-UAT pass on staging, 6 Nov 2026. Sprint "Evidence Collection - Integrations", affects COM-1600, COM-1601 and COM-1602.

## What happens

- **First capture.** After a check was approved on ACC.13, the card said "The first capture is being collected." for over a minute. The worker had filed it in 2 seconds.
- **Collect now.** It said "Collecting. The new capture shows here when it's done." indefinitely, although the job finished in a second. Only a reload showed the result.
- **Gaps.** After a rule raised a gap, the control's Gaps tab still read 0 until a reload.
- **Polaris wizard.** The wizard showed "Polaris is thinking…" for 30–60 seconds after the job had finished.

## Fix

- While a capture or Collect now is pending, the card polls (as Polaris jobs do) until the newest capture changes, then stops.
- On finishing, it refreshes the control's gaps and checks too.
- Check the Polaris job's polling interval and stop condition, so a finished job shows within a few seconds.

**Done when:** on staging, approving a check, pressing Collect now and a rule raising a gap all show their result on the card within a few seconds, with no reload; the wizard shows the proposal within a few seconds of the job finishing.

**Chain:** independent (frontend only).