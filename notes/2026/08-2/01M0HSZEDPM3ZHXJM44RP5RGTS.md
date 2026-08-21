---
id: 01M0HSZEDPM3ZHXJM44RP5RGTS
created: 2026-08-21T09:21:05.462829Z
updated: 2026-08-21T21:19:13.578677Z
type: task
title: zot registry health under CI load
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 329
sprint: sspwpgk
comments:
- id: 01M0JWTH1SCWZHAV0KWX1TF07S
  author: Steve Vine
  at: 2026-08-21T19:30:04.473791Z
  text: |-
    Done — PR #319, squash-merged to main 2026-08-21. Applied to the cluster and verified.

    The 502s and the 14 restarts turned out to be two separate faults, both found by watching them happen.

    FAULT 1 — zot was being killed before it could finish starting. On startup zot parses the whole storage tree to build its metadb ("parsing next repo 'ise/backend', total: 28"), and with 28 repos that takes well over two minutes. The chart's startup budget is initialDelay 5 + failureThreshold 3 x period 10 = 35 SECONDS, after which the kubelet kills it. It never had a chance. Caught in the act while applying the fix: container up 16:53:22, still parsing repo 8 of 28 at 16:54:34, killed at 16:55:22, exit code 2 — the same signature as all 14 historical restarts. Every kill is a window where a CI pull gets a 502 from traefik with nothing behind it.

    failureThreshold 3 -> 60 gives it ten minutes. Generous on purpose: liveness is not armed until the startup probe passes, so a high threshold costs nothing, and the parse gets slower with every repo added. After the change all 28 repos parse and restarts are 0.

    FAULT 2 — a synced prefix is re-validated against docker.io on EVERY manifest request, cached or not. For testcontainers/ryuk and minio/minio that re-sync outlived traefik's response timeout, so each request 502'd, the client retried, and the copy started over. This is the loop the ryuk pull died in on 2026-08-20, and it cost three CI jobs twenty minutes apiece today before I understood it — I could watch "trying to get updated image by syncing on demand" followed by a stream of "Copy layer" that never finished in time.

    Both are pinned test dependencies, already stored, and should not change without someone deciding they should, so they were removed from the sync allow-list. Unlisted, zot serves them from local storage:

      testcontainers/ryuk:0.8.1   502 (timeout)  ->  200 in 0.014s
      minio/minio:latest          502 (timeout)  ->  200 in 0.014s

    library/** and nginxinc/** stay listed — those are base images pulled through the docker.io mirror during buildx builds, where a Dockerfile bumping its base tag genuinely does need a fetch.

    Also: zot had NO resource requests at all, making it BestEffort — lowest scheduling priority, first to be evicted — for the process every runner depends on. The same fault COM-326 found on the runner pods. At rest it uses 2m CPU / 340Mi, so the request is a floor that costs nothing.

    Values are now checked in (scripts/infra/zot-values.yaml) rather than existing only as whatever was last typed at a helm upgrade.

    Recorded but not fixed: the liveness and readiness probes are hardcoded in the chart with no timeoutSeconds, so they inherit Kubernetes' 1-second default — a registry streaming layers to six concurrent jobs can miss that. No chart value exposes it; the kubectl patch is in the README. And zot's storage.fastRestart would remove the startup parse altogether, but its consistency trade-off is not something to take on trust while fixing an outage.

    One self-inflicted lesson worth noting: bouncing zot for this upgrade killed an in-flight CI job with a 503 four seconds after the container start. Don't helm upgrade zot while CI is running.
assignee: steve
label:
- chore
priority: medium
task_status: done
---
zot 502'd repeatedly during the 2026-08-20 evening merge trains (testcontainers ryuk pull failed 5 retries; a backend-test run died on it). zot is now load-bearing: pull-through mirror, base images, buildx layer cache. Check its resource limits, liveness, and concurrent-request behaviour; size it for 2–4 concurrent jobs (pairs with the runner-concurrency task).