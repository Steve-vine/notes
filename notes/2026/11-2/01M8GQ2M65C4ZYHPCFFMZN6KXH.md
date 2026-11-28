---
id: 01M8GQ2M65C4ZYHPCFFMZN6KXH
created: 2026-11-28T09:16:44.101469Z
updated: 2026-11-28T09:16:44.101469Z
type: task
title: 'Collection feeds from a SQL Server database: rows into Inventory, Vulnerabilities or Secrets through each area''s own rules'
task_status: todo
label: feature
priority: low
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2229
---
**On the chain.** After the Server-family Collection integration task. ADR 0147 (feeds are configuration, never code that knows a service).

## What people see
- A feed on a Server ▸ SQL Server database Collection integration reads with a **SELECT** instead of web requests. Its rows map into the area's slots exactly as a web service's items do. For example, the CRM's accounts become Inventory software accounts, or a patch table becomes Vulnerabilities.
- Closing works as for web feeds: by a status column, or "a complete read that no longer has it".
- Previewing a feed shows the rows and what each would become, before anything is saved.
- Incremental reads: the SELECT can be given "changed since the last good run" as a value.

**Done when:** on staging, a feed from the test database brings its rows into Inventory as software accounts, and a row deleted from the database closes on the next run.