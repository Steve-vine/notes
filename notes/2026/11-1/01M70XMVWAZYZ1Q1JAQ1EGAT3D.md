---
id: 01M70XMVWAZYZ1Q1JAQ1EGAT3D
created: 2026-11-09T19:48:00.522251Z
updated: 2026-11-10T11:41:08.374854Z
type: task
title: Shared-mailbox sync loses its error when Exchange's message contains a null byte — the job shows Failed instead of saying what Exchange said
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1657
comments:
- id: 01M72B4WG8X54M0XGCDGCKA0PH
  author: Steve Vine
  at: 2026-11-10T09:03:11.368253Z
  text: |-
    **Done: merged to main in PR #1671.**

    **What it does:** Exchange's words never carry a null byte into Compass any more.
    - Any Exchange error has its null bytes dropped where it's made, so the mailbox sync, the list-sender sync and the Exchange health check all save clean text.
    - The per-change results read back from Exchange (mailbox access, list membership, list rights) are cleaned the same way.

    The job now ends as a recorded Exchange failure with its reason, not as "Failed" with a database error.

    **Tests:**
    - A unit test: an Exchange error made from UTF-16-style text ("A\0c\0c\0e\0s\0s\0 denied") reads "Access denied".
    - The shared-mailbox sync test now runs a refusal whose message holds a null byte through the real task against Postgres. The reason is recorded and nothing raises.

    **On staging:** nothing to do unless Exchange sends such a message again; it would show its reason on the mailbox card.
assignee: steve
label:
- bug
priority: low
task_status: done
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