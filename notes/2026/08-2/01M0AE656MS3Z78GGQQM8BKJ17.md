---
id: 01M0AE656MS3Z78GGQQM8BKJ17
created: 2026-08-18T12:40:21.460909Z
updated: 2026-08-18T21:11:48.189373Z
type: task
title: Amend-and-validate never patches the existing object — adopt-by-name swallows the correction
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 246
sprint: s5gwx0s
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Smoke finding, Sprint 34 (2026-08-18). Reproduced twice on staging (requests bd693148→e2569fed and 756ac6d7→936e9e7f).

An expedited `group_create` was amended-and-validated with a corrected **description** (same name). `_execute_group_create`'s idempotency lookup (`GET /groups?$filter=displayName eq '<name>'`) found the group the original created, **adopted it as already-applied and never PATCHed it** — subject `applied`, amendment `executed`, original `amended`, zero tenant-side writes (ledger confirms: no change rows for the amendments). The validator believes their correction landed; it didn't. Adopt-by-name is correct for at-least-once *creation* but wrong for *amendment* semantics — and the inverse hurts too: an amendment changing the **name** would create a second group instead of renaming, and a joiner amendment correcting a display name no-ops the same way (adopt-by-UPN, no patch).

Proposed fix in `tasks/access_execute.py`:
- When `request.amends_request_id` is set, resolve the **target object from the original request's ledger** (`access_changes` row: `group_created`/`user_created` → object id) and **PATCH** it (displayName/description; joiner display fields) instead of create-or-adopt; mirror the change immediately; write a new ledger `change_kind` (e.g. `group_updated` / `user_updated` — enum + migration).
- Where nothing actually changed, the outcome must say so ("already matches — nothing to change"), never imply the correction applied.
- Tests: amendment-changes-description → PATCH asserted on the fake tenant + ledger row; amendment-changes-name → rename not duplicate; joiner display-name amendment.

This undermines the §6 "two humans have seen the end state" guarantee, hence high priority.

Refs: ADR 0045 §6; `_execute_group_create` / `_execute_joiner`; `amend_request` in `api/v1/access_requests.py`.