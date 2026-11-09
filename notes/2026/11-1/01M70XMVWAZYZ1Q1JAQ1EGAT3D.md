---
id: 01M70XMVWAZYZ1Q1JAQ1EGAT3D
created: 2026-11-09T19:48:00.522251Z
updated: 2026-11-09T19:48:00.522251Z
type: task
title: Shared-mailbox sync loses its error when Exchange's message contains a null byte — the job shows Failed instead of saying what Exchange said
assignee: steve
priority: low
task_status: todo
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1657
---
Found 2026-11-09 during a staging health check. Low priority: one occurrence at 11:53 GMT, and every run since has been fine.

## What people see

- Today: when the Exchange script fails with a message that contains a null byte, Compass can't save the message. The job shows **Failed** with a database error, and the mailbox card has no reason.
- After: the reason is saved without the null bytes, and the job ends as a recorded Exchange failure, as it does for any other Exchange error.

## Notes (technical)

- `tasks/mailbox_sync.py _record_failure` stores `str(ExchangeError)` in `last_error`. Postgres text can't hold 0x00, so the save raised `DataError: PostgreSQL text fields cannot contain NUL (0x00) bytes` (Celery result d74473c8…).
- Likely cause: UTF-16 or raw PowerShell stderr in the message. Strip `\x00` where `core/exchange.run_exchange_script` builds the `ExchangeError` message, so every caller gets clean text. Also check the other Exchange callers that save error text: list sender sync and exchange health.

**Chain:** independent.

**Done when:** a unit test with an `ExchangeError` whose message contains `\x00` records the failure without raising.