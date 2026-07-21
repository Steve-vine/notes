---
id: 01KY0EYA98HPD3KXMXK5R1HGG6
created: 2026-07-20T19:09:45.128016Z
updated: 2026-07-21T08:39:05.931681Z
type: task
title: 'System page: move Sync now into the Connector card + sync schedule toggle/cadence to match Observation detection'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 166
order: 4.0
sprint: skj7tft
assignee: steve
priority: medium
task_status: done
---
On the system detail page (`SystemDetailPage.tsx`) the "Sync now" button sits in the page header, disconnected from its loop — while the Connector card already carries all the sync loop's config and status (connector type, enabled, sync interval, last sync, last sync error), and the Observation detection card established the pattern of co-locating a loop's schedule, toggle and "Run now" trigger in one card. Make the two loop cards symmetric.

## Changes

1. **Move "Sync now" into the Connector card** (`ConfigSummary`, ~:328) — same placement as the Obs card's "Run now" (top-right of the card header, operator-gated, disabled when the integration is disabled).
2. **Add a schedule toggle + cadence select to the Connector card**, mirroring the Observation detection card's controls (`ObservationDetectionCard`, ~:212): "Scheduled sync" toggle (admin) + interval select. Replaces the read-only "Sync interval" row.
3. **"Run analysis" is removed entirely by ISE-167** (retire system-scoped analysis) — no relocation needed. After both tasks the header carries identity + health + last-synced only, with no action buttons. Coordinate if the two tasks land in the same sprint: this task must not reintroduce or move the button.

## Backend

Probably none. `PATCH /api/v1/systems/{system_id}` already accepts `sync_interval_seconds` (`SystemUpdate`, `schemas.py:42`, min 30), and the scheduler gate is `enabled AND sync_interval_seconds IS NOT NULL` (`sync.py:40`) — the UI already renders null as "Not scheduled". So the toggle can be modelled as clearing/setting the interval (off = null). Decide at implementation whether a dedicated `sync_schedule_enabled` boolean (symmetric with `obs_detection_enabled`) is worth a migration — leaning no, since interval-null already encodes it and remembers nothing worth keeping.

Note: `enabled` is the whole-integration switch (gates manual sync too) — the new toggle governs the *schedule* only; don't conflate them.

## Cadence options

Sync is the fast loop — offer sensible fast presets (e.g. 1m / 5m / 15m / hourly) rather than reusing the Obs Loop's hourly/6h/daily set. Match existing seeded intervals so no system's current value renders as unselectable.

## Verification

Both loop cards read identically (title · schedule toggle · cadence · run-now); header has no action buttons; SystemDetailPage tests updated; DataDog tile (no `observations` capability) still shows only the Connector card, Kubernetes shows both.