---
id: 01KY72XPM4TAZ79HJ48CCJ6XQ8
created: 2026-07-23T08:54:23.108893Z
updated: 2026-07-23T12:24:57.577933Z
type: task
title: 'In-app update: check, prompt, download, restart'
assignee: steve
label: null
number: 322
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sgm3rgt
---
The user-facing flow (DEV-658, ADR 0042): the running app notices a new version and updates itself — no login, no command line, a restart is fine.

Scope:

* Check the R2 manifest on startup (quietly, off the critical path) and surface an unobtrusive prompt when a newer version exists: version, release notes, Update / Not now.
* A manual "Check for updates" affordance in Settings → About, which also reports "up to date" and any check error.
* Update action: download with progress, verify signature (updater plugin), install, then relaunch via the process plugin. Failures surface clearly and leave the current install untouched.
* Sensible cadence guard so a declined update doesn't re-prompt every launch of the same version.

Acceptance: with an older build installed and a newer release on R2, the app offers the update, installs it, and relaunches as the new version — verified end-to-end against the real channel.

---

Linear DEV-975 · Application Deployment & Update · created 2026-07-13 · done 2026-07-13