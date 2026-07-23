---
id: 01KY6ZJVPS31JXW3RJAADHCTQZ
created: 2026-07-23T07:56:02.13749Z
updated: 2026-07-23T11:04:51.921901Z
type: task
title: Update feature
assignee: steve
number: 102
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sgm3rgt
---
I'd like to be able to update the app from within it rather than downloading a new copy of the dmg, over writing it etc.  Use this milestone to create the issues needed to achieve this with the following requirements.

* The running app should be able to detect that a new version is available and give the user the option to update
* The app should then download the update and install it, a restart of the app is fine
* The user shouldn't need to login or perform any command line actions
* For headless installations, there should be a command line option to upgrade to a specific version

This will mean putting the app somewhere public, that's OK, I'd like to suggest options for this but I want to keep the source code private.

---

Linear DEV-658 · Application Deployment & Update · created 2026-06-27 · done 2026-07-13