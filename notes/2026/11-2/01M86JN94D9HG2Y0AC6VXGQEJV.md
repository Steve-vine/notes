---
id: 01M86JN94D9HG2Y0AC6VXGQEJV
created: 2026-11-24T10:47:08.173144Z
updated: 2026-11-24T14:37:45.296698Z
type: task
title: Put back answers in seconds at production's size, and the screen never shows an error for a put-back that worked
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2139
sprint: szwetpq
comments:
- id: 01M86ZVHVHWXJ91Y9NN7VB8V14
  author: Steve Vine
  at: 2026-11-24T14:37:45.201652Z
  text: |-
    Merged: #2128, 0234a65f3, 24 Nov 14:36 GMT. Migration 0912_put_back_runs (renumbered twice around sprint 125's migrations). API changed: put-back now runs in the background. ADR 0176 is Proposed, for Steve to read. Going to staging next with the rest of the sprint.

    Cause, measured at production's size (1.46 GB, 3.46M activity entries, 121 people who get mail): one put-back took 151 s, almost all of it the reminder-mail check, which worked out every person's action list twice. The activity log's size played no part.

    Built: the same put-back now takes about 20 s, and it runs in the background with progress, so the request answers at once. The mail check only works out what concerns the records being put back, and anything that's the same for everyone is worked out once. Silencing is exactly as strict as before: with it removed, both mail tests fail. The screen never reports failure for a put-back that worked. It follows the run by its own id after a dropped connection or a reload, and an unreceived request never runs late. The opened copy stays locked throughout, and a put-back is still refused during a hold or maintenance.

    Three new status routes return status only, never a file. They were added to the "no download" route list, are behind Manage backups, and refuse assistants.

    Reviews: three rounds of independent reads. Their findings were fixed with failing tests first, for example a handover error that could mark a successful put-back as failed.

    Tested: the full integration suite locally (5,901 passed; 25 AD tests couldn't set up locally because the test domain's password has expired, and CI ran them fine), plus the full CI suite. One CI run hit an existing flaky test, logged as COM-2141.

    Couldn't check yet: the backup worker's memory during a put-back at production's size, and the window in a browser (pre-UAT).
assignee: steve
label:
- bug
priority: high
task_status: review
---
Fix-forward on COM-2122, found by the COM-2124 rehearsal.

**Chain:** on the chain if the put-back API changes shape (for example to a background job). Otherwise independent.

**What happened**

At production's size (1.38 GB, 3.47M activity entries), putting back one risk took about 180 seconds when called directly, measured five times. Through the screen the request hit the 60-second proxy limit and showed a 504. The put-back carried on and landed about two minutes later, so the Admin saw an error for something that worked. The likely cause is the mail-digest calculation run before and after, to silence reminder mail (`mail_digest.owed`), but that isn't confirmed.

**Done when**

- Find the real cause by measuring on data of production's size, rather than assuming it.
- Putting back a handful of records finishes in seconds. If any part must stay slow, run the put-back as background work with progress on screen, so no request waits more than a few seconds.
- The screen never reports failure for a put-back that succeeded. If the connection drops, it shows the real outcome when it comes back.
- Reminder mail stays silenced exactly as before. The two mail tests still fail without the silencing.
- A test or timed check at realistic size shows the time.