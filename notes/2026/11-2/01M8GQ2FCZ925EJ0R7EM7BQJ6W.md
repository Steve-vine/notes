---
id: 01M8GQ2FCZ925EJ0R7EM7BQJ6W
created: 2026-11-28T09:16:39.199926Z
updated: 2026-11-28T12:44:41.714126Z
type: task
title: 'Collection integration of the Server family: a SQL Server database read with a login Compass proves can''t write; a check is a SELECT'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2228
sprint: s09wwd3
comments:
- id: 01M8H2ZCD87XAWKN5K2A8QRRW9
  author: Steve Vine
  at: 2026-11-28T12:44:40.744129Z
  text: |-
    Done in PR #2236 (merged). Admin ▸ Integrations ▸ Collection ▸ Add ▸ Server ▸ SQL Server database takes the address, port, database, encryption and a trusted certificate. Each company's account gives its own login (Login / Password).
    Test connection, run from the worker, asks SQL Server what the login may do. It looks at the writing roles (db_owner, db_datawriter, db_ddladmin and so on), any right on the database or server beyond reading, and any write right on a schema, table, view or procedure. A login that could change anything is refused: "This login can change things in CRM. Give Compass a login that can only read (db_datareader), so evidence can't alter what it collects (it is a member of db_datawriter)". The same check runs before every read, and nothing is read through a login that fails it.
    A check on it is one SELECT: each row is an item and its columns are the fields. A period check can filter on @PeriodStart and @PeriodEnd, which Compass fills in as values. Anything else (INSERT, UPDATE, DELETE, EXEC, SELECT INTO, two statements, an unknown @name) is refused before it's sent. Every read runs in a transaction that's always undone, with a time limit and a row limit.
    Polaris's design job and chat tools know how to write such a check; its first pass, which samples a web service's endpoints, skips databases.
    One login is never used for both: an action integration can't use a Collection login on the same database, and the other way round.
    Tested against a real SQL Server: a read-only login passes, a writer is refused, rows come back as items, and the period values work. Still to see on staging: a workflow judging those items. Workflows read captured items the same way whatever their source.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**On the chain.** After the Scripting phase 2 ADR and the Web/API-or-Server task. ADR 0154 (evidence reads only through credentials that can't change anything).

## What people see
- **Admin ▸ Integrations ▸ Collection ▸ Add ▸ Server ▸ SQL Server database**: the address, port, database, login, encryption and trusted certificate, as for the action kind. Each company's account gives its own login.
- **Test connection proves the login only reads.** It signs in and asks the server what the login may do. If it may insert, update, delete, run procedures or change anything, it's refused: "This login can change things in CRM. Give Compass a login that can only read (db_datareader), so evidence can't alter what it collects."
- It reads **Read only**, like every Collection integration. The same server may have a separate **action** integration with its own login; the two are never the same record.
- **A collected check on it is a SELECT.**
  - Each row is a captured item, its columns the item's fields. Inputs are bound as values, never pasted into the text.
  - A period check (ADR 0153) gets its period's start and end as values to filter on.
  - Preview shows what the SELECT returns before the check is saved.
  - Workflows judge the items exactly as they judge items from a web service.
- A SELECT has a time limit and a row limit. It runs in a transaction that is always rolled back, so it can't change anything even if a login ever could.
- Polaris can draft such a check from a description, as it does for web service checks. A person approves the first capture (ADR 0142).

**Done when:** on staging, an admin adds a read-only SQL Server Collection integration (a login that can write is refused, with the reason); a check selecting accounts from the test database captures one item per row; and a workflow judges them.