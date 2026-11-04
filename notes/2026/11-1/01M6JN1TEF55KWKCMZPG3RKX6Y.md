---
id: 01M6JN1TEF55KWKCMZPG3RKX6Y
created: 2026-11-04T06:48:25.807942Z
updated: 2026-11-04T06:48:31.08977Z
type: task
title: A rotation recorded before someone asked for one doesn't meet the request — an incident's (or a leaver's) "rotate by" stays open until a rotation after the ask
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1582
sprint: sjrd5gz
assignee: steve
label:
- bug
priority: high
task_status: active
---
Sprint "Secrets - New Module" (ADR 0141). Found in Claude's pre-UAT of COM-1579 on staging, 2026-11-04.

## What happens

On INC-44 in E2E Test Company:
- SEC-2's rotation was recorded at 06:47.
- Someone then asked for SEC-2 and SEC-3 to be rotated by tomorrow.
- SEC-2 showed **Rotated · recorded** at once. It got no *Rotate* action, and the card read "1 of 2 rotated" before anyone had done anything.

A request compares only days, so any rotation earlier that day counts as meeting it. The same happens to a leaver's secret rotated earlier on the day the leaver completes.

## What should happen

A request is met only by a rotation recorded **after** it was asked, for a day on or after the day it was asked. A date someone types in (Last rotated on) meets it only if it's later than the day it was asked.

## Notes (technical)

- `DueInputs.open_requests`: compare each rotation's `recorded_at` with the request's `created_at`, plus `rotated_on >= asked_on`. A typed `last_rotated_on` must be after `asked_on`.
- The incident card's `rotated` should use the same rule.
- Add a test: a rotation recorded, then an ask the same day, then the request is still open.

**Chain:** independent (no migration or API change).

**Done when:** on staging, in E2E Test Company:
- asking for a just-rotated secret gives its owner a *Rotate* action;
- the card reads "0 of 2 rotated" until a rotation is recorded after the ask.