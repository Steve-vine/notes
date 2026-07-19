---
id: 01KXGXK15VQSMBNK5Z8V3ARXMP
created: 2026-07-14T18:17:53.083570634Z
updated: 2026-07-19T21:30:31.107624855Z
type: task
title: Parallelise backend integration tests with pytest-xdist
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 161
sprint: sc5mwga
assignee: steve
task_status: done
priority: medium
---
The integration suite runs its 31 test modules serially (single pytest process) while the g5 runner node sits at ~8% CPU of 16 cores (measured <issue id="3de7fec8-9bd5-4ed2-a1c6-d4304c5e370a" href="https://linear.app/stevevine/issue/DEV-845/deploy-compass-on-new-server">DEV-845</issue>). Each module already owns its own PostgresContainer, so modules are isolation-safe by construction.

Add `pytest-xdist` to dev extras and run the integration step with `-n 4` (workers = concurrent Postgres containers; RAM comfortably supports 4). Expected to cut the 686s integration step towards ~250s. Watch disk utilisation when raising `-n` — the SATA SSD was at ~60% util with one worker; pairs well with the fsync=off issue.

---
*Migrated from Linear [DEV-853](https://linear.app/stevevine/issue/DEV-853/parallelise-backend-integration-tests-with-pytest-xdist) · created 2026-07-05 · completed 2026-07-05*  
*Related to (Linear): DEV-845, DEV-855*