---
id: 01M6R1AA7V6HDVQFKPQS4H1MAZ
created: 2026-11-06T08:58:59.195463Z
updated: 2026-11-06T11:57:31.759701Z
type: task
title: 'g5 Compass runners: roll to runner 2.338.2 (GitHub retired 2.336.0)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1615
comments:
- id: 01M6RBH4R15HB96W3P4VJC8BHP
  author: Steve Vine
  at: 2026-11-06T11:57:28.705442Z
  text: |-
    Done: PR #1630 merged. Steve ran the helm upgrade at 09:33 GMT.
    - The Compass listener came straight back, with 4 runners on `ci-runner:2.338.2`.
    - The stuck 22:15 build and the next main build then ran green.
    - Image: `zot.citops.net/compass/ci-runner:2.338.2-20261106-0854`, superseded by COM-1616's `…-0948`.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
At 08:05 GMT on 2026-11-05 GitHub stopped accepting runner 2.336.0. A runner reported Outdated, and ARC took down the whole compass-runners set, including its listener. From then on every g5 job (build-tag, deploy-staging) sat queued, and main hasn't built an image since 22:15 GMT on 2026-11-05.

Fix:
- the ci-runner image was rebuilt on 2.338.2 (zot tag `2.338.2-20261106-0854`);
- the values tag is bumped;
- Steve runs `helm upgrade` on compass-runners.