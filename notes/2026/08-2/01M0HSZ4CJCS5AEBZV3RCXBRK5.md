---
id: 01M0HSZ4CJCS5AEBZV3RCXBRK5
created: 2026-08-21T09:20:55.186616Z
updated: 2026-08-21T09:20:55.186616Z
type: task
title: Raise runner concurrency and pod CPU; scale xdist to match
label: improvement
priority: high
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 326
---
Jobs queue 2–3.5 min while the g5 node idles at ~6% CPU / 16% RAM, and two concurrent merge trains serialise behind a single runner. Raise the ARC scale-set's max concurrent runners (2–4) and the runner pod CPU request/limit, then raise the integration suite's xdist workers (`-n 4` → 6/8) to use the headroom. Expected: queue waits gone, backend-test roughly halved.