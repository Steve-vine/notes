---
id: 01KZ3Q84C3YHQM9SF2GJC8YY3Y
created: 2026-08-03T11:48:20.483441Z
updated: 2026-08-06T08:15:59.17177Z
type: task
title: Connector-declared sweep cadence replaces hand-added beat entries
project: 01KX671DATY39VW6GWK3M2T3DN
number: 498
sprint: shk7zaj
comments:
- id: 01KZ9RSDW8HPYWC2RNQ45QJX7P
  author: Steve Vine
  at: 2026-08-05T20:10:42.440407Z
  text: |-
    Built — PR #486 (feature/ise-498-declared-sweeps → main), ADR 0085. Independent of the other four.

    WHAT LANDED
    - `Connector.sweep_specs()` returns `SweepSpec`s (name / task / interval / description); `ISE_api.sweeps` derives BOTH the Beat schedule and the worker's `include` list from them. Declaring the sweep IS registering it.
    - `worker.py`: −38/+19. Its per-integration knowledge is gone entirely — it now lists core task modules and core Beat entries and merges what the registry declares.

    WHY BOTH HALVES MATTERED
    The two hand edits were independently forgettable and fail DIFFERENTLY. Miss the Beat entry and the sweep silently never runs. Miss the `include` and Celery discards the task as UNREGISTERED — the entry fires, nothing happens, and no error reaches anyone. That second one has bitten this codebase before (the analyse-issue bug: the Analyse button enqueued a task the worker had never imported, so it vanished and the UI hung), which is why a test already guards the include list. Deriving both from one declaration removes the failure mode by construction rather than by a test somebody has to remember.

    FOUR PROPERTIES
    1. The declared number is the DISPATCH cadence. Each task is a cheap fan-out gated by a per-item interval that stays in settings, where an admin can see it — nothing previously configurable moved into code.
    2. The State toggle still gates the work (ADR 0072). A test holds every declared sweep's due-selection to filtering on `System.enabled` — a disabled integration must stop being POLLED, not merely stop being displayed.
    3. Sweeps are per-CAPABILITY, so two connectors declaring the same one is normal and dedupes. Declaring the same NAME differently raises: a schedule holds one entry, and which one won would depend on registry import order.
    4. Declared sweeps merge LAST, so a name collision would silently replace the heartbeat. The guard is an explicit disjointness test, not the merge order — ordering created the hazard, so it cannot also be the defence.

    NOTHING ABOUT THE RUNNING SCHEDULE MOVED
    Same four names, same tasks, same intervals, and a test pins that against the pre-change values. The point is where the cadence is written down, not what it is — and it now sits next to the capability it serves, where the comment explaining why status pages tick every minute and documents every hour is read by whoever changes that capability.

    Full backend suite green locally: 2352 passed. Frontend: 617 passed. ruff/mypy strict/eslint/prettier/build clean. No API surface change, so no OpenAPI regen.

    ADR 0085 also records why the remaining hand-maintained core task list stays explicit: it is platform machinery (reaping, pruning, dispatching), not integration surface, and a generic mechanism there would obscure what the scheduler does rather than decouple anything.
assignee: steve
priority: medium
task_status: done
---
The four per-connector Celery beat entries in `worker.py` (`sweep-freshservice-tickets`, `sync-repos`, `check-status-pages`, `scrape-documents`) become declarations the connector/capability makes (extend `sync_spec()` or a sweep spec), dispatched by a generic scheduler loop like `dispatch-syncs`. A new connector needing its own cadence no longer edits `worker.py` or the `include=[...]` list. ADR 0072 State-toggle gating must hold on the generic path.