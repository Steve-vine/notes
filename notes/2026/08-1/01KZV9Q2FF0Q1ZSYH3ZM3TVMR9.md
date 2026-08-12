---
id: 01KZV9Q2FF0Q1ZSYH3ZM3TVMR9
created: 2026-08-12T15:33:36.367334Z
updated: 2026-08-12T15:35:20.998387Z
type: task
title: Define and stamp the RedVektor product version scheme
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 3
sprint: sw9wx5e
assignee: steve
imported_from: linear
label: null
priority: null
task_status: backlog
---
No product-level semver exists for RedVektor. The deployable components carry `0.0.0` placeholders (`chart/Chart.yaml` `appVersion`, `app/backend` pyproject, `app/frontend` package.json); there are no git tags and no releases. The only intentionally-versioned artefacts are the **engine event spec** (`1.1.0`, per ADR 030) and the **SDK** `redvektor-engine` (`0.1.0`) — both are contract/library artefacts, deliberately independent of each other and of the platform.

## To specify

* The single number that represents "RedVektor the platform" and where it is the source of truth (likely `chart/Chart.yaml` `appVersion`, with backend/frontend tracking it; `GIT_SHA` stays the build stamp).
* How the product version relates to the independently-versioned engine spec and SDK (they do **not** move in lockstep with it).
* Tagging / release convention (git tags, GitHub releases) once there's a cadence.
* How the version surfaces at runtime (e.g. a `/version` or `/health` field, frontend footer).

## Interim convention (agreed 2026-06-06)

Milestone-derived working version: **Milestone N →** `0.N.0`. Currently `0.6.0` (the M6 / M6.5 line); M7 → `0.7.0`, and so on. `1.0.0` reserved for the first real release (≈ end of M7, "engines complete"). This is a convention for now — actually stamping it into the components is part of this issue's deliverable, so the placeholders stay at `0.0.0` until the scheme is settled.

## Out of scope

Release automation / per-component publishing — follows once the number is defined.

---

Imported from Linear [DEV-331](https://linear.app/stevevine/issue/DEV-331/define-and-stamp-the-redvektor-product-version-scheme)