---
id: 01M1PVCBNRZNPPGCPBG40XZPPX
created: 2026-09-04T18:37:31.192683Z
updated: 2026-09-04T19:15:29.693051Z
type: task
title: An integration can say 'error' and never say why
project: 01KX671DATY39VW6GWK3M2T3DN
number: 778
sprint: s7nj09w
assignee: steve
label:
- bug
priority: high
task_status: todo
tech: null
---
Smoke finding, 2026-09-04. EntraID showed `error` on the Integrations screen with
no reason given anywhere in the app. The cause was transient cluster DNS; the
defect is that ISE had the explanation and threw it away.

**What happened.** Between 17:28 and 18:25 the worker pod hit 75
`[Errno -3] Temporary failure in name resolution` failures across five
integrations (CSP Softcat 30, EntraID 17, DataDog 9, Cloudflare 6, 13
unattributed). EntraID's `health_check` reads `/organization`
(`connectors/entraid.py:453-461`); with DNS down that raises `httpx.ConnectError`
and returns `HealthResult(status="error", detail=<the DNS error>)`. It has since
recovered on its own — `health` went back to `connected` at 18:35:45 once the
next sync completed.

**Why the screen could not explain it.** The sync's SUCCESS path
(`sync.py:487-489`) does this:

```python
system.health = health.status      # "error", from the health check
system.last_synced_at = now
system.last_sync_error = None      # cleared in the same breath
```

The EntraID connector degrades gracefully — every failed slice is a
`logger.warning`, nothing raises — so the sync genuinely succeeded and took the
success path. That path adopts the health check's *status* and discards its
*detail*. `HealthResult.detail` is never persisted by a sync at all: there is no
`health_detail` column on `system`, and the only consumer of the field is
`credentials_api.py:148`, which returns it inline from a manual verify.

The audit trail shows the shape exactly:

```
synced   18:35:45   health=connected   error=
synced   18:17:42   health=error       error=
synced   17:43:31   health=error       error=
synced   17:19:12   health=connected   error=
```

Two `synced` events carrying `health: error` and an empty `error` field. The
action is `synced`, not `sync_failed`, because nothing failed — and so
`last_sync_error`, the one field the UI has to explain an error state, is
correctly empty and useless. The only record of the DNS failure is a
`logger.warning` in the Platform Log, on a different screen, not linked to the
integration.

**This is reachable by any connector.** Every `health_check` returns a
`HealthResult` with a detail string, and every one of those details is dropped on
the sync path. Any health-check failure that does not also fail the sync produces
the same silent `error`.

**Proposed**

- Persist the health check's detail. A `health_detail` column on `system`,
  written alongside `health` on every sync, is the smallest fix — the value
  already exists and is already computed.
- Show it on the Integrations screen wherever `error` is displayed. An error
  state with nothing to click is worse than no state: it tells an operator to go
  looking without saying where.
- Put it in the audit `details` too. A `synced` event that records
  `health: error` and no reason cannot be diagnosed after the fact, which is
  exactly the situation this finding started from.
- Distinguish "the sync worked but the health probe failed" from "the sync
  failed". They are different events and currently render identically.
  ISE-750 established that an integration must not report health it has not
  checked; the mirror of that is that a failed check must say what it found.

**Notes for the ops side, not this task**

- `g5` runs a **single CoreDNS replica** (`coredns-c46df69ff-wfxgq`, 1/1, one
  restart 4d ago). Every integration that reaches an external API depends on it,
  and this outage took out five at once. Worth a second replica.
- The failure fired an `integration_broken` notification at 18:17:43, which was
  then dropped: "email notification channels were skipped because ISE cannot
  send email — the SendGrid Staging integration is disabled". So a 20-minute
  transient would have paged someone had email been live. Whether a health probe
  should trip `integration_broken` on its first failure, or need two consecutive
  ones, is worth deciding separately.
