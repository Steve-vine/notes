---
id: 01KXE5CKKRZ2NWZPPMKX768ZBA
created: 2026-07-13T16:36:27.896699427Z
updated: 2026-07-23T18:34:24.757196Z
type: task
title: Separate write credential — sync must not hold a mutating credential
project: 01KX671DATY39VW6GWK3M2T3DN
number: 55
sprint: sdcd2jr
assignee: steve
priority: medium
task_status: done
---
**DONE 2026-07-14.** Sync and the executor are now genuinely separate principals.

`System.write_credential_ref` (migration 0011), used only by the change executor. NOT backfilled: every existing system got NULL, meaning **ISE cannot change it** until an admin grants write on purpose. The executor REFUSES without a write credential rather than falling back to the read one — a system with a perfectly good read credential and no write credential is still unchangeable, because being able to look at something is not permission to alter it.

Verified live on g5:

| principal | read the cluster | change ise-acceptance | change anything else |
|---|---|---|---|
| ise-connector-ro (sync) | yes | no | no |
| ise-connector-rw (executor) | **no** | yes | no |

The `ise-connector-rw-read` ClusterRoleBinding — which existed only because ONE credential had to do both jobs — has been removed from the cluster and the manifest (PR #60). The write identity cannot see the cluster at all.

Sync still works after that removal, which is itself the proof that the read slot holds the read-only principal: nothing else can read the cluster any more. Had the wrong kubeconfig gone in, sync would have gone red the moment the binding came off.

Not verified live (deliberately, Steve's call): the executor authenticating with the new g5-write credential against the real cluster. Covered by three integration tests, and a bad credential would surface as a clean `failed` record rather than a crash. I declined to fabricate an approved ProposedChange directly in the database to force the test — writing an "approved" change straight into the DB, bypassing the approval state machine, is precisely the attack the whole design exists to prevent.