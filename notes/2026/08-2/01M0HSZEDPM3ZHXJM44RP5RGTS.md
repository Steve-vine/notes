---
id: 01M0HSZEDPM3ZHXJM44RP5RGTS
created: 2026-08-21T09:21:05.462829Z
updated: 2026-08-21T09:21:05.462829Z
type: task
title: zot registry health under CI load
assignee: steve
label: chore
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 329
---
zot 502'd repeatedly during the 2026-08-20 evening merge trains (testcontainers ryuk pull failed 5 retries; a backend-test run died on it). zot is now load-bearing: pull-through mirror, base images, buildx layer cache. Check its resource limits, liveness, and concurrent-request behaviour; size it for 2–4 concurrent jobs (pairs with the runner-concurrency task).