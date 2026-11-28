---
id: 01M8FVAM974RF9Q6MFK37V6GW7
created: 2026-11-28T01:11:46.215797Z
updated: 2026-11-28T01:11:46.215797Z
type: task
title: 'The staging Browser smoke has outgrown its 15-minute limit: every screen passes, but the deploy reads as failed'
label: bug
priority: medium
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2221
---
**Independent** (CI only). Seen twice on 28 Nov 2026 (staging cb5b5e49f and 89c46a222).

The staging deploy's Browser smoke step stops at its 15-minute limit. On 89c46a222 all 41 tests passed before it was cut off; on cb5b5e49f the 41st was cut off after 40 passes. Each time, the deploy run reads as **failed** although staging is healthy, and `gh workflow run browser-smoke.yml --ref main` passes 41/41 on its own.

## What changes
- The deploy's Browser smoke has room to finish: a longer step limit, or the accounts run in parallel. Every screen and tab is still opened for every test account.
- A real failure still reads as failed.

**Done when:** a staging deploy's run is green when all 41 pass.