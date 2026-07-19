---
id: 01KXGXJCRYHFRT707QX4K7TDBF
created: 2026-07-14T18:17:32.190392427Z
updated: 2026-07-14T18:17:41.594969487Z
type: task
title: Run integration-test Postgres with durability off (fsync, synchronous_commit)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 160
sprint: sc5mwga
assignee: steve
label:
- chore
priority: medium
task_status: done
---
The backend integration suite starts 31 module-scoped `PostgresContainer("postgres:16")` instances per run; each pays initdb + Alembic migrations, and Postgres's fsync-heavy startup dominates the job (686s of an 818s job on the g5 runners — measured <issue id="3de7fec8-9bd5-4ed2-a1c6-d4304c5e370a" href="https://linear.app/stevevine/issue/DEV-845/deploy-compass-on-new-server">DEV-845</issue>).

Pass durability-off flags to the test containers (data is disposable):

```python
PostgresContainer("postgres:16", driver="psycopg").with_command(
    "postgres -c fsync=off -c synchronous_commit=off -c full_page_writes=off"
)
```

(or a shared helper/fixture so all 31 call sites get it). Expected 20–40% off integration wall-time on SATA-backed runners; zero risk to correctness since every container is thrown away.

---
*Migrated from Linear [DEV-852](https://linear.app/stevevine/issue/DEV-852/run-integration-test-postgres-with-durability-off-fsync-synchronous) · created 2026-07-05 · completed 2026-07-05*  
*Related to (Linear): DEV-845, DEV-855*