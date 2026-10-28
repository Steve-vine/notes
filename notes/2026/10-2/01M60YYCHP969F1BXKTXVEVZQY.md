---
id: 01M60YYCHP969F1BXKTXVEVZQY
created: 2026-10-28T09:54:59.254656Z
updated: 2026-10-28T13:05:10.21668Z
type: task
title: Buttons a person waits on never queue behind a sync — Nessus Test and Refresh, and Active Directory's Test, get their own worker lane
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1391
sprint: ssp4evc
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Sprint 92, Vulnerabilities - Scanner sources. Found by Steve on staging, 2026-10-28, after COM-1389.

## What's wrong

Steve pressed **Test** on the Nessus tile and got "The worker did not answer in time — is it running?" The worker was running. Both of its job slots were busy with routine syncs: an Exchange shared-mailbox sync, and a Microsoft Graph audit read that Microsoft was throttling. The Test waited about two minutes for a free slot; the page gives up after 45 seconds. The Test then passed (Nessus Expert 19.18.5, 69 scans), but nobody saw it. Active Directory's Test has the same weakness.

## What changes

- The checks a person waits on run in a worker lane of their own, so they never wait behind a sync. They answer in seconds even while long syncs run:
  - Nessus Test;
  - Nessus Refresh (the list of scans);
  - Active Directory's Test;
  - the directory connection scope check.
- Nothing else changes for the person: same buttons, same messages.

## Notes (technical)

- The default consumer is `--concurrency=2`, and long tasks fill it (`mailbox_sync.sync_shared_mailboxes`, the Graph `directoryAudits` read). The routes' `apply_async().get(timeout=45)` (`api/v1/scanners.on_worker`, `active_directory.py`, `directory_connections.py`) times out while the task sits reserved behind them.
- **Fix:** a new `interactive` queue in `celery_app.task_routes` for `scanner_health.test_nessus`, `vulnerability_sources.refresh_nessus_scans`, `ad_health.check_ad_connection_health` and `directory_connections`' scope check. A dedicated consumer container in the worker pod (`--pool=solo` or small concurrency, `-Q interactive`), like `worker-status` (ADR 0077 §4). It must be in the worker pod so it shares the network add-on's route (Twingate).
- Chart: a values block for it, with resources. Staging overlay: pin its memory (see the staging pinned-resources note). Check `top pod` after the deploy.
- Record the queue in an ADR amendment (ADR 0006 or 0077).
- Seen in worker logs: `test_nessus[e7f058e7…]` received 09:50:21, ran 09:52:27.

**Chain:** independent (no migration, no API change; chart + Celery routing).

**Done when:** on staging, Nessus Test answers within seconds while a mailbox sync is running.