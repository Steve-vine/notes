---
id: 01M0HSZ4CJCS5AEBZV3RCXBRK5
created: 2026-08-21T09:20:55.186616Z
updated: 2026-08-25T18:42:59.586907Z
type: task
title: Raise runner concurrency and pod CPU; scale xdist to match
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 326
sprint: sspwpgk
comments:
- id: 01M0JHVRVNP1GVSC17JRY5N0KS
  author: Steve Vine
  at: 2026-08-21T16:18:30.901073Z
  text: |-
    Done — PR #316, squash-merged to main 2026-08-21.

    Measured the critical path first, on PR run 32458428784 (a clean 22-minute run). Nearly six of those minutes were a job waiting for a runner rather than doing work:

      - `changes` waited 2m53s to be provisioned from cold (minRunners was 0), so every PR paid pod startup before the first line of work.
      - `backend-test` — the critical path — waited a further 3m02s for a slot. The fan-out behind `changes` is six jobs and maxRunners was 4, so two queued, and there is no way to make the slow one win that race.

    Meanwhile the node idled at ~7% CPU / 16% memory.

    Changes: minRunners 0 -> 2 (warm pool), maxRunners 4 -> 6 (the whole fan-out at once), a CPU request on the runner container (the pods ran BestEffort — first to be evicted, no guaranteed CPU share against the compass and ise workloads on the same node), and integration xdist -n 4 -> -n 6. Request with no limit, deliberately: a floor for the scheduler, not a cap, because the xdist workers want to burst.

    The scale-set values are now checked in at scripts/infra/arc-compass-runners-values.yaml rather than living only in the cluster — the sizing is load-bearing for CI wall-clock and the reasoning would not survive in anyone's head.

    Result, same workflow, next run:

                         before    after
      changes queue      2m53s     2s
      backend-test queue 3m02s     2s
      backend-test       15m34s    7m14s
      whole PR run       22m       7m27s

    Two things worth carrying forward:

    1. `sast` reads the values file as a Kubernetes pod spec — it cannot tell Helm values from a manifest — and raised run-as-non-root and allow-privilege-escalation. Both were answered rather than ignored. Note runAsNonRoot ALONE makes the kubelet refuse the container: the image's USER is the name `runner`, and a name cannot be proven non-root before start, so runAsUser: 1001 is required alongside it.

    2. Profiling backend-test turned up something the task did not anticipate: "Pre-pull test images" was 6m48s, LARGER than the integration suite itself (4m36s). It fell to 1m13s once the pod had a CPU request, so it was CPU starvation on a BestEffort pod rather than a network problem — but it means COM-332's sharding would have multiplied a cost that was really a scheduling bug. Recorded on the PR for COM-332 to pick up.
assignee: steve
company: null
label:
- improvement
priority: high
task_status: done
---
Jobs queue 2–3.5 min while the g5 node idles at ~6% CPU / 16% RAM, and two concurrent merge trains serialise behind a single runner. Raise the ARC scale-set's max concurrent runners (2–4) and the runner pod CPU request/limit, then raise the integration suite's xdist workers (`-n 4` → 6/8) to use the headroom. Expected: queue waits gone, backend-test roughly halved.