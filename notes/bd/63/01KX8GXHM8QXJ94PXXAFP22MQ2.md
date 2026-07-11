---
id: 01KX8GXHM8QXJ94PXXAFP22MQ2
created: 2026-07-11T12:02:30.664509286Z
updated: 2026-07-11T12:03:27.227240566Z
type: task
title: Harden CI migration append-only check against transient DNS
task_status: todo
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 20
sprint: sdm5e08
---
The append-only check's `git fetch --depth=50 origin main` has no retry and flaked twice on transient DNS (Could not resolve host: github.com) during Sprint 2, reddening a required check. Wrap the fetch in a retry loop (as the image pre-pull step already does). Small hardening; do early.