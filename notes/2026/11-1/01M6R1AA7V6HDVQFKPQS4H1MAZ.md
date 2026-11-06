---
id: 01M6R1AA7V6HDVQFKPQS4H1MAZ
created: 2026-11-06T08:58:59.195463Z
updated: 2026-11-06T08:58:59.195463Z
type: task
title: 'g5 Compass runners: roll to runner 2.338.2 (GitHub retired 2.336.0)'
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1615
---
At 08:05 GMT on 2026-11-05 GitHub stopped accepting runner 2.336.0. A runner reported Outdated, and ARC took down the whole compass-runners set, including its listener. From then on every g5 job (build-tag, deploy-staging) sat queued, and main hasn't built an image since 22:15 GMT on 2026-11-05.

Fix:
- the ci-runner image was rebuilt on 2.338.2 (zot tag `2.338.2-20261106-0854`);
- the values tag is bumped;
- Steve runs `helm upgrade` on compass-runners.