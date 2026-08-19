---
id: 01M0D4149WAH44RW6PD38EYAFT
created: 2026-08-19T13:40:34.236855Z
updated: 2026-08-19T17:18:07.47125Z
type: task
title: Recert schedules — entity, CRUD, owners with attestation policy, Beat trigger
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 281
sprint: s5gwx0s
blocked_by:
- 01M0D40S596DN12V0MQY5YT7J0
comments:
- id: 01M0DGFDJEAYXZ3Y6YT3AKHQGV
  author: Steve Vine
  at: 2026-08-19T17:18:05.390766Z
  text: |-
    Merged to main in PR #280. The ADR 0047 schedule entity landed:

    - **Model (migration 0080)**: recert_schedules (name, group/business-role target, description, recertifier-facing instructions, cadence weekly→annually + start date, minimum attestations, enabled, soft-delete only — instances reference it and evidence must keep reading) + recert_schedule_owners (Required flag, provenance from_entity_owner|added) + a minimal recert_instances (the (schedule, period) dedupe record). All audited; recert_scope_kind reused with create_type=False; user_role gained **recertifier** (portal-only set).
    - **Owner policy**: owner-defaults endpoint resolves the entity's owners for the form prefill (unresolvable Entra owners surfaced as a warning, never dropped); ≥1 owner, minimum ≤ owner count, active users; becoming an owner auto-grants recertifier to a user holding nothing else.
    - **Trigger**: Beat entry trigger-recert-schedules (daily) walks enabled schedules — due when the start-date+cadence boundary arrives (weekly by days, months with day clamping). Trigger now fires the same path, recorded manual, never shifting the arithmetic; a covered period 409s. The v1 opener left the Beat schedule; historical campaigns stay readable.
    - **UI**: the Recertification area became the Schedules tab — list with next-due derivation, Add schedule, edit modal with Trigger now / Disable / Delete.
assignee: steve
label:
- feature
priority: high
task_status: review
---
The schedule entity and its lifecycle, per the v2 ADR.

* **Model**: `recert_schedules` — name, entity type (`group | business_role`) + entity ref, description, instructions, cadence (`weekly | monthly | quarterly | bi_annually | annually`) + start date, enabled flag; child `recert_schedule_owners` — Compass user FK, `required` flag, provenance (`from_entity_owner | added`); schedule-level `minimum_attestations`. Audited (`_AUDITED_TABLES`) — schedule and owner-policy edits are governance changes.
* **Owner rules**: on create/entity change, prefill from the group's mirrored owners / the role's owner (matched to Compass users; unresolvable Entra owners warn at save); additional owners addable from Compass users. Adding an owner **auto-grants the portal `recertifier` role** if they hold nothing broader; validation: ≥1 owner, all Required owners are active users, `minimum_attestations ≤ owner count`.
* **API + UI**: CRUD under the Access section — the Recertification area becomes a single **Schedules** tab listing schedules (name, entity, cadence, next due derived from start date + cadence, owners, enabled state) with **Add schedule**; clicking a row opens the **edit modal** with **Disable** and **Delete** (delete guarded: schedules with triggered instances soft-delete, preserving evidence; never orphan history).
* **Trigger**: the Beat opener re-written to walk enabled schedules — due when the period derived from start date + cadence arrives; dedupe key `(schedule, period)` so re-runs create nothing. **Trigger now** button fires the same code path immediately (recorded as manually triggered; doesn't shift the schedule's period arithmetic).
* Migration coordination as ever — take numbers late.

Refs: the v2 inception ADR, COM-241 (opener being replaced), ADR 0006, 0023.