---
id: 01M86JN94D9HG2Y0AC6VXGQEJV
created: 2026-11-24T10:47:08.173144Z
updated: 2026-11-24T10:47:08.173144Z
type: task
title: Put back answers in seconds at production's size, and the screen never shows an error for a put-back that worked
label: bug
assignee: steve
task_status: active
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2139
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