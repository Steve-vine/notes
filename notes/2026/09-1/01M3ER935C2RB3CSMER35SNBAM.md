---
id: 01M3ER935C2RB3CSMER35SNBAM
created: 2026-09-26T11:40:46.636199Z
updated: 2026-09-26T12:39:25.535772Z
type: task
title: Staging's scheduler has room to run — its memory limit matches production's
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 767
sprint: s3nfes0
comments:
- id: 01M3ERCFRC7XK5K0ACN367RR14
  author: Steve Vine
  at: 2026-09-26T11:42:37.836228Z
  text: 'Fixed in PR #772, merged to main as 119de08. On staging, and on the evaluation size, the scheduler now has 256Mi of room instead of 128Mi, the same as production. Production isn''t affected; it already had 256Mi. Not yet on staging; it goes there with the next deploy.'
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found deploying sprint 60 (COM-755…761) to staging, 2026-09-26.

**What happened.** After the deploy, staging's scheduler (Beat) was killed for running out of memory five times in six minutes, and then sat at 127Mi of its 128Mi limit. While it is down, no scheduled job runs: directory sync, mailbox read, sweeps, reminders, and the new System status recorder.

**Why.** `chart/values-staging.yaml` pins Beat at 64Mi requested / 128Mi limit, a value set in DEV-845 and never revisited. The chart's own presets give Beat 128Mi / 256Mi on the production size and 64Mi / 128Mi on the evaluation size. Beat was already running close to 128Mi. COM-759/761 add two once-a-minute ticks (the second lane's heartbeat, and the recorder), and those publishes pushed it over. Production uses the preset, so it isn't affected. Measured locally, the new Beat's footprint is within about 1–2 MiB of the old one's, and it doesn't grow over time: it's a ceiling problem, not a leak.

**Change.** Staging Beat goes to 128Mi requested / 256Mi limit, matching the production preset.

**Worth considering for the evaluation size** (also 128Mi): the same ceiling applies to anyone installing with `size: evaluation`. Raise its Beat limit to 256Mi too.