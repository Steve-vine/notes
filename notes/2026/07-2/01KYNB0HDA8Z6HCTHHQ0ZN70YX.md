---
id: 01KYNB0HDA8Z6HCTHHQ0ZN70YX
created: 2026-07-28T21:45:06.730511Z
updated: 2026-07-28T21:45:52.396823Z
type: task
title: Status page poll loop, deterministic parsers + detail page
project: 01KX671DATY39VW6GWK3M2T3DN
number: 353
sprint: s9cqr80
blocked_by:
- 01KYNB08NWNNCTA77XX6TJG5T8
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
An operator can see the last determined state of each status page and its services.

**Poll loop**
- Task module `ISE_api/tasks/status_pages.py`: beat dispatcher + per-row cadence (`due_for_check`, setting `status_page_check_interval_minutes` in `settings.py`, 0 disables). Add module to `worker.py` `include` AND `beat_schedule` (guard test `test_worker_task_registration.py` covers the include list). Fetch via httpx with module-level `build_client()` seam (GitHub/Confluence pattern, `_TIMEOUT = 30.0`).
- Store normalised state (component list w/ status + active incidents w/ impact + provider timestamps) on `StatusPage.state` + content hash; `fetch_status`/`fetch_error` on failure; stamp `last_checked_at`. Two-commit durability pattern from `tasks/repos.py` (fetch durable before anything expensive).

**Deterministic parsers**
- Atlassian Statuspage format: autodiscover `{url}/api/v2/summary.json` from the page URL; parse components + incidents + impact.
- RSS/Atom feed fallback where a feed is advertised.
- Contract tests with `httpx.MockTransport` fixtures (real Statuspage JSON + RSS samples).

**Check now**
- `POST /api/v1/status-pages/{id}/check` (Documents `scrape_now` precedent) + per-row button on the list.

**Detail page**
- `StatusPageDetailPage.tsx` (route `status-pages/:id`, model on `RepoDetailPage.tsx`): header + freshness phrase (`age_phrase` pattern), tracked services with per-service status badges, active incidents panel, untracked components collapsed, fetch-error banner, tags display.

**Acceptance**: registered Statuspage-format page shows live component state on detail within one poll interval; check-now refreshes immediately; unreachable page shows error state on list + detail, never crashes the sweep.