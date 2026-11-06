---
id: 01M6R9K9RC6SJQZM4SYN87EHKB
created: 2026-11-06T11:23:42.220872Z
updated: 2026-11-06T12:21:45.12183Z
type: task
title: 'A control''s collection card doesn''t update when a capture or Polaris job finishes: it says "being collected" or "Polaris is thinking…" until the page is reloaded'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1618
sprint: s1jcke1
comments:
- id: 01M6RCXHY5YZ8BJMBHES6TW2QY
  author: Steve Vine
  at: 2026-11-06T12:21:44.005501Z
  text: |-
    Done: PR #1633 merged. On staging since 63d195ce.
    - While a first capture or a Collect now is outstanding, the card asks again every 2 seconds, for at most two minutes.
    - When a capture lands or a rule is judged, the control's gaps and checks refresh too.
    - Approving a check or a rule refreshes the gaps at once.

    Re-test on ACC.13: after Collect now the card showed "8 items, taken 6 Nov 2026, 12:19" within 8 seconds, with no reload, and the "Collecting…" line went away.

    The Polaris wizard's slow result didn't reproduce: other jobs show within 2 s with the existing polling, so no change there.

    Screenshot: ~/compass-uat/s1jcke1/COM-1618/
assignee: steve
label:
- bug
priority: high
task_status: review
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