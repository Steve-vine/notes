---
id: 01M8GQ2M65C4ZYHPCFFMZN6KXH
created: 2026-11-28T09:16:44.101469Z
updated: 2026-11-28T12:58:55.00977Z
type: task
title: 'Collection feeds from a SQL Server database: rows into Inventory, Vulnerabilities or Secrets through each area''s own rules'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2229
sprint: s09wwd3
comments:
- id: 01M8H3SDJQC58A0YZYK5JQ5KMN
  author: Steve Vine
  at: 2026-11-28T12:58:53.911583Z
  text: |-
    Done in PR #2237 (merged). A feed on a SQL Server Collection integration reads with SELECTs: each read on the feed screen is a SELECT box, and every row becomes an item. Rows go into the area's slots exactly as a web service's items do, and close the same ways: by a status column, or "a complete read that no longer has it". Preview shows the rows and what each would become, saving nothing.
    For only what's changed, the SELECT filters on @Since (e.g. WHERE ModifiedAt >= @Since). Compass fills in the start of the last good run, or 1 January 1900 on a full read, and reads everything every so many days (7 unless set).
    Polaris's feed design job and chat tools know how to write a database feed, and its "try a read" runs a SELECT.
    Tested against a real SQL Server: a feed brought three rows into Inventory, a row deleted from the database closed on the next run, and @Since read only what had changed.
assignee: steve
label:
- feature
priority: low
task_status: review
---
**On the chain.** After the Server-family Collection integration task. ADR 0147 (feeds are configuration, never code that knows a service).

## What people see
- A feed on a Server ▸ SQL Server database Collection integration reads with a **SELECT** instead of web requests. Its rows map into the area's slots exactly as a web service's items do. For example, the CRM's accounts become Inventory software accounts, or a patch table becomes Vulnerabilities.
- Closing works as for web feeds: by a status column, or "a complete read that no longer has it".
- Previewing a feed shows the rows and what each would become, before anything is saved.
- Incremental reads: the SELECT can be given "changed since the last good run" as a value.

**Done when:** on staging, a feed from the test database brings its rows into Inventory as software accounts, and a row deleted from the database closes on the next run.