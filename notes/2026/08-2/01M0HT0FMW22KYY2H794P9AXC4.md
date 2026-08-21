---
id: 01M0HT0FMW22KYY2H794P9AXC4
created: 2026-08-21T09:21:39.484958Z
updated: 2026-08-21T19:52:18.951245Z
type: task
title: 'Split backend-test: unit and integration as parallel jobs, shard integration'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 332
sprint: sspwpgk
blocked_by:
- 01M0HSZ4CJCS5AEBZV3RCXBRK5
comments:
- id: 01M0JY3887YZBW0QN4ZF8FV6X3
  author: Steve Vine
  at: 2026-08-21T19:52:18.951108Z
  text: |-
    Done — PR #328, squash-merged to main 2026-08-21. (Originally #323; that merge went wrong and was reverted — see below.)

    DONE: the unit suite runs in parallel. It is ~50s and needs no Docker at all; it sat in front of the integration suite for no reason but a shared checkout, so a failing unit test took the full integration wait to report. Now `backend-unit`, alongside.

    `backend-test` KEEPS its name even though it now runs only the integration suite. It is a required status check on main, and renaming a required job is a two-step protection change — PRs on the old workflow never report the new context, and with enforce_admins on, no single context set satisfies both groups. Adding a job is safe; renaming one is not. `backend-unit` has now been ADDED to the required contexts (done immediately after this merge), so the unit suite still gates.

    NOT DONE, on the measurements the task asked for: sharding the integration suite. Sharding divides the variable cost and duplicates the fixed one, and the fixed cost is large — ~46s of uv sync plus a pre-pull that is CPU-bound and reached 6m48s on a starved pod. Meanwhile COM-333 took 263s out of the suite, 197s -> 90s locally, so the half sharding would divide is now the smaller half. There is also a hard ceiling: the node's fs.inotify.max_user_instances is the default 128 and every dind daemon consumes instances; with six compass runners plus ise's, dind began reporting "failed to create watcher: too many open files" and a job hung 26 minutes. More concurrent dind jobs is the wrong direction until that sysctl is raised (needs root; Steve is doing it). Conditions for revisiting are in the job comment.

    Two defects that hang exposed, both fixed here:

    1. The pre-pull's retry loop only ever protected against a pull that FAILS. A pull that HANGS went straight past it, because docker pull had no timeout — the retry was unreachable exactly when most needed. Now bounded by `timeout 180`, and exhausting the attempts fails loudly instead of letting `docker tag` report a confusing "No such image".

    2. The images are now pulled from `compass/test/*` rather than the sync-managed `library/**` and `minio/**` paths. zot re-validates a synced prefix against docker.io on EVERY manifest request; measured with the WAN up but slow: library/postgres:16 200 in 4.3s, testcontainers/ryuk:0.8.1 no response in 60s, minio/minio:latest no response in 60s, compass/test/postgres:16 200 in 0.016s. Same bytes, no sync. See COM-329 for the registry-side half.

    Process note: the first attempt at this merge (#323) squash-merged with a stale head and swallowed COM-327/328/329/330/331/333/334/335 under this task's commit message. Reverted in #327 and re-merged one task at a time. Lesson recorded: verify the PR head SHA against the local branch immediately before merging.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
backend-test (~15.5 min) runs the unit suite then the integration suite sequentially in one job. Split them into parallel jobs, and shard the integration suite into two (stable split by test file) so the critical path halves again. Depends on runner concurrency (COM-326) actually allowing the jobs to run side by side — sharding on a one-job runner just queues.